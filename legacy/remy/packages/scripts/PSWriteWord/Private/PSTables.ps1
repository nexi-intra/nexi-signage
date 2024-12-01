function Format-TransposeTable {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] [object[]]$Object,
        [ValidateSet("ASC", "DESC", "NONE")][String] $Sort = 'NONE'
    )
    begin { $i = 0; }

    process {
        foreach ($myObject in $Object) {
            if ($myObject.GetType().Name -eq 'hashtable' -or $myObject.GetType().Name -eq 'OrderedDictionary') {
                Write-Verbose "Format-TransposeTable - Converting HashTable/OrderedDictionary to PSCustomObject - $($myObject.GetType().Name)"
                $output = New-Object -TypeName PsObject;
                Add-Member -InputObject $output -MemberType ScriptMethod -Name AddNote -Value {
                    Add-Member -InputObject $this -MemberType NoteProperty -Name $args[0] -Value $args[1];
                };
                if ($Sort -eq 'ASC') {
                    $myObject.Keys | Sort-Object -Descending:$false | % { $output.AddNote($_, $myObject.$_); }
                } elseif ($Sort -eq 'DESC') {
                    $myObject.Keys | Sort-Object -Descending:$true | % { $output.AddNote($_, $myObject.$_); }
                } else {
                    $myObject.Keys | % { $output.AddNote($_, $myObject.$_); }
                }
                $output;
            } else {
                Write-Verbose "Format-TransposeTable - Converting PSCustomObject to HashTable/OrderedDictionary - $($myObject.GetType().Name)"
                # Write-Warning "Index $i is not of type [hashtable]";
                $output = [ordered] @{};
                $myObject | Get-Member -MemberType *Property | % {
                    $output.($_.name) = $myObject.($_.name);
                }
                $output

            }
            $i += 1;
        }
    }
}

function Format-PSTableConvertType3 {
    [CmdletBinding()]
    param (
        $Object,
        [switch] $SkipTitles,
        [string[]] $ExcludeProperty,
        [switch] $NoAliasOrScriptProperties,
        [switch] $DisplayPropertySet,
        $OverwriteHeaders
    )
    Write-Verbose 'Format-PSTableConvertType3 - Option 3'
    $Array = New-ArrayList
    ### Add Titles
    if (-not $SkipTitles) {
        $Titles = New-ArrayList
        Add-ToArray -List $Titles -Element 'Name'
        Add-ToArray -List $Titles -Element 'Value'
        Add-ToArray -List $Array -Element $Titles
    }
    ### Add Data
    foreach ($O in $Object) {
        foreach ($Name in $O.Keys) {
            # Write-Verbose "Test2 - $Key - $($O[$Key])"
            $ArrayValues = New-ArrayList
            if ($ExcludeProperty -notcontains $Name) {
                Add-ToArray -List $ArrayValues -Element $Name
                Add-ToArray -List $ArrayValues -Element $O[$Name]
                Add-ToArray -List $Array -Element $ArrayValues
            }
        }
    }
    return , $Array
}

