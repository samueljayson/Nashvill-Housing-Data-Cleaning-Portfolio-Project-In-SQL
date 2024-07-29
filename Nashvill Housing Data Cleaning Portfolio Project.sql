SELECT * FROM [Portfolio Project]..nashvillhousing; 

--Standardize Date Format
SELECT SaleDateConverted, CONVERT(DATE,SaleDate)
FROM [Portfolio Project]..nashvillhousing; 

UPDATE nashvillhousing
SET SaleDate = CONVERT(DATE,SaleDate)

ALTER TABLE nashvillhousing
ADD SaleDateConverted Date;

UPDATE nashvillhousing
SET SaleDateConverted = CONVERT(DATE,SaleDate)



SELECT *
FROM [Portfolio Project]..nashvillhousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID; 


SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project]..nashvillhousing as a
JOIN [Portfolio Project]..nashvillhousing as b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project]..nashvillhousing as a
JOIN [Portfolio Project]..nashvillhousing as b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


--Breaking Property Address into Individal Columns
SELECT PropertyAddress
FROM [Portfolio Project]..nashvillhousing
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID; 

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM [Portfolio Project]..nashvillhousing


ALTER TABLE nashvillhousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE nashvillhousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)



ALTER TABLE nashvillhousing
ADD PropertySplitCity Nvarchar(255);

UPDATE nashvillhousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) 



SELECT * FROM [Portfolio Project]..nashvillhousing





SELECT OwnerAddress FROM [Portfolio Project]..nashvillhousing


SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)

FROM [Portfolio Project]..nashvillhousing



ALTER TABLE nashvillhousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE nashvillhousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)



ALTER TABLE nashvillhousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE nashvillhousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE nashvillhousing
ADD OwnerSplitState Nvarchar(255);

UPDATE nashvillhousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)



SELECT * FROM [Portfolio Project]..nashvillhousing

-- Updating SoldAsVacant From Y and N to YES and NO

SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM [Portfolio Project]..nashvillhousing
GROUP BY SoldAsVacant
ORDER BY 2



SELECT SoldAsVacant, 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM [Portfolio Project]..nashvillhousing


UPDATE nashvillhousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END



----REMOVE DUPLICATES
WITH RowNumCTE AS(
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
ORDER BY UniqueID) row_num

FROM [Portfolio Project]..nashvillhousing
--ORDER BY ParcelID
) 


SELECT * FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress



-- To delete duplicate
DELETE FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

---- DELETE unused data
SELECT * FROM [Portfolio Project]..nashvillhousing

ALTER TABLE [Portfolio Project]..nashvillhousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress


ALTER TABLE [Portfolio Project]..nashvillhousing
DROP COLUMN SaleDate