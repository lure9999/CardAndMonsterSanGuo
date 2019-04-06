
// MakeUpdataFileDlg.cpp : 实现文件
//

#include "stdafx.h"
#include "MakeUpdataFile.h"
#include "MakeUpdataFileDlg.h"
#include "afxdialogex.h"
#include "MD5Checksum.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif
#include <string>

using namespace std;

#define LEN 1024
#define MAX_STR_SIZE 512

// 用于应用程序“关于”菜单项的 CAboutDlg 对话框

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

// 对话框数据
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

// 实现
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialogEx(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()


// CMakeUpdataFileDlg 对话框
CMakeUpdataFileDlg::CMakeUpdataFileDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(CMakeUpdataFileDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CMakeUpdataFileDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CMakeUpdataFileDlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTONOLD, &CMakeUpdataFileDlg::OnBnClickedOldVerButton)
	ON_BN_CLICKED(IDC_BUTTONNEW, &CMakeUpdataFileDlg::OnBnClickedNewVerButton)
	ON_BN_CLICKED(IDC_BUTTONOUT, &CMakeUpdataFileDlg::OnBnClickedOutButton)
	ON_BN_CLICKED(IDC_BUTTONOK, &CMakeUpdataFileDlg::OnBnClickedOkButton)
	ON_BN_CLICKED(IDC_UPDATEFILE, &CMakeUpdataFileDlg::OnBnClickedUpdatefile)
	ON_BN_CLICKED(IDC_LOG, &CMakeUpdataFileDlg::OnBnClickedLog)
END_MESSAGE_MAP()


// CMakeUpdataFileDlg 消息处理程序

BOOL CMakeUpdataFileDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// 将“关于...”菜单项添加到系统菜单中。

	// IDM_ABOUTBOX 必须在系统命令范围内。
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		BOOL bNameValid;
		CString strAboutMenu;
		bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
		ASSERT(bNameValid);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// 设置此对话框的图标。当应用程序主窗口不是对话框时，框架将自动
	//  执行此操作
	SetIcon(m_hIcon, TRUE);			// 设置大图标
	SetIcon(m_hIcon, FALSE);		// 设置小图标

	// TODO: 在此添加额外的初始化代码
	pCEOld = (CEdit *)GetDlgItem(IDC_EDITOLDPATH);
	pCENew = (CEdit *)GetDlgItem(IDC_EDITNEWPATH);
	pCEVer = (CEdit *)GetDlgItem(IDC_EDITNEWVER);
	pCEOut = (CEdit *)GetDlgItem(IDC_EDITOUTPATH);
	pCEFtp = (CEdit *)GetDlgItem(IDC_EDITFTP);
	pBtnMake = (CButton *)GetDlgItem(IDC_BUTTONOK);
	pBtnUpdate = (CButton *)GetDlgItem(IDC_UPDATEFILE);
	pBtnLog = (CButton *)GetDlgItem(IDC_LOG);

	CEdit*  m_paEdit[] = {pCEOld, pCENew, pCEVer, pCEFtp, pCEOut} ;
	for (int i=0; i<5;++i)
	{
		m_pControl.insert(map<CString, CEdit*>::value_type(g_saKey[i], m_paEdit[i]));
	}
	
	theApp.ReadConfigFile();
	UpdateDlgData();

	return TRUE;  // 除非将焦点设置到控件，否则返回 TRUE
}

void CMakeUpdataFileDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialogEx::OnSysCommand(nID, lParam);
	}
}

// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void CMakeUpdataFileDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // 用于绘制的设备上下文

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// 使图标在工作区矩形中居中
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// 绘制图标
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

//当用户拖动最小化窗口时系统调用此函数取得光标
//显示。
HCURSOR CMakeUpdataFileDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CMakeUpdataFileDlg::OnBnClickedOldVerButton()
{
	// TODO: 在此添加控件通知处理程序代码
	CString strOldPath = theApp.GetResourcesPath();
	pCEOld->SetWindowTextW(strOldPath);
}

void CMakeUpdataFileDlg::OnBnClickedNewVerButton()
{
	// TODO: 在此添加控件通知处理程序代码
	CString strNewPath = theApp.GetResourcesPath();
	pCENew->SetWindowTextW(strNewPath);
}