function Format-PSTableConvertType2 {
    [CmdletBinding()]
    param(
        $Object,
        [switch] $SkipTitles,
        [string[]] $ExcludeProperty,
        [switch] $NoAliasOrScriptProperties,
        [switch] $DisplayPropertySet,
        $OverwriteHeaders
    )
    #[int] $Run = 0
    $Array = New-ArrayList
    $Titles = New-ArrayList
    if ($NoAliasOrScriptProperties) {$PropertyType = 'AliasProperty', 'ScriptProperty'  } else {$PropertyType = ''}
    Write-Verbose "Format-PSTableConvertType2 - Option 2 - NoAliasOrScriptProperties: $NoAliasOrScriptProperties"

    # Get Titles first (to make sure order is correct for all rows)
    if ($OverwriteHeaders) {
        $Titles = $OverwriteHeaders
    } else {
        foreach ($O in $Object) {
            if ($DisplayPropertySet -and $O.psStandardmembers.DefaultDisplayPropertySet.ReferencedPropertyNames) {
                $ObjectProperties = $O.psStandardmembers.DefaultDisplayPropertySet.ReferencedPropertyNames.Where( { $ExcludeProperty -notcontains $_  } ) #.Name
            } else {
                $ObjectProperties = $O.PSObject.Properties.Where( { $PropertyType -notcontains $_.MemberType -and $ExcludeProperty -notcontains $_.Name  } ).Name
            }
            foreach ($Name in $ObjectProperties) {
                Add-ToArray -List $Titles -Element $Name
            }
            break
        }
        # Add Titles to Array (if not -SkipTitles)
        if (-not $SkipTitle) {
            Add-ToArray -List $Array -Element $Titles
        }
    }
    # Extract data (based on Title)
    foreach ($O in $Object) {
        $ArrayValues = New-ArrayList
        foreach ($Name in $Titles) {
            Add-ToArray -List $ArrayValues -Element $O.$Name
        }
        Add-ToArray -List $Array -Element $ArrayValues
    }
    return , $Array
}
function Format-PSTableConvertType1 {
    [CmdletBinding()]
    param (
        $Object,
        [switch] $SkipTitles,
        [string[]] $ExcludeProperty,
        [switch] $NoAliasOrScriptProperties,
        [switch] $DisplayPropertySet,
        $OverwriteHeaders
    )
    Write-Verbose 'Format-PSTableConvertType1 - Option 1'
    $Array = New-ArrayList
    ### Add Titles
    if (-not $SkipTitles) {
        $Titles = New-ArrayList
        Add-ToArray -List $Titles -Element 'Name'
        Add-ToArray -List $Titles -Element 'Value'
        Add-ToArray -List $Array -Element $Titles
    }
    ### Add Data
    foreach ($Name in $Object.Keys) {
        Write-Verbose "$Name"
        Write-Verbose "$Object.$Name"
        $ArrayValues = New-ArrayList
        if (-not $ExcludeProperty -notcontains $Name) {
            Add-ToArray -List $ArrayValues -Element $Name
            Add-ToArray -List $ArrayValues -Element $Object.$Name
            Add-ToArray -List $Array -Element $ArrayValues
        }
    }

    return , $Array
}
function Format-PSTable {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)] $Object,
        [switch] $SkipTitle,
        [string[]] $ExcludeProperty,
        [switch] $NoAliasOrScriptProperties,
        [switch] $DisplayPropertySet,
        $OverwriteHeaders
    )

    $Type = Get-ObjectType -Object $Object
    Write-Verbose "Format-PSTable - Type: $($Type.ObjectTypeName) NoAliasOrScriptProperties: $NoAliasOrScriptProperties DisplayPropertySet: $DisplayPropertySet"
    if ($Type.ObjectTypeName -eq 'Object[]' -or
        $Type.ObjectTypeName -eq 'Object' -or $Type.ObjectTypeName -eq 'PSCustomObject' -or
        $Type.ObjectTypeName -eq 'Collection`1') {
        #Write-Verbose 'Level 0-0'
        if ($Type.ObjectTypeInsiderName -match 'string|bool|byte|char|decimal|double|float|int|long|sbyte|short|uint|ulong|ushort') {
            #Write-Verbose 'Level 1-0'
            return Format-PSTableConvertType1 -Object $Object -SkipTitle:$SkipTitle -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -OverwriteHeaders $OverwriteHeaders
        } elseif ($Type.ObjectTypeInsiderName -eq 'Object' -or $Type.ObjectTypeInsiderName -eq 'PSCustomObject') {
            # Write-Verbose 'Level 1-1'
            return Format-PSTableConvertType2 -Object $Object -SkipTitle:$SkipTitle -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -OverwriteHeaders $OverwriteHeaders
        } elseif ($Type.ObjectTypeInsiderName -eq 'HashTable' -or $Type.ObjectTypeInsiderName -eq 'OrderedDictionary' ) {
            # Write-Verbose 'Level 1-2'
            return Format-PSTableConvertType3 -Object $Object -SkipTitle:$SkipTitle -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -OverwriteHeaders $OverwriteHeaders
        } else {
            # Covers ADDriveInfo and other types of objects
            # Write-Verbose 'Level 1-3'
            return Format-PSTableConvertType2 -Object $Object -SkipTitle:$SkipTitle -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -OverwriteHeaders $OverwriteHeaders
        }
    } elseif ($Type.ObjectTypeName -eq 'HashTable' -or $Type.ObjectTypeName -eq 'OrderedDictionary' ) {
        #Write-Verbose 'Level 0-1'
        return Format-PSTableConvertType3 -Object $Object -SkipTitle:$SkipTitle -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -OverwriteHeaders $OverwriteHeaders
    } elseif ($Type.ObjectTypeName -match 'string|bool|byte|char|decimal|double|float|int|long|sbyte|short|uint|ulong|ushort') {
        return $Object
    } else {
        #Write-Verbose 'Level 0-2'
        # Covers ADDriveInfo and other types of objects
        return Format-PSTableConvertType2 -Object $Object -SkipTitle:$SkipTitle -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -OverwriteHeaders $OverwriteHeaders
    }
    throw 'Not supported? Weird'
}
function Show-TableVisualization {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)] $Object
    )
    if ($Color) { Write-Color "[i] This is how table looks like in Format-Table" -Color Yellow }
    Write-Verbose '[i] This is how table looks like in Format-Table'
    $Object | Format-Table -AutoSize
    $Data = Format-PSTable $Object #-Verbose

    Write-Verbose "[i] Rows Count $($Data.Count) Column Count $($Data[0].Count)"
    $RowNr = 0
    if ($Color) { Write-Color "[i] Presenting table after conversion" -Color Yellow }
    foreach ($Row in $Data) {
        $ColumnNr = 0
        foreach ($Column in $Row) {
            Write-Verbose "Row: $RowNr Column: $ColumnNr Data: $Column"
            $ColumnNr++
        }
        $RowNr++
    }
}