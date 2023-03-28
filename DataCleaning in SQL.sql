select*
from [Portfolio Project]..[Nashville Housing]

select SaleDateConverted, CONVERT(Date,SaleDate)
from [Portfolio Project]..[Nashville Housing]

update [Portfolio Project]..[Nashville Housing]
set SaleDate=CONVERT(Date,SaleDate)

alter table [Portfolio Project]..[Nashville Housing]
add SaleDateConverted Date;

update [Portfolio Project]..[Nashville Housing]
set SaleDateConverted=CONVERT(Date,SaleDate)


select* --PropertyAddress
from [Portfolio Project]..[Nashville Housing]
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project]..[Nashville Housing] a
join [Portfolio Project]..[Nashville Housing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project]..[Nashville Housing] a
join [Portfolio Project]..[Nashville Housing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


select PropertyAddress
from [Portfolio Project]..[Nashville Housing]
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING ( PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING ( PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress)) AS Address
from [Portfolio Project]..[Nashville Housing]


alter table [Portfolio Project]..[Nashville Housing]
add PropertyAddressSPlit Nvarchar(255);

update [Portfolio Project]..[Nashville Housing]
set PropertyAddressSPlit=SUBSTRING ( PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 



alter table [Portfolio Project]..[Nashville Housing]
add PropertyCitySplit Nvarchar(255);

update [Portfolio Project]..[Nashville Housing]
set PropertyCitySplit=SUBSTRING ( PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress)) 


select*
from [Portfolio Project]..[Nashville Housing]


select OwnerAddress
from [Portfolio Project]..[Nashville Housing]

select
PARSENAME(replace(OwnerAddress, ',','.'),3),
PARSENAME(replace(OwnerAddress, ',','.'),2),
PARSENAME(replace(OwnerAddress, ',','.'),1)
from [Portfolio Project]..[Nashville Housing]


alter table [Portfolio Project]..[Nashville Housing]
add OwnerAddressSplit Nvarchar(255);

update [Portfolio Project]..[Nashville Housing]
set OwnerAddressSPlit=PARSENAME(replace(OwnerAddress, ',','.'),3) 


alter table [Portfolio Project]..[Nashville Housing]
add OwnerCitySplit Nvarchar(255);

update [Portfolio Project]..[Nashville Housing]
set OwnerCitySPlit=PARSENAME(replace(OwnerAddress, ',','.'),2)


alter table [Portfolio Project]..[Nashville Housing]
add OwnerStateSplit Nvarchar(255);

update [Portfolio Project]..[Nashville Housing]
set OwnerStateSPlit=PARSENAME(replace(OwnerAddress, ',','.'),1)

select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from [Portfolio Project]..[Nashville Housing]
Group By SoldAsVacant
order by 2


select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
end
from [Portfolio Project]..[Nashville Housing]

update [Portfolio Project]..[Nashville Housing]
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
end
from [Portfolio Project]..[Nashville Housing]

--duplicates

with RowNumCTE as (
Select *,
	ROW_NUMBER() over (
	partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by
					UniqueId
					) row_num
from [Portfolio Project]..[Nashville Housing]
)
delete
from RowNumCTE
where row_num >1
--order by PropertyAddress


--deleting unused columns

select*
from [Portfolio Project]..[Nashville Housing]

alter table [Portfolio Project]..[Nashville Housing]
drop column OwnerAddress, TaxDistrict, PropertyAddress, PropertCitySplit

alter table [Portfolio Project]..[Nashville Housing]
drop column SaleDate