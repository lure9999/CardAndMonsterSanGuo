
// MakeUpdataFileDlg.h : ͷ�ļ�
//

#pragma once

// CMakeUpdataFileDlg �Ի���
class CMakeUpdataFileDlg : public CDialogEx
{
// ����
public:
	CMakeUpdataFileDlg(CWnd* pParent = NULL);	// ��׼���캯��

// �Ի�������
	enum { IDD = IDD_MAKEUPDATAFILE_DIALOG };
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV ֧��
	
// ʵ��
protected:
	HICON m_hIcon;
	CEdit *pCEOld;
	CEdit *pCENew;
	CEdit *pCEVer;
	CEdit *pCEOut;
	CEdit *pCEFtp;
	CButton *pBtnMake;
	CButton *pBtnUpdate;
	CButton *pBtnLog;
private:
	// ���ɵ���Ϣӳ�亯��
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedOldVerButton();
	afx_msg void OnBnClickedNewVerButton();
	afx_msg void OnBnClickedOutButton();
	afx_msg void OnBnClickedOkButton();

public:
	void UpdateDlgData();
	void HandleErrorMsg(CString strKey);
	void EnableWindow(BOOL bEanble);
	map<CString, CEdit*> m_pControl;
	afx_msg void OnBnClickedUpdatefile();
	afx_msg void OnBnClickedLog();
};