void CMakeUpdataFileDlg::OnBnClickedOutButton()
{
	// TODO: 在此添加控件通知处理程序代码
	CString strOutPath = theApp.GetResourcesPath();
	pCEOut->SetWindowTextW(strOutPath);
}

void CMakeUpdataFileDlg::OnBnClickedOkButton()
{
	// TODO: 在此添加控件通知处理程序代码
	for (map<CString, CEdit*>::iterator pIter=m_pControl.begin(); pIter!=m_pControl.end();++pIter)
	{
		CString strData = NULL;
		pIter->second->GetWindowText(strData);
		if (strData.IsEmpty())
		{
			HandleErrorMsg(pIter->first);
			return;
		}
		else
		{
			theApp.UpdateConfigFile(pIter->first, strData);
		}
	}

	CString strOldPath = theApp.GetDataFromConfigInfo(g_saKey[0]);
	CString strNewPath = theApp.GetDataFromConfigInfo(g_saKey[1]);
	CString strVer = theApp.GetDataFromConfigInfo(g_saKey[2]);
	CString strFtp = theApp.GetDataFromConfigInfo(g_saKey[3]);
	CString strOutPath = theApp.GetDataFromConfigInfo(g_saKey[4]);
	CString strWinRARPath = theApp.GetWinRARPath();
	
	if (theApp.IsCanCompare(strOldPath, strNewPath)==FALSE)
	{
		return;
	}

	EnableWindow(FALSE);

	theApp.MakeLogFile(strOutPath, strVer);
	// 比对资源文件
	if (theApp.CompareUpdateFiles(strNewPath, strOldPath, strNewPath, strOutPath+"\\res\\"+strVer)==FALSE)
	{
		//AfxMessageBox(L"资源文件比较错误！");
		return;
	}

	// 压缩资源文件
	if(theApp.MakeUpdateZipFile(strWinRARPath, strOutPath, strVer)==FALSE)
	{
		return;
	}

	// 生成版本文件
	if(theApp.MakeVerFile(strVer, strFtp, strOutPath)==FALSE)
	{
		AfxMessageBox(L"版本文件制作错误！");
		return;
	}

	// 备份资源文件
	theApp.BackUpResFile(strNewPath, strVer);

	// 更新配置文件版本号
	theApp.UpdateVerNum(strVer, g_saKey[2]);

	// 更新配置文件旧资源路径
	theApp.UpdateOldPath(strNewPath, strVer, g_saKey[0]);

	// 更新配置文件
	theApp.WriteConfigFile();

	theApp.MakeUpdateListFiles(strOutPath, strVer);
	EnableWindow(TRUE);
	AfxMessageBox(_T("更新包制作完成！"));
}

void CMakeUpdataFileDlg::UpdateDlgData()
{
	for (map<CString, CEdit*>::iterator pIter=m_pControl.begin();pIter!=m_pControl.end();++pIter)
	{
		map<CString, CString>::iterator pIterConInfo = theApp.GetConfigInfo().find(pIter->first);
	
		if (pIterConInfo!= theApp.GetConfigInfo().end())
		{
			pIter->second->SetWindowText(pIterConInfo->second);
		}
	}
}

void CMakeUpdataFileDlg::HandleErrorMsg(CString strKey)
{
	CString strError = strKey+L" is NULL...";
	MessageBox(strError,L"ErrorTip",MB_OK);
}

void CMakeUpdataFileDlg::EnableWindow(BOOL bEanble)
{
	pCEOld->EnableWindow(bEanble);
	pCENew->EnableWindow(bEanble);
	pCEVer->EnableWindow(bEanble);
	pCEOut->EnableWindow(bEanble);
	pCEFtp->EnableWindow(bEanble);
	pBtnMake->EnableWindow(bEanble);
	pBtnUpdate->EnableWindow(bEanble);
	pBtnLog->EnableWindow(bEanble);
	GetDlgItem(IDC_BUTTONOLD)->EnableWindow(bEanble);
	GetDlgItem(IDC_BUTTONNEW)->EnableWindow(bEanble);
	GetDlgItem(IDC_BUTTONOUT)->EnableWindow(bEanble);
}

void CMakeUpdataFileDlg::OnBnClickedUpdatefile()
{
	// TODO: 在此添加控件通知处理程序代码
	theApp.OpenUpdateListFiles();
}


void CMakeUpdataFileDlg::OnBnClickedLog()
{
	// TODO: 在此添加控件通知处理程序代码
	theApp.OpenLogFile();
}
