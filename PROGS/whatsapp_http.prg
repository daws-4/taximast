*=============================================================================
* WHATSAPP_HTTP.PRG
* Modulo de comunicacion HTTP con el backend de WhatsApp Business API
* Reemplaza la biblioteca COM FoxWhatsApp.WhatsAppSel
*
* Uso: SET PROCEDURE TO PROGS\whatsapp_http ADDITIVE
*      Luego llamar a las funciones WA_* directamente
*=============================================================================

* ---- CONFIGURACION ----
* Cambiar estos valores seg�n el entorno (desarrollo/producci�n)
#DEFINE WA_BASE_URL    "http://localhost:3000/api/whatsapp"
#DEFINE WA_API_KEY     ""
#DEFINE WA_TIMEOUT     30

*=============================================================================
* WA_CheckStatus() - Verifica si el backend esta disponible
* Retorna: .T. si el backend responde OK, .F. si falla
*=============================================================================
FUNCTION WA_CheckStatus
   LOCAL lcUrl, lcResponse, llResult

   lcUrl = WA_BASE_URL + "/status"
   lcResponse = WA_HttpGet(lcUrl)

   IF EMPTY(lcResponse)
      RETURN .F.
   ENDIF

   * Verificar que la respuesta contiene "connected":true
   llResult = (AT('"connected":true', lcResponse) > 0) ;
      .OR. (AT('"connected": true', lcResponse) > 0)

   RETURN llResult
ENDFUNC

*=============================================================================
* WA_SendMessage(cPhone, cMessage, cType, cImagePath) - Env�a un mensaje
* Parmetros:
*   cPhone     - Nmero de telfono del destinatario
*   cMessage   - Texto del mensaje
*   cType      - Tipo: "dispatch_driver", "dispatch_client", "broadcast_partners"
*   cImagePath - (Opcional) Ruta local de imagen a enviar (ej: foto identificador)
* Retorna: .T. si fue exitoso, .F. si fallo
*=============================================================================
FUNCTION WA_SendMessage
   LPARAMETERS cPhone, cMessage, cType, cImagePath
   LOCAL lcUrl, lcJson, lcResponse, llResult

   * Valores por defecto
   IF VARTYPE(cType) # "C" .OR. EMPTY(cType)
      cType = "general"
   ENDIF

   IF VARTYPE(cImagePath) # "C"
      cImagePath = ""
   ENDIF

   * Limpiar espacios
   cPhone   = ALLTRIM(cPhone)
   cMessage = ALLTRIM(cMessage)
   cType    = ALLTRIM(cType)
   cImagePath = ALLTRIM(cImagePath)

   * Validar parametros
   IF EMPTY(cPhone) .OR. EMPTY(cMessage)
      WAIT WINDOW "WA Error: Telefono o mensaje vacio" TIMEOUT 3
      RETURN .F.
   ENDIF

   * Construir JSON
   lcJson = '{'
   lcJson = lcJson + '"phone":"' + WA_EscapeJson(cPhone) + '",'
   lcJson = lcJson + '"message":"' + WA_EscapeJson(cMessage) + '",'
   lcJson = lcJson + '"type":"' + WA_EscapeJson(cType) + '"'

   * Agregar imagen si se proporcion�
   IF !EMPTY(cImagePath)
      lcJson = lcJson + ',"image":"' + WA_EscapeJson(cImagePath) + '"'
   ENDIF

   lcJson = lcJson + '}'

   * Enviar POST
   lcUrl = WA_BASE_URL + "/send"
   lcResponse = WA_HttpPost(lcUrl, lcJson)

   IF EMPTY(lcResponse)
      RETURN .F.
   ENDIF

   * Verificar respuesta
   llResult = (AT('"success":true', lcResponse) > 0) ;
      .OR. (AT('"success": true', lcResponse) > 0)

   IF !llResult
      WAIT WINDOW "WA Error al enviar a " + cPhone TIMEOUT 3
   ENDIF

   RETURN llResult
ENDFUNC

