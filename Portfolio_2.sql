SELECT *
  FROM [PortfolioProject].[dbo].[NashvilleHousing]

/*
	Cleaning Data in SQL Queries
*/


-- Standardize Data Format

select SaleDate, convert(date, SaleDate)
from [PortfolioProject]..[NashvilleHousing]



alter table Nashville
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = convert(date, SaleDate)

-- Populate Property Address Data

SELECT *
  FROM [PortfolioProject].[dbo].[NashvilleHousing]
--where PropertyAddress is null
order by ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress) 
  FROM [PortfolioProject].[dbo].[NashvilleHousing] a
  join [PortfolioProject].[dbo].[NashvilleHousing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
  FROM [PortfolioProject].[dbo].[NashvilleHousing] a
  join [PortfolioProject].[dbo].[NashvilleHousing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

-- Breaking Out Address into Induvidual Colunms(Address, City, State)

Select PropertyAddress
from [PortfolioProject].[dbo].[NashvilleHousing]


select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as Address
from [PortfolioProject].[dbo].[NashvilleHousing]

alter table [PortfolioProject].[dbo].[NashvilleHousing]
add PropertySplitCity Nvarchar(255);

update [PortfolioProject].[dbo].[NashvilleHousing]
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


alter table [PortfolioProject].[dbo].[NashvilleHousing]
add PropertySplitCity Nvarchar(255); 

update [PortfolioProject].[dbo].[NashvilleHousing]
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

Select *
from [PortfolioProject].[dbo].[NashvilleHousing]



Select OwnerAddress
from [PortfolioProject].[dbo].[NashvilleHousing]


Select 
PARSENAME(replace(OwnerAddress, ',','.'),3),
PARSENAME(replace(OwnerAddress, ',','.'),2),
PARSENAME(replace(OwnerAddress, ',','.'),1)
from [PortfolioProject].[dbo].[NashvilleHousing]


alter table [PortfolioProject].[dbo].[NashvilleHousing]
add OwnerSplitState nvarchar(255)

update [PortfolioProject].[dbo].[NashvilleHousing]
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',','.'),1)

alter table [PortfolioProject].[dbo].[NashvilleHousing]
add OwnerSplitAddress nvarchar(255)

update [PortfolioProject].[dbo].[NashvilleHousing]
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',','.'),3)

alter table [PortfolioProject].[dbo].[NashvilleHousing]
add OwnerSplitCity nvarchar(255)

update [PortfolioProject].[dbo].[NashvilleHousing]
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',','.'),2)


-- Change Y and N to Yes and No in "Sold as Vacant" field


select Distinct(SoldAsVacant), count(SoldAsVacant)
from [PortfolioProject].[dbo].[NashvilleHousing]
group by SoldAsVacant


select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from [PortfolioProject].[dbo].[NashvilleHousing]

update [PortfolioProject].[dbo].[NashvilleHousing]
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end


-- Remove Duplicates
with RowNumCTE as (
select *, 
ROW_NUMBER() over (
partition by  ParcelID,
			PropertyAddress,
			SalePrice,
			LegalReference
			ORDER BY
			UniqueID) row_num
from [PortfolioProject].[dbo].[NashvilleHousing]
--order by ParcelID
)


Select *
from RowNumCTE
where row_num >1
order by PropertyAddress


-- Delete Unused Columns


select *
from [PortfolioProject].[dbo].[NashvilleHousing]

alter table [PortfolioProject].[dbo].[NashvilleHousing]
drop column OwnerAddress, TaxDistrict, PropertyAddress


alter table [PortfolioProject].[dbo].[NashvilleHousing]
drop column SaleDate