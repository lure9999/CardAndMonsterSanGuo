#include "CBrowseDir.h"
CBrowseDir::CBrowseDir()
{
	//�õ�ǰĿ¼��ʼ��m_szInitDir
	getcwd(m_szInitDir,_MAX_PATH);

	//���Ŀ¼�����һ����ĸ����'\',����������һ��'\'
	int len=strlen(m_szInitDir);
	if (m_szInitDir[len-1] != '\\')
		strcat(m_szInitDir,"\\");
}

bool CBrowseDir::SetInitDir(const char *dir)
{
	//�Ȱ�dirת��Ϊ����·��
	if (_fullpath(m_szInitDir,dir,_MAX_PATH) == NULL)
		return false;

	//�ж�Ŀ¼�Ƿ����
	if (_chdir(m_szInitDir) != 0)
		return false;

	//���Ŀ¼�����һ����ĸ����'\',����������һ��'\'
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

	//���Ȳ���dir�з���Ҫ����ļ�
	long hFile;
	_finddata_t fileinfo;
	if ((hFile=_findfirst(filespec,&fileinfo)) != -1)
	{
		do
		{
			//����ǲ���Ŀ¼
			//�������,����д���
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
	//����dir�е���Ŀ¼
	//��Ϊ�ڴ���dir�е��ļ�ʱ���������ProcessFile�п��ܸı���
	//��ǰĿ¼����˻�Ҫ�������õ�ǰĿ¼Ϊdir��
	//ִ�й�_findfirst�󣬿���ϵͳ��¼���������Ϣ����˸ı�Ŀ¼
	//��_findnextû��Ӱ�졣
	_chdir(dir);
	if ((hFile=_findfirst("*.*",&fileinfo)) != -1)
	{
		do
		{
			//����ǲ���Ŀ¼
			//�����,�ټ���ǲ��� . �� .. 
			//�������,���е���
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
	// ɾ�����ļ���
	if (remove(filename)!=0)
	{
		cout<<"Delete "<<filename<<"failed."<<endl;
		return false;
	}
	
	// �����������ļ�������Ϊ���ļ����ơ�
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

//��CBrowseDir�����������࣬����ͳ��Ŀ¼�е��ļ�����Ŀ¼����
class CStatDir:public CBrowseDir
{
protected:
	int m_nFileCount;   //�����ļ�����
	int m_nSubdirCount; //������Ŀ¼����

public:
	//ȱʡ������
	CStatDir()
	{
		//��ʼ�����ݳ�Աm_nFileCount��m_nSubdirCount
		m_nFileCount=m_nSubdirCount=0;
	}
	// �����ļ�����
	void SetFileCount(int nCount)
	{
		m_nFileCount = nCount;
	}
	//�����ļ�����
	int GetFileCount()
	{
		return m_nFileCount;
	}

	//������Ŀ¼����
	int GetSubdirCount()
	{
		//��Ϊ�����ʼĿ¼ʱ��Ҳ����ú���ProcessDir��
		//���Լ�1�������������Ŀ¼������
		return m_nSubdirCount-1;
	}

protected:
	//��д�麯��ProcessFile��ÿ����һ�Σ��ļ�������1
	virtual bool ProcessFile(const char *filename)
	{
		m_nFileCount++;
		return CBrowseDir::ProcessFile(filename);
	}

	//��д�麯��ProcessDir��ÿ����һ�Σ���Ŀ¼������1
	virtual void ProcessDir
		(const char *currentdir,const char *parentdir)
	{
		m_nSubdirCount++;
		CBrowseDir::ProcessDir(currentdir,parentdir);
	}
};

int main()
{
	//��ȡĿ¼��
	//char buf[256];
	char   buf[1024]; 
	getcwd(buf, 1024); 
	//printf("������Ҫͳ�Ƶ�Ŀ¼��:");
	//gets(buf);

	//���������
	CStatDir statdir;

	//����Ҫ������Ŀ¼
	if (!statdir.SetInitDir(buf))
	{
		puts("Ŀ¼�����ڡ�");
		return -1;
	}

	//��ʼ����
	statdir.BeginBrowse("*.ExportJson");
	printf("Format ExportJson Files Count: %d\n",statdir.GetFileCount());
	statdir.SetFileCount(0);
	system("pause");

	statdir.BeginBrowse("*.Json");
	printf("Format Json Files Count: %d\n",statdir.GetFileCount());
	system("pause");

	return 0;
} 

