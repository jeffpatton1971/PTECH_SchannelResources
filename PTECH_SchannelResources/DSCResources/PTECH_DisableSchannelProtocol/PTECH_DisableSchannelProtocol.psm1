function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[ValidateSet("TLS 1.1","TLS 1.2","SSL 3.0","PCT 1.0","SSL 2.0","TLS 1.0")]
		[System.String]
		$Protocol,

		[ValidateSet("Server","Client")]
		[System.String]
		$Target,

		[System.Boolean]
		$Reboot,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Write-Verbose "Incoming Param Protocol : $($Protocol)"
    Write-Verbose "Incoming Param Target   : $($Target)"
    Write-Verbose "Incoming Param Reboot   : $($Reboot)"
    Write-Verbose "Incoming Param Ensure   : $($Ensure)"

    $Protocols = "SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"
    $RegPath = "$($Protocols)\$($Protocol)\$($Target)"
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
		Protocol = [System.String]$Protocol
		Target = [System.String]$Target
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
		[ValidateSet("TLS 1.1","TLS 1.2","SSL 3.0","PCT 1.0","SSL 2.0","TLS 1.0")]
		[System.String]
		$Protocol,

		[ValidateSet("Server","Client")]
		[System.String]
		$Target,

		[System.Boolean]
		$Reboot,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Write-Verbose "Incoming Param Protocol : $($Protocol)"
    Write-Verbose "Incoming Param Target   : $($Target)"
    Write-Verbose "Incoming Param Reboot   : $($Reboot)"
    Write-Verbose "Incoming Param Ensure   : $($Ensure)"

    $Protocols = "SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"
    $RegPath = "$($Protocols)\$($Protocol)\$($Target)"

    switch ($Protocol)
    {
        'TLS 1.1'
        {
            $ValueName = @("DisabledByDefault","Enabled")
            $ValueType = "DWORD"
            $Value = @("0","4294967295")
            }
        'TLS 1.2'
        {
            $ValueName = @("DisabledByDefault","Enabled")
            $ValueType = "DWORD"
            $Value = @("0","4294967295")
            }
        'SSL 3.0'
        {
            $ValueName = @("DisabledByDefault","Enabled")
            $ValueType = "DWORD"
            $Value = @("1","0")
            }
        'PCT 1.0'
        {
            $ValueName = @("DisabledByDefault","Enabled")
            $ValueType = "DWORD"
            $Value = @("1","0")
            }
        'SSL 2.0'
        {
            $ValueName = @("DisabledByDefault","Enabled")
            $ValueType = "DWORD"
            $Value = @("1","0")
            }
        'TLS 1.0'
        {
            $ValueName = @("DisabledByDefault","Enabled")
            $ValueType = "DWORD"
            $Value = @("0","4294967295")
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
            $RegPath = "$($Protocols)\$($Protocol)"
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
            Write-Verbose "Setting $($ValueName[0]) to $($Value[0])"
            $Result = Set-RegistryValue -Hive HKEY_LOCAL_MACHINE -SubKeyName $RegPath -ValueName $ValueName[0] -ValueType $ValueType -Value $Value[0]
            if (!($Result.ReturnValue -eq 0))
            {
                throw "Error $($Result.ReturnValue) ocurred"
                }
            if (!($Result.ReturnValue -eq 0))
            {
                throw "Error $($Result.ReturnValue) ocurred"
                }
            Write-Verbose "Setting $($ValueName[1]) to $($Value[1])"
            $Result = Set-RegistryValue -Hive HKEY_LOCAL_MACHINE -SubKeyName $RegPath -ValueName $ValueName[1] -ValueType $ValueType -Value $Value[1]
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
	[OutputType([Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[ValidateSet("TLS 1.1","TLS 1.2","SSL 3.0","PCT 1.0","SSL 2.0","TLS 1.0")]
		[System.String]
		$Protocol,

		[ValidateSet("Server","Client")]
		[System.String]
		$Target,

		[System.Boolean]
		$Reboot,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Write-Verbose "Incoming Param Protocol : $($Protocol)"
    Write-Verbose "Incoming Param Target   : $($Target)"
    Write-Verbose "Incoming Param Reboot   : $($Reboot)"
    Write-Verbose "Incoming Param Ensure   : $($Ensure)"

    $Protocols = "SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"
    $RegPath = "$($Protocols)\$($Protocol)\$($Target)"

    switch ($Protocol)
    {
        'TLS 1.1'
        {
            $ValueName = @("DisabledByDefault","Enabled")
            $ValueType = "DWORD"
            $Value = @("0","4294967295")
            }
        'TLS 1.2'
        {
            $ValueName = @("DisabledByDefault","Enabled")
            $ValueType = "DWORD"
            $Value = @("0","4294967295")
            }
        'SSL 3.0'
        {
            $ValueName = @("DisabledByDefault","Enabled")
            $ValueType = "DWORD"
            $Value = @("1","0")
            }
        'PCT 1.0'
        {
            $ValueName = @("DisabledByDefault","Enabled")
            $ValueType = "DWORD"
            $Value = @("1","0")
            }
        'SSL 2.0'
        {
            $ValueName = @("DisabledByDefault","Enabled")
            $ValueType = "DWORD"
            $Value = @("1","0")
            }
        'TLS 1.0'
        {
            $ValueName = @("DisabledByDefault","Enabled")
            $ValueType = "DWORD"
            $Value = @("0","4294967295")
            }
        }

    Write-Verbose "Checking if $($RegPath) Exists"
    $Result = Get-RegistryKey -Hive HKEY_LOCAL_MACHINE -SubKeyName $RegPath
    if ($Result.ReturnValue -eq 0)
    {
        Write-Verbose "$($RegPath) Exists"
        $RegValue = Get-RegistryValue -Hive HKEY_LOCAL_MACHINE -SubKeyName $RegPath -ValueName $ValueName[0] -ValueType $ValueType
        if ($RegValue.uValue -eq $Value[0])
        {
            Write-Verbose "$($ValueName[0]) == $($Value[0])"
            $Status = "Present"
            }
        else
        {
            Write-Verbose "$($ValueName[0]) != $($Value[0])"
            $Status = "Absent"
            }
        if ($Status -eq 'Present')
        {
            $RegValue = Get-RegistryValue -Hive HKEY_LOCAL_MACHINE -SubKeyName $RegPath -ValueName $ValueName[1] -ValueType $ValueType
            if ($RegValue.uValue -eq $Value[1])
            {
                Write-Verbose "$($ValueName[1]) == $($Value[1])"
                $Status = "Present"
                }
            else
            {
                Write-Verbose "$($ValueName[1]) == $($Value[1])"
                $Status = "Absent"
                }
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