*=============================================================================
* WA_SendBulk(nCount, aDatos) - Envia mensajes masivos
* Parametros:
*   nCount  - Cantidad de mensajes
*   aDatos  - Array de 2 columnas: [phone, message]
*   cType   - Tipo de envio
* Retorna: .T. si fue exitoso, .F. si fallo
*=============================================================================
FUNCTION WA_SendBulk
   LPARAMETERS nCount, aDatos, cType
   LOCAL lcUrl, lcJson, lcResponse, llResult, i

   IF EMPTY(cType)
      cType = "broadcast_partners"
   ENDIF

   * Construir JSON con array de mensajes
   lcJson = '{"messages":['

   FOR i = 1 TO nCount
      IF i > 1
         lcJson = lcJson + ','
      ENDIF
      lcJson = lcJson + '{'
      lcJson = lcJson + '"phone":"' + WA_EscapeJson(ALLTRIM(aDatos(i, 1))) + '",'
      lcJson = lcJson + '"message":"' + WA_EscapeJson(ALLTRIM(aDatos(i, 2))) + '"'
      lcJson = lcJson + '}'
   ENDFOR

   lcJson = lcJson + '],'
   lcJson = lcJson + '"type":"' + WA_EscapeJson(ALLTRIM(cType)) + '"'
   lcJson = lcJson + '}'

   * Enviar POST
   lcUrl = WA_BASE_URL + "/send-bulk"
   lcResponse = WA_HttpPost(lcUrl, lcJson)

   IF EMPTY(lcResponse)
      RETURN .F.
   ENDIF

   llResult = (AT('"success":true', lcResponse) > 0) ;
      .OR. (AT('"success": true', lcResponse) > 0)

   RETURN llResult
ENDFUNC

*=============================================================================
* WA_GetLocation(cPhone) - Obtiene la �ltima ubicaci�n de un cliente
* Par�metros:
*   cPhone - N�mero de tel�fono del cliente
* Retorna: URL de Google Maps si hay ubicaci�n, cadena vac�a si no
*=============================================================================
FUNCTION WA_GetLocation
   LPARAMETERS cPhone
   LOCAL lcUrl, lcResponse, lcMapsUrl

   cPhone = ALLTRIM(cPhone)
   IF EMPTY(cPhone)
      RETURN ""
   ENDIF

   lcUrl = WA_BASE_URL + "/location?phone=" + cPhone
   lcResponse = WA_HttpGet(lcUrl)

   IF EMPTY(lcResponse)
      RETURN ""
   ENDIF

   * Verificar si se encontr� ubicaci�n
   IF AT('"found":true', lcResponse) > 0 ;
      .OR. AT('"found": true', lcResponse) > 0

      * Extraer maps_url de la respuesta
      lcMapsUrl = WA_ExtractJsonValue(lcResponse, "maps_url")
      RETURN lcMapsUrl
   ENDIF

   RETURN ""
ENDFUNC

*=============================================================================
* WA_HttpPost(cUrl, cJson) - Ejecuta una petici�n HTTP POST
* Par�metros:
*   cUrl  - URL completa del endpoint
*   cJson - Cuerpo de la petici�n en JSON
* Retorna: Respuesta del servidor como texto, vac�o si error
*=============================================================================
FUNCTION WA_HttpPost
   LPARAMETERS cUrl, cJson
   LOCAL loHttp, lcResponse

   lcResponse = ""

   TRY
      loHttp = CREATEOBJECT("MSXML2.ServerXMLHTTP.6.0")
      loHttp.Open("POST", cUrl, .F.)
      loHttp.setRequestHeader("Content-Type", "application/json")
      loHttp.setRequestHeader("Accept", "application/json")

      * Agregar API key si est� configurada
      IF !EMPTY(WA_API_KEY)
         loHttp.setRequestHeader("Authorization", "Bearer " + WA_API_KEY)
      ENDIF

      * Configurar timeout (en milisegundos)
      * resolveTimeout, connectTimeout, sendTimeout, receiveTimeout
      loHttp.setTimeouts(WA_TIMEOUT * 1000, WA_TIMEOUT * 1000, ;
         WA_TIMEOUT * 1000, WA_TIMEOUT * 1000)

      loHttp.Send(cJson)

      IF loHttp.Status = 200 .OR. loHttp.Status = 201
         lcResponse = loHttp.responseText
      ELSE
         WAIT WINDOW "WA HTTP Error: " + ALLTRIM(STR(loHttp.Status)) ;
            + " - " + loHttp.statusText TIMEOUT 3
      ENDIF

   CATCH TO loEx
      WAIT WINDOW "WA Error de conexi�n: " + loEx.Message TIMEOUT 3
      lcResponse = ""

   FINALLY
      loHttp = NULL
      RELEASE loHttp

   ENDTRY

   RETURN lcResponse
ENDFUNC

