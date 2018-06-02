param (
    [string]$task = ""
)


If ($task -eq "") {
    Write-Output "you must choose a task"
	Write-Output "---------------------"
	Write-Output "push"
    [Environment]::Exit(1)
}

function Start-Job-Here([scriptblock]$block){
	Start-Job -Name dotnet -ArgumentList (Get-Location),$block { Set-Location $args[0]; Invoke-Expression $args[1] }
}

function Test-Error {
    If (-Not $?) {
		try {
			Stop-Process -Name dotnet 2>$null
		}
		catch {

		}
		# this should never execute
        throw "How can this happened"
    }
}

If ($task -eq "push") {
	git pull -r
	Test-Error
	mdpdf backstory.md
	Test-Error
	git add -A
	Test-Error
	git commit --amend --no-edit
	Test-Error
	git push
	exit
}

Invoke-Expression $task