function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$CipherOrder,

		[System.Boolean]
		$Reboot,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Write-Verbose "Incoming Param CipherOrder     : $($CipherOrder)"
    Write-Verbose "Incoming Param Reboot          : $($Reboot)"
    Write-Verbose "Incoming Param Ensure          : $($Ensure)"

    $RegPath = "SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"

    $EnsurePresent = 'Absent'
    $Result = Get-RegistryValue -Hive HKEY_LOCAL_MACHINE -SubKeyName $RegPath -ValueName Functions -ValueType ExpandedString
    [bool]$PathExist = $false

    switch ($Result.ReturnValue)
    {
        0
        {
            $PathExist = $true
            }
        1
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
		CipherOrder = [System.String]$CipherOrder
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
		[System.String]
		$CipherOrder,

		[System.Boolean]
		$Reboot,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Write-Verbose "Incoming Param CipherOrder     : $($CipherOrder)"
    Write-Verbose "Incoming Param Reboot          : $($Reboot)"
    Write-Verbose "Incoming Param Ensure          : $($Ensure)"

    $RegPath = "SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"

	switch ($Ensure)
    {
        'Absent'
        {
            Write-Verbose "Removing $($RegPath)"
            $Result = Remove-RegistryValue -Hive HKEY_LOCAL_MACHINE -SubKeyName $RegPath -ValueName Functions
            if (!($Result.ReturnValue -eq 0))
            {
                throw "Error $($Result.ReturnValue) ocurred"
                }
            }
        'Present'
        {
            Write-Verbose "Setting $($ValueName) to $($Value)"
            $Result = Set-RegistryValue -Hive HKEY_LOCAL_MACHINE -SubKeyName $RegPath -ValueName Functions -ValueType ExpandedString -Value $CipherOrder
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
		[System.String]
		$CipherOrder,

		[System.Boolean]
		$Reboot,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Write-Verbose "Incoming Param CipherOrder     : $($CipherOrder)"
    Write-Verbose "Incoming Param Reboot          : $($Reboot)"
    Write-Verbose "Incoming Param Ensure          : $($Ensure)"

    $RegPath = "SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"

    Write-Verbose "Checking if $($RegPath) Exists"
    $Result = Get-RegistryValue -Hive HKEY_LOCAL_MACHINE -SubKeyName $RegPath -ValueName Functions -ValueType ExpandedString
    if ($Result.ReturnValue -eq 0)
    {
        Write-Verbose "$($RegPath) Exists"
        if ($Result.sValue -eq $CipherOrder)
        {
            Write-Verbose "Functions == $($CipherOrder)"
            $Status = "Present"
            }
        else
        {
            Write-Verbose "Functions != $($CipherOrder)"
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