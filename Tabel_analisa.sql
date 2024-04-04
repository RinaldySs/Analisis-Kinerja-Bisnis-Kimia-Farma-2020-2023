-- This Query creates a new table 'tabel_analisa' in the 'kimia_farma' schema,
-- which contains analyzed data from transactions, including various calculations.
CREATE TABLE kimia_farma.tabel_analisa AS                              
SELECT
-- Selecting relevant columns from kf_final_transaction and kf_kantor_cabang tables
  f.transaction_id,                                                   
  f.date,
  f.branch_id,
  k.branch_name,
  k.kota,
  k.provinsi,
  k.rating AS rating_cabang, -- alias for rating_cabang
  f.customer_name,
  f.product_id,
  p.product_name,
  f.price AS actual_price,
  f.discount_percentage,
--calculating gross profit percentage based on price ranges
  CASE
    WHEN f.price <= 50000 THEN f.price * 0.1
    WHEN f.price > 50000 AND f.price <= 100000 THEN f.price * 0.15
    WHEN f.price > 100000 AND f.price <= 300000 THEN f.price * 0.20    
    WHEN f.price > 300000 AND f.price <= 500000 THEN f.price * 0.25
    ELSE f.price * 0.30
  END AS persentase_gross_laba,
-- Calculating net sales after discount
  f.price * (1 - f.discount_percentage) AS nett_sales,
-- Calculating net profit after discount based on price ranges
  f.price * (1 - f.discount_percentage) *
    CASE
      WHEN f.price <= 50000 THEN 0.1
      WHEN f.price > 50000 AND f.price <= 100000 THEN 0.15
      WHEN f.price > 100000 AND f.price <= 300000 THEN 0.20            
      WHEN f.price > 300000 AND f.price <= 500000 THEN 0.25
      ELSE 0.30
    END AS nett_profit,
f.rating as rating_transaksi -- Alias for rating of the transaction
FROM kimia_farma.kf_final_transaction AS f
LEFT JOIN kimia_farma.kf_kantor_cabang k ON f.branch_id = k.branch_id       
LEFT JOIN kimia_farma.kf_product p ON f.product_id = p.product_id;
