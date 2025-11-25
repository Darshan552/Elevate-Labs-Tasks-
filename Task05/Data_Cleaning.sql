-- Cleaning Data in SQL Queries


select * from nas_housing

select count(*) from nas_housing

--------------------------------------------------------------------------


-- Standardies Date Formate

select saledate from nas_housing


ALTER TABLE nas_housing
ALTER COLUMN saledate TYPE DATE
USING saledate::DATE;


--------------------------------------------------------------------------

-- populate Property Address data 

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From nas_housing a
JOIN nas_housing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID  <> b.UniqueID 
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From  nas_housing a
JOIN nas_housing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID 
Where a.PropertyAddress is null



--------------------------------------------------------------------------
--Breaking out Address into Individual Columns (Address, City, State)

select * from nas_housing


SELECT
  SPLIT_PART(owneraddress, ',', 1) AS street,
  TRIM(SPLIT_PART(owneraddress, ',', 2)) AS city,
  TRIM(SPLIT_PART(owneraddress, ',', 3)) AS state
FROM nas_housing;


ALTER TABLE nas_housing
ADD COLUMN street TEXT,
ADD COLUMN city TEXT,
ADD COLUMN state TEXT;


ALTER TABLE nas_housing
RENAME COLUMN owneraddresscity TO owneraddressstreet;

ALTER TABLE nas_housing
RENAME COLUMN city TO owneraddresscity;

ALTER TABLE nas_housing
RENAME COLUMN state TO owneraddressstate;
SET
  owneraddressstreet = SPLIT_PART(owneraddress, ',', 1),
  owneraddresscity   = TRIM(SPLIT_PART(owneraddress, ',', 2)),
  owneraddressstate  = TRIM(SPLIT_PART(owneraddress, ',', 3));


select * from nas_housing

--------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From nas_housing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From nas_housing


Update nas_housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From nas_housing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From nas_housing

--------------------------------------------------------------------------


-- Delete Unused Columns



Select *
From nas_housing


ALTER TABLE nas_housing
DROP COLUMN OwnerAddress, 
DROP COLUMN TaxDistrict;

--------------------------------------------------------------------------