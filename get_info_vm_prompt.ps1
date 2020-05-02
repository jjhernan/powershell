$APPNAME = Read-Host -Prompt 'Ingresa nombre de la aplicacion '
$SUS = Read-Host -Prompt 'Ingresa nombre de suscripcion '
$RG = Read-Host -Prompt 'Ingresa nombre de resorce group '
$VM = Read-Host -Prompt 'Ingresa nombre de la maquina virtual '

Write-Output "Accediendo a Azure Portal:"
az account set --subscription $SUS
Write-Output "Accediendo a la suscripción : $SUS"
Write-Output "Recolectando informacion de $VM"
Write-Output "Procesando ........."

az account set --subscription $SUS

$RGNAME = az vm show -g $RG -n $VM -d --query 'resourceGroup' -o tsv
$VMNAME = az vm show -g $RG -n $VM --query 'name' -o tsv
$STATEVM = az vm show -g $RG -n $VM -d --query 'powerState' -o tsv
$VMSIZE = az vm show -g $RG -n $VM --query 'hardwareProfile.vmSize' -o tsv
$TEMPLATE = az vm show -g $RG -n $VM -d --query 'storageProfile.imageReference.offer' -o tsv
$templatecontent = az vm show -g $RG -n $VM -d --query 'storageProfile.imageReference.publisher' -o tsv 
$OS = az vm show -g $RG -n $VM --query 'storageProfile.imageReference.sku' -o tsv 
$OSDISKSIZEGB = az vm show -g $RG -n $VM --query 'storageProfile.osDisk.diskSizeGb' -o tsv 
$IPPRIVATE = az vm show -g $RG -n $VM -d --query 'privateIps' -o tsv
$TYPEDISK = az vm show -g $RG -n $VM --query 'storageProfile.osDisk.managedDisk.storageAccountType' -o tsv
$LISTDISKS = az vm show -g $RG -n $VM --query 'storageProfile.dataDisks[*].diskSizeGb' -o tsv
$quantity = $LISTDISKS.count

Write-Output "Nombre Aplicación:                      $APPNAME"
Write-Output "Nombre Suscripcion:                     $SUS"
Write-Output "Nombre VM:                              $VMNAME"
Write-Output "Nombre RG:                              $RGNAME"
Write-Output "Estatus de la máquina:                  $STATEVM"

Write-Output "Tipo de Máquina:                        $VMSIZE"
Write-Output "Plantilla:                              $TEMPLATE"
Write-Output "Contenido Plantilla:                    $templatecontent"

Write-Output "Versión OS:                             $OS"
Write-Output "Cantidad de almacenamiento OS disk:     $OSDISKSIZEGB GB"
Write-Output "Tipo de disco:                          $TYPEDISK"
Write-Output "Cantidad de discos adicionales:         $quantity"
Write-Output "Capacidad de cada Disco en GB:          $LISTDISKS"
Write-Output "Dirección ip privada:                   $IPPRIVATE" 

Write-Output "Creando csv ..."

$Props = @{
    "NombreAplicacion" = $APPNAME
    "NombreSuscripcion" = $SUS
    "NombreRG" = $RG
    "NombreVM" = $VM
    "EstatusVM" = $STATEVM
    "TipodeMaquina" = $VMSIZE
    "Platilla" = $TEMPLATE
    "ContenidoPlatilla" = $templatecontent
    "VersionOS" =  $OS
    "AlmacenamientoOS" = $OSDISKSIZEGB
    "Tipodedisco" = $TYPEDISK
    "Cantidaddiscosadicionales" = $quantity
    "CapacidadenGBdiscoadicional" = $LISTDISKS
    "IPPrivada" = $IPPRIVATE  
}

$MyObject = New-Object -TypeName psobject -Property $Props

$FilePath = "C:\Users\<your user name>\$VMNAME.csv" 

$MyObject | Select-Object 'NombreAplicacion','NombreSuscripcion','NombreRG','NombreVM', 'EstatusVM', 'TipodeMaquina', 'Platilla', 'ContenidoPlatilla', 'VersionOS', 'AlmacenamientoOS', 'Tipodedisco', 'Cantidaddiscosadicionales', 'CapacidadenGBdiscoadicional', 'IPPrivada' | Export-Csv $FilePath -NoTypeInformation

Write-Output "CSV Listo en: $FilePath"