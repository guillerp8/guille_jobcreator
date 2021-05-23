# guille_jobcreator https://discord.gg/eBpmkW6e5j (+ extended 1.2, not compatible with extended 1.1 or exm)
## How to install (If you rename the script will not work)

- Upload the database of the script.
- Go to es_extended -> server -> common.lua
if you use extended => 1.2 add this

```
RegisterServerEvent("es_extended:updateJobs")
AddEventHandler("es_extended:updateJobs", function()
	MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
		for k,v in ipairs(result) do
			ESX.Items[v.name] = {
				label = v.label,
				weight = v.weight,
				rare = v.rare,
				canRemove = v.can_remove
			}
		end
	end)

	MySQL.Async.fetchAll('SELECT * FROM jobs', {}, function(jobs)
		for k,v in ipairs(jobs) do
			ESX.Jobs[v.name] = v
			ESX.Jobs[v.name].grades = {}
		end

		MySQL.Async.fetchAll('SELECT * FROM job_grades', {}, function(jobGrades)
			for k,v in ipairs(jobGrades) do
				if ESX.Jobs[v.job_name] then
					ESX.Jobs[v.job_name].grades[tostring(v.grade)] = v
				else
					print(('[es_extended] [^3WARNING^7] No hay job "%s" especificado'):format(v.job_name))
				end
			end

			for k2,v2 in pairs(ESX.Jobs) do
				if ESX.Table.SizeOf(v2.grades) == 0 then
					ESX.Jobs[v2.name] = nil
					print(('[es_extended] [^3WARNING^7] No hay grades para el job "%s"'):format(v2.name))
				end
			end
		end)
	end)
	print('[es_extended] [^2INFO^7] JOB ACTUALIZADO CON GUILLE_JOBS CORRECTAMENTE')
end)
```

**Later add the esx scripts that I provided in the repo (ALL RIGTHS BELONG TO ESX GROUP)**

**COMMANDS:**
```
/addcar + model (add cars to the points)
/addcustomclothes + outfitname (add clothes to job)
/additem + item (item or weapon) + itemname + price
```
