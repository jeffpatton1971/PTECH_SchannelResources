function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[ValidateSet("MD5","SHA")]
		[System.String]
		$Hash,

		[System.Boolean]
		$Reboot,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Write-Verbose "Incoming Param Hash     : $($Hash)"
    Write-Verbose "Incoming Param Reboot   : $($Reboot)"
    Write-Verbose "Incoming Param Ensure : $($Ensure)"

    $Hashes = "SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes"
    $RegPath = "$($Hashes)\$($Hash)"

    $EnsurePresent = 'Absent'
    $Result = Get-RegistryKey -Hive HKEY_LOCAL_MACHINE -SubKeyName $RegPath
    [bool]$PathExist = $false

    switch ($Result.ReturnValue)
    {
        0
        {
            $PathExist = $true
            }
        2
        {
            $PathExist = $false
            }
        5
        {
            throw "Access Denied"
            }
        default
        {
            throw "Error $($Result.ReturnValue) ocurred"
            }
        }

    switch ($Ensure)
    {
        'Absent'
        {
            #
            # Regpath must NOT exist
            #
            if ($PathExist)
            {
                $EnsurePresent = 'Present'
                }
            else
            {
                $EnsurePresent = 'Absent'
                }
            }
        'Present'
        {
            #
            # Regpath must exist
            #
            if ($PathExist)
            {
                $EnsurePresent = 'Present'
                }
            else
            {
                $EnsurePresent = 'Absent'
                }
            }
        }

	$returnValue = @{
		Hash = [System.String]$Hash
        Reboot = [System.Boolean]$Reboot
		Ensure = [System.String]$EnsurePresent
	}

	$returnValue
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[ValidateSet("MD5","SHA")]
		[System.String]
		$Hash,

		[System.Boolean]
		$Reboot,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Write-Verbose "Incoming Param Hash     : $($Hash)"
    Write-Verbose "Incoming Param Reboot   : $($Reboot)"
    Write-Verbose "Incoming Param Ensure : $($Ensure)"

    $Hashes = "SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes"
    $RegPath = "$($Hashes)\$($Hash)"

    switch ($Hash)
    {
        'MD5'
        {
            $ValueName = 'Enabled'
            $ValueType = 'DWORD'
            $Value = '4294967295'
            }
        'SHA'
        {
            $ValueName = 'Enabled'
            $ValueType = 'DWORD'
            $Value = '4294967295'
            }
        }

	switch ($Ensure)
    {
        'Absent'
        {
            Write-Verbose "Removing $($RegPath)"
            $Result = Remove-RegistryKey -Hive HKEY_LOCAL_MACHINE -SubKeyName $RegPath
            if (!($Result.ReturnValue -eq 0))
            {
                throw "Error $($Result.ReturnValue) ocurred"
                }
            }
        'Present'
        {
            Write-Verbose "Creating Key $($RegPath)"
            $Result = New-RegistryKey -Hive HKEY_LOCAL_MACHINE -SubKeyName $RegPath
            if (!($Result.ReturnValue -eq 0))
            {
                throw "Error $($Result.ReturnValue) ocurred"
                }
            Write-Verbose "Setting $($ValueName) to $($Value)"
            $Result = Set-RegistryValue -Hive HKEY_LOCAL_MACHINE -SubKeyName $RegPath -ValueName $ValueName -ValueType $ValueType -Value $Value
            if (!($Result.ReturnValue -eq 0))
            {
                throw "Error $($Result.ReturnValue) ocurred"
                }
            }
        }

    Write-Verbose "Machine Reboot Required"
    if ($Reboot)
    {
        Write-Verbose "Rebooting Machine"
	    $global:DSCMachineStatus = 1
        }
}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[ValidateSet("MD5","SHA")]
		[System.String]
		$Hash,

		[System.Boolean]
		$Reboot,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Write-Verbose "Incoming Param Hash     : $($Hash)"
    Write-Verbose "Incoming Param Reboot   : $($Reboot)"
    Write-Verbose "Incoming Param Ensure : $($Ensure)"

    $Hashes = "SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes"
    $RegPath = "$($Hashes)\$($Hash)"

    switch ($Hash)
    {
        'MD5'
        {
            $ValueName = 'Enabled'
            $ValueType = 'DWORD'
            $Value = '4294967295'
            }
        'SHA'
        {
            $ValueName = 'Enabled'
            $ValueType = 'DWORD'
            $Value = '4294967295'
            }
        }

    Write-Verbose "Checking if $($RegPath) Exists"
    $Result = Get-RegistryKey -Hive HKEY_LOCAL_MACHINE -SubKeyName $RegPath
    if ($Result.ReturnValue -eq 0)
    {
        Write-Verbose "$($RegPath) Exists"
        $RegValue = Get-RegistryValue -Hive HKEY_LOCAL_MACHINE -SubKeyName $RegPath -ValueName $ValueName -ValueType $ValueType
        if ($RegValue.uValue -eq $Value)
        {
            Write-Verbose "$($ValueName) == $($Value)"
            $Status = "Present"
            }
        else
        {
            Write-Verbose "$($ValueName) != $($Value)"
            $Status = "Absent"
            }
        }
    else
    {
        Write-Verbose "$($RegPath) Does not exist"
        $Status = "Absent"
        }

    switch ($Ensure)
    {
        'Absent'
        {
            if ($Status -eq 'Present')
            {
                $Result = $false
                }
            else
            {
                $Result = $true
                }
            }
        'Present'
        {
            if ($Status -eq 'Present')
            {
                $Result = $true
                }
            else
            {
                $Result = $false
                }
            }
        }
	$Result
}


Export-ModuleMember -Function *-TargetResource