
// MakeUpdataFileDlg.cpp : ʵ���ļ�
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

// ����Ӧ�ó��򡰹��ڡ��˵���� CAboutDlg �Ի���

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

// �Ի�������
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��

// ʵ��
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


// CMakeUpdataFileDlg �Ի���
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


// CMakeUpdataFileDlg ��Ϣ�������

BOOL CMakeUpdataFileDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// ��������...���˵�����ӵ�ϵͳ�˵��С�

	// IDM_ABOUTBOX ������ϵͳ���Χ�ڡ�
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

	// ���ô˶Ի����ͼ�ꡣ��Ӧ�ó��������ڲ��ǶԻ���ʱ����ܽ��Զ�
	//  ִ�д˲���
	SetIcon(m_hIcon, TRUE);			// ���ô�ͼ��
	SetIcon(m_hIcon, FALSE);		// ����Сͼ��

	// TODO: �ڴ���Ӷ���ĳ�ʼ������
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

	return TRUE;  // ���ǽ��������õ��ؼ������򷵻� TRUE
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

// �����Ի��������С����ť������Ҫ����Ĵ���
//  �����Ƹ�ͼ�ꡣ����ʹ���ĵ�/��ͼģ�͵� MFC Ӧ�ó���
//  �⽫�ɿ���Զ���ɡ�

void CMakeUpdataFileDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // ���ڻ��Ƶ��豸������

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// ʹͼ���ڹ����������о���
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// ����ͼ��
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

//���û��϶���С������ʱϵͳ���ô˺���ȡ�ù��
//��ʾ��
HCURSOR CMakeUpdataFileDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CMakeUpdataFileDlg::OnBnClickedOldVerButton()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	CString strOldPath = theApp.GetResourcesPath();
	pCEOld->SetWindowTextW(strOldPath);
}

void CMakeUpdataFileDlg::OnBnClickedNewVerButton()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	CString strNewPath = theApp.GetResourcesPath();
	pCENew->SetWindowTextW(strNewPath);
}


void CMakeUpdataFileDlg::OnBnClickedOutButton()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	CString strOutPath = theApp.GetResourcesPath();
	pCEOut->SetWindowTextW(strOutPath);
}

void CMakeUpdataFileDlg::OnBnClickedOkButton()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
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
	// �ȶ���Դ�ļ�
	if (theApp.CompareUpdateFiles(strNewPath, strOldPath, strNewPath, strOutPath+"\\res\\"+strVer)==FALSE)
	{
		//AfxMessageBox(L"��Դ�ļ��Ƚϴ���");
		return;
	}

	// ѹ����Դ�ļ�
	if(theApp.MakeUpdateZipFile(strWinRARPath, strOutPath, strVer)==FALSE)
	{
		return;
	}

	// ���ɰ汾�ļ�
	if(theApp.MakeVerFile(strVer, strFtp, strOutPath)==FALSE)
	{
		AfxMessageBox(L"�汾�ļ���������");
		return;
	}

	// ������Դ�ļ�
	theApp.BackUpResFile(strNewPath, strVer);

	// ���������ļ��汾��
	theApp.UpdateVerNum(strVer, g_saKey[2]);

	// ���������ļ�����Դ·��
	theApp.UpdateOldPath(strNewPath, strVer, g_saKey[0]);

	// ���������ļ�
	theApp.WriteConfigFile();

	theApp.MakeUpdateListFiles(strOutPath, strVer);
	EnableWindow(TRUE);
	AfxMessageBox(_T("���°�������ɣ�"));
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
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	theApp.OpenUpdateListFiles();
}


void CMakeUpdataFileDlg::OnBnClickedLog()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	theApp.OpenLogFile();
}
