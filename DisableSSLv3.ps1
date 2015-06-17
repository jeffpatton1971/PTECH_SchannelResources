Configuration DisableSSLv3
{
    param
    (
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$ComputerName
    )

    Import-DscResource -ModuleName PTECH_SchannelResources;

    Node $ComputerName
    {
        #
        #region Disable SCHANNEL Protocols
        #
        PTECH_DisableSchannelProtocol TLS11
        {
            Protocol = 'TLS 1.1'
            Target = 'Server'
            Ensure = 'Absent'
            Reboot = $false
            }
        PTECH_DisableSchannelProtocol TLS12
        {
            Protocol = 'TLS 1.2'
            Target = 'Server'
            Ensure = 'Absent'
            Reboot = $false
            }
        PTECH_DisableSchannelProtocol SSL30
        {
            Protocol = 'SSL 3.0'
            Target = 'Server'
            Ensure = 'Absent'
            Reboot = $false
            }
        PTECH_DisableSchannelProtocol PCT10
        {
            Protocol = 'PCT 1.0'
            Target = 'Server'
            Ensure = 'Absent'
            Reboot = $false
            }
        PTECH_DisableSchannelProtocol SSL20
        {
            Protocol = 'SSL 2.0'
            Target = 'Server'
            Ensure = 'Absent'
            Reboot = $false
            }
        PTECH_DisableSchannelProtocol TLS10
        {
            Protocol = 'TLS 1.0'
            Target = 'Server'
            Ensure = 'Absent'
            Reboot = $false
            }
        #
        #endregion
        #
        #region Enable SCHANNEL Ciphers
        #
        PTECH_EnableSchannelCipher AES128128
        {
            Cipher = 'AES 128/128'
            Reboot = $false
            Ensure = 'Absent'
            }
        PTECH_EnableSchannelCipher AES256256
        {
            Cipher = 'AES 256/256'
            Reboot = $false
            Ensure = 'Absent'
            }
        PTECH_EnableSchannelCipher DES5656
        {
            Cipher = 'DES 56/56'
            Reboot = $false
            Ensure = 'Absent'
            }
        PTECH_EnableSchannelCipher NULL
        {
            Cipher = 'NULL'
            Reboot = $false
            Ensure = 'Absent'
            }
        PTECH_EnableSchannelCipher RC240128
        {
            Cipher = 'RC2 40/128'
            Reboot = $false
            Ensure = 'Absent'
            }
        PTECH_EnableSchannelCipher RC256128
        {
            Cipher = 'RC2 56/128'
            Reboot = $false
            Ensure = 'Absent'
            }
        PTECH_EnableSchannelCipher RC4128128
        {
            Cipher = 'RC4 128/128'
            Reboot = $false
            Ensure = 'Absent'
            }
        PTECH_EnableSchannelCipher RC440128
        {
            Cipher = 'RC4 40/128'
            Reboot = $false
            Ensure = 'Absent'
            }
        PTECH_EnableSchannelCipher RC456128
        {
            Cipher = 'RC4 56/128'
            Reboot = $false
            Ensure = 'Absent'
            }
        PTECH_EnableSchannelCipher RC464128
        {
            Cipher = 'RC4 64/128'
            Reboot = $false
            Ensure = 'Absent'
            }
        PTECH_EnableSchannelCipher TripleDES168168
        {
            Cipher = 'Triple DES 168/168'
            Reboot = $false
            Ensure = 'Absent'
            }
        #
        #endregion 
        #
        #region Enable SCHANNEL Hashes
        #
        PTECH_EnableSchannelHash MD5
        {
            Hash = 'MD5'
            Reboot = $false
            Ensure = 'Absent'
            }
        PTECH_EnableSchannelHash SHA
        {
            Hash = 'SHA'
            Reboot = $false
            Ensure = 'Absent'
            }
        #
        #endregion 
        #
        #region Enable SCHANNEL KeyExchangeAlgorithm
        #
        PTECH_EnableSchannelKeyExchangeAlgorithm Diffie
        {
            KeyExchangeAlgorithm = 'Diffie-Hellman'
            Reboot = $false
            Ensure = 'Absent'
            }
        PTECH_EnableSchannelKeyExchangeAlgorithm PKCS
        {
            KeyExchangeAlgorithm = 'PKCS'
            Reboot = $false
            Ensure = 'Absent'
            }
        #
        #endregion
        #
        #region Set SCHANNEL CipherOrder
        #
        PTECH_SetSchannelCipherOrder CipherOrdering
        {
            CipherOrder = 'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P521,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P384,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P256,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P521,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P521,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P256,TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_256_CBC_SHA,TLS_RSA_WITH_AES_128_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_3DES_EDE_CBC_SHA,TLS_DHE_DSS_WITH_AES_256_CBC_SHA256,TLS_DHE_DSS_WITH_AES_256_CBC_SHA,TLS_DHE_DSS_WITH_AES_128_CBC_SHA256,TLS_DHE_DSS_WITH_AES_128_CBC_SHA,TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA'
            Reboot = $false
            Ensure = 'Absent'
            }
        #
        #endregion
        #
        }
    }