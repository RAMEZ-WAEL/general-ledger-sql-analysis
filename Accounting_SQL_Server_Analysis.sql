
-- Query 1: Total Debit and Credit Amount by Fiscal Month
SELECT 
    Fiscal_Month_Mois_Fiscal AS FiscalMonth,
    SUM(CASE WHEN [Credit/Debit_Code_Code_Crédit_Débit] = 'DR' THEN CAST([Journal_Voucher_Item_Amount_Montant_de_l_item_de_la_pièce_de_journal] AS FLOAT) ELSE 0 END) AS TotalDebit,
    SUM(CASE WHEN [Credit/Debit_Code_Code_Crédit_Débit] = 'CR' THEN CAST([Journal_Voucher_Item_Amount_Montant_de_l_item_de_la_pièce_de_journal] AS FLOAT) ELSE 0 END) AS TotalCredit
FROM 
    AccountingData
GROUP BY 
    Fiscal_Month_Mois_Fiscal
ORDER BY 
    Fiscal_Month_Mois_Fiscal;

-- Query 2: Top Departments by Total Transaction Amount
SELECT TOP 10
    DepartmentNumber_Numéro_de_Ministère AS DepartmentNumber,
    SUM(CAST([Journal_Voucher_Item_Amount_Montant_de_l_item_de_la_pièce_de_journal] AS FLOAT)) AS TotalAmount
FROM 
    AccountingData
GROUP BY 
    DepartmentNumber_Numéro_de_Ministère
ORDER BY 
    TotalAmount DESC;

-- Query 3: Top 10 Subledger Accounts by Total Amount
SELECT TOP 10
    Subleger_Account_Identifier_Compte_du_grand_livre_auxiliaire AS SubledgerAccount,
    SUM(CAST([Journal_Voucher_Item_Amount_Montant_de_l_item_de_la_pièce_de_journal] AS FLOAT)) AS TotalAmount
FROM 
    AccountingData
GROUP BY 
    Subleger_Account_Identifier_Compte_du_grand_livre_auxiliaire
ORDER BY 
    TotalAmount DESC;

-- Query 4: Total Credit vs Debit Per Fiscal Year
SELECT 
    Fiscal_Year_Année_Fiscale AS FiscalYear,
    SUM(CASE WHEN [Credit/Debit_Code_Code_Crédit_Débit] = 'DR' THEN CAST([Journal_Voucher_Item_Amount_Montant_de_l_item_de_la_pièce_de_journal] AS FLOAT) ELSE 0 END) AS TotalDebit,
    SUM(CASE WHEN [Credit/Debit_Code_Code_Crédit_Débit] = 'CR' THEN CAST([Journal_Voucher_Item_Amount_Montant_de_l_item_de_la_pièce_de_journal] AS FLOAT) ELSE 0 END) AS TotalCredit
FROM 
    AccountingData
GROUP BY 
    Fiscal_Year_Année_Fiscale;

-- Query 5: Ranking Departments by Total Posted Amount (Window Function)
SELECT 
    DepartmentNumber_Numéro_de_Ministère AS Department,
    SUM(CAST([Journal_Voucher_Item_Amount_Montant_de_l_item_de_la_pièce_de_journal] AS FLOAT)) AS TotalAmount,
    RANK() OVER (ORDER BY SUM(CAST([Journal_Voucher_Item_Amount_Montant_de_l_item_de_la_pièce_de_journal] AS FLOAT)) DESC) AS DeptRank
FROM 
    AccountingData
GROUP BY 
    DepartmentNumber_Numéro_de_Ministère;

-- Query 6: CTE for High-Value Journal Entries
WITH HighValueTransactions AS (
    SELECT 
        Accounting_Control_Number_Numéro_contrôle_comptable AS EntryID,
        DepartmentNumber_Numéro_de_Ministère AS Department,
        [Journal_Voucher_Item_Amount_Montant_de_l_item_de_la_pièce_de_journal] AS Amount
    FROM 
        AccountingData
    WHERE 
        CAST([Journal_Voucher_Item_Amount_Montant_de_l_item_de_la_pièce_de_journal] AS FLOAT) > 10000
)
SELECT * FROM HighValueTransactions;
