
// MakeUpdataFileDlg.h : 头文件
//

#pragma once

// CMakeUpdataFileDlg 对话框
class CMakeUpdataFileDlg : public CDialogEx
{
// 构造
public:
	CMakeUpdataFileDlg(CWnd* pParent = NULL);	// 标准构造函数

// 对话框数据
	enum { IDD = IDD_MAKEUPDATAFILE_DIALOG };
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV 支持
	
// 实现
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
	// 生成的消息映射函数
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
