---- Clean Data in SQL Queries ----
SELECT 
	SaleDateConverted, CONVERT(Date, SaleDate)
FROM
	NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date; 

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

---- Populate Property Address data

Select *
FROM NashvilleHousing
-- WHERE PropertyAddress is null
ORDER BY ParcelID

----Find where PropertyAddress is null and view changes prior to updating
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b ON a.ParcelID = b.ParcelID AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress is null

---- Update PropertyAddress where it is null 
UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b ON a.ParcelID = b.ParcelID AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress is null



----Breaking down Address into individual columns (Address, City, State)

Select PropertyAddress
FROM NashvilleHousing
-- WHERE PropertyAddress is null
-- ORDER BY ParcelID

SELECT 
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City
FROM 
	NashvilleHousing

---- Add columns and set values
ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

---- Verify columns and values were updated
SELECT * FROM NashvilleHousing




---- Break down OwnerAddress into Address, City, State
SELECT 
	PARSENAME(REPLACE(OwnerAddress,',', '.'),3) as Address,
	PARSENAME(REPLACE(OwnerAddress,',', '.'),2) as City,
	PARSENAME(REPLACE(OwnerAddress,',', '.'),1) as State
FROM 
	NashvilleHousing


---- Add columns and set values
ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'),1)



----Change Y and N to Yes and No in 'Sold as Vacant' field
----View unique options and their counts
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

----Build Case statment and compare to original column to see if changes were made
SELECT SoldAsVacant,
	CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM NashvilleHousing

---- Update column in table using case statment previously tested
UPDATE NashvilleHousing
SET SoldAsVacant =
	CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END



---- Remove Duplicates
WITH RowNumCTE AS (

SELECT 
	*, ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) row_num
FROM 
	NashvilleHousing

)

----DELETE Duplicates
DELETE FROM RowNumCTE
WHERE row_num > 1




----Delete Unused Columns
SELECT * FROM NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

