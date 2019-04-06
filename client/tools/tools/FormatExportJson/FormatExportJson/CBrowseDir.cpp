#include "CBrowseDir.h"
CBrowseDir::CBrowseDir()
{
	//用当前目录初始化m_szInitDir
	getcwd(m_szInitDir,_MAX_PATH);

	//如果目录的最后一个字母不是'\',则在最后加上一个'\'
	int len=strlen(m_szInitDir);
	if (m_szInitDir[len-1] != '\\')
		strcat(m_szInitDir,"\\");
}

bool CBrowseDir::SetInitDir(const char *dir)
{
	//先把dir转换为绝对路径
	if (_fullpath(m_szInitDir,dir,_MAX_PATH) == NULL)
		return false;

	//判断目录是否存在
	if (_chdir(m_szInitDir) != 0)
		return false;

	//如果目录的最后一个字母不是'\',则在最后加上一个'\'
	int len=strlen(m_szInitDir);
	if (m_szInitDir[len-1] != '\\')
		strcat(m_szInitDir,"\\");

	return true;
}

bool CBrowseDir::BeginBrowse(const char *filespec)
{
	ProcessDir(m_szInitDir,NULL);
	return BrowseDir(m_szInitDir,filespec);
}

bool CBrowseDir::BrowseDir(const char *dir,const char *filespec)
{
	_chdir(dir);

	//首先查找dir中符合要求的文件
	long hFile;
	_finddata_t fileinfo;
	if ((hFile=_findfirst(filespec,&fileinfo)) != -1)
	{
		do
		{
			//检查是不是目录
			//如果不是,则进行处理
			if (!(fileinfo.attrib & _A_SUBDIR))
			{
				char filename[_MAX_PATH];
				strcpy(filename,dir);
				strcat(filename,fileinfo.name);
				//cout << filename << endl;
				if (!ProcessFile(fileinfo.name))
					return false;
			}
		} while (_findnext(hFile,&fileinfo) == 0);
		_findclose(hFile);
	}
	//查找dir中的子目录
	//因为在处理dir中的文件时，派生类的ProcessFile有可能改变了
	//当前目录，因此还要重新设置当前目录为dir。
	//执行过_findfirst后，可能系统记录下了相关信息，因此改变目录
	//对_findnext没有影响。
	_chdir(dir);
	if ((hFile=_findfirst("*.*",&fileinfo)) != -1)
	{
		do
		{
			//检查是不是目录
			//如果是,再检查是不是 . 或 .. 
			//如果不是,进行迭代
			if ((fileinfo.attrib & _A_SUBDIR))
			{
				if (strcmp(fileinfo.name,".") != 0 && strcmp
					(fileinfo.name,"..") != 0)
				{
					char subdir[_MAX_PATH];
					strcpy(subdir,dir);
					strcat(subdir,fileinfo.name);
					strcat(subdir,"\\");
					ProcessDir(subdir,dir);
					if (!BrowseDir(subdir,filespec))
						return false;
				}
			}
		} while (_findnext(hFile,&fileinfo) == 0);
		_findclose(hFile);
	}
	return true;
}

bool CBrowseDir::ProcessFile(const char *filename)
{
	ifstream infile(filename);
	cout<<"Formatting "<<filename<<endl;
	ofstream outfile;
	string outfilename = filename;
	outfilename += "_temp.ExportJson";
	string temp;
	outfile.open(outfilename);
	while(getline(infile,temp))
	{	
		outfile<<Trim(temp)<<endl;
	}
	infile.close();
	outfile.close();
	// 删除旧文件。
	if (remove(filename)!=0)
	{
		cout<<"Delete "<<filename<<"failed."<<endl;
		return false;
	}
	
	// 重命名生成文件的名字为旧文件名称。
	if (rename(outfilename.c_str(), filename)!=0)
	{
		cout<<"Rename "<<outfilename<<"failed."<<endl;
		return false;
	}
	return true;
}
string& CBrowseDir::Trim(string &s)   
{  
	if (s.empty())   
	{  
		return s;  
	}  
	s.erase(0,s.find_first_not_of(" "));  
	s.erase(s.find_last_not_of(" ") + 1);  
	return s;  
}
void CBrowseDir::ProcessDir(const char 
	*currentdir,const char *parentdir)
{
}

//从CBrowseDir派生出的子类，用来统计目录中的文件及子目录个数
class CStatDir:public CBrowseDir
{
protected:
	int m_nFileCount;   //保存文件个数
	int m_nSubdirCount; //保存子目录个数

public:
	//缺省构造器
	CStatDir()
	{
		//初始化数据成员m_nFileCount和m_nSubdirCount
		m_nFileCount=m_nSubdirCount=0;
	}
	// 设置文件个数
	void SetFileCount(int nCount)
	{
		m_nFileCount = nCount;
	}
	//返回文件个数
	int GetFileCount()
	{
		return m_nFileCount;
	}

	//返回子目录个数
	int GetSubdirCount()
	{
		//因为进入初始目录时，也会调用函数ProcessDir，
		//所以减1后才是真正的子目录个数。
		return m_nSubdirCount-1;
	}

protected:
	//覆写虚函数ProcessFile，每调用一次，文件个数加1
	virtual bool ProcessFile(const char *filename)
	{
		m_nFileCount++;
		return CBrowseDir::ProcessFile(filename);
	}

	//覆写虚函数ProcessDir，每调用一次，子目录个数加1
	virtual void ProcessDir
		(const char *currentdir,const char *parentdir)
	{
		m_nSubdirCount++;
		CBrowseDir::ProcessDir(currentdir,parentdir);
	}
};

int main()
{
	//获取目录名
	//char buf[256];
	char   buf[1024]; 
	getcwd(buf, 1024); 
	//printf("请输入要统计的目录名:");
	//gets(buf);

	//构造类对象
	CStatDir statdir;

	//设置要遍历的目录
	if (!statdir.SetInitDir(buf))
	{
		puts("目录不存在。");
		return -1;
	}

	//开始遍历
	statdir.BeginBrowse("*.ExportJson");
	printf("Format ExportJson Files Count: %d\n",statdir.GetFileCount());
	statdir.SetFileCount(0);
	system("pause");

	statdir.BeginBrowse("*.Json");
	printf("Format Json Files Count: %d\n",statdir.GetFileCount());
	system("pause");

	return 0;
} 