*=============================================================================
* WA_HttpGet(cUrl) - Ejecuta una petici�n HTTP GET
* Par�metros:
*   cUrl - URL completa del endpoint
* Retorna: Respuesta del servidor como texto, vac�o si error
*=============================================================================
FUNCTION WA_HttpGet
   LPARAMETERS cUrl
   LOCAL loHttp, lcResponse

   lcResponse = ""

   TRY
      loHttp = CREATEOBJECT("MSXML2.ServerXMLHTTP.6.0")
      loHttp.Open("GET", cUrl, .F.)
      loHttp.setRequestHeader("Accept", "application/json")

      * Agregar API key si est� configurada
      IF !EMPTY(WA_API_KEY)
         loHttp.setRequestHeader("Authorization", "Bearer " + WA_API_KEY)
      ENDIF

      * Configurar timeout
      loHttp.setTimeouts(WA_TIMEOUT * 1000, WA_TIMEOUT * 1000, ;
         WA_TIMEOUT * 1000, WA_TIMEOUT * 1000)

      loHttp.Send()

      IF loHttp.Status = 200
         lcResponse = loHttp.responseText
      ELSE
         WAIT WINDOW "WA HTTP Error: " + ALLTRIM(STR(loHttp.Status)) ;
            + " - " + loHttp.statusText TIMEOUT 3
      ENDIF

   CATCH TO loEx
      WAIT WINDOW "WA Error de conexi�n: " + loEx.Message TIMEOUT 3
      lcResponse = ""

   FINALLY
      loHttp = NULL
      RELEASE loHttp

   ENDTRY

   RETURN lcResponse
ENDFUNC

*=============================================================================
* WA_EscapeJson(cText) - Escapa caracteres especiales para JSON
* Par�metros:
*   cText - Texto a escapar
* Retorna: Texto escapado seguro para JSON
*=============================================================================
FUNCTION WA_EscapeJson
   LPARAMETERS cText
   LOCAL lcResult

   IF EMPTY(cText)
      RETURN ""
   ENDIF

   lcResult = ALLTRIM(cText)

   * Escapar barra invertida primero (debe ser el primero)
   lcResult = STRTRAN(lcResult, '\', '\\')

   * Escapar comillas dobles
   lcResult = STRTRAN(lcResult, '"', '\"')

   * Escapar caracteres de control
   lcResult = STRTRAN(lcResult, CHR(13) + CHR(10), '\n')
   lcResult = STRTRAN(lcResult, CHR(13), '\n')
   lcResult = STRTRAN(lcResult, CHR(10), '\n')
   lcResult = STRTRAN(lcResult, CHR(9), '\t')

   RETURN lcResult
ENDFUNC

*=============================================================================
* WA_ExtractJsonValue(cJson, cKey) - Extrae un valor simple de un JSON
* Par�metros:
*   cJson - String JSON
*   cKey  - Nombre de la llave a buscar
* Retorna: Valor como texto (sin comillas), vac�o si no se encuentra
* Nota: Funciona para valores string simples, no para objetos/arrays anidados
*=============================================================================
FUNCTION WA_ExtractJsonValue
   LPARAMETERS cJson, cKey
   LOCAL lcSearch, lnPos, lnStart, lnEnd, lcValue

   * Buscar la llave en el JSON: "key":"value" o "key": "value"
   lcSearch = '"' + cKey + '"'
   lnPos = AT(lcSearch, cJson)

   IF lnPos = 0
      RETURN ""
   ENDIF

   * Avanzar despu�s de la llave y los dos puntos
   lnPos = lnPos + LEN(lcSearch)

   * Saltar espacios y los dos puntos
   DO WHILE lnPos <= LEN(cJson) .AND. ;
      INLIST(SUBSTR(cJson, lnPos, 1), ':', ' ')
      lnPos = lnPos + 1
   ENDDO

   * Verificar si el valor empieza con comillas (es string)
   IF SUBSTR(cJson, lnPos, 1) = '"'
      lnStart = lnPos + 1
      * Buscar la comilla de cierre (sin escapar)
      lnEnd = lnStart
      DO WHILE lnEnd <= LEN(cJson)
         IF SUBSTR(cJson, lnEnd, 1) = '"' .AND. SUBSTR(cJson, lnEnd - 1, 1) # '\'
            EXIT
         ENDIF
         lnEnd = lnEnd + 1
      ENDDO
      lcValue = SUBSTR(cJson, lnStart, lnEnd - lnStart)
   ELSE
      * Valor no-string (n�mero, boolean): leer hasta coma o cierre
      lnStart = lnPos
      lnEnd = lnStart
      DO WHILE lnEnd <= LEN(cJson) .AND. ;
         !INLIST(SUBSTR(cJson, lnEnd, 1), ',', '}', ']')
         lnEnd = lnEnd + 1
      ENDDO
      lcValue = ALLTRIM(SUBSTR(cJson, lnStart, lnEnd - lnStart))
   ENDIF

   RETURN lcValue
ENDFUNC
