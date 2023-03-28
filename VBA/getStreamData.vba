Sub exampleFetch()
    Dim token As String
    
    token = GetToken("username", "password")
    
    Dim streamId As String
    Dim fromDate As String
    Dim toDate As String
    Dim CSVRows() As String
    Dim CSVCols() As String
    
    streamId = "1"  'AB 5 min SMP
    fromDate = "03/28/2019" ' mm/dd/yyyy hh:mm format
    toDate = "03/29/2019"
    
    If token <> "" Then
        streamdata = GetData(token, streamId, fromDate, toDate)
        
        ReleaseToken token
        
        'Split the CSV data into rows by linefeed
        CSVRows = Split(streamdata, Chr(10))
        For y = 0 To UBound(CSVRows)
            'split the csv data into columns by ","
            CSVCols = Split(CSVRows(y), ",")
            'this example inserts into an excel spreadsheet
            For x = 0 To UBound(CSVCols)
                ActiveSheet.Cells.Item(y + 1, x + 1).Value = CSVCols(x)
            Next x
        Next y
    End If
    'Set token = Nothing
    Set streamdata = Nothing
    
End Sub

Function GetToken(userName, password)
    Dim oHTTP As Object
    Dim Json As Object
    
    Set oHTTP = CreateObject("MSXML2.XMLHTTP.6.0")
    oHTTP.Open "POST", "https://api.nrgstream.com/api/security/token"
    oHTTP.send "grant_type=password&username=" & userName & "&password=" & password
    
    'Set Json = CreateObjectx86("MSScriptControl.ScriptControl")
    'Json.Language = "JScript"
    If oHTTP.Status = 200 Then
        'Set GetToken = Json.eval("(" + oHTTP.responseText + ")")
        GetToken = findToken(oHTTP.responseText)
    Else
        MsgBox Json.eval("(" + oHTTP.responseText + ")").error_description, vbCritical + vbOKOnly
        GetToken = ""
    End If
    'CreateObjectx86 , True
    Set Json = Nothing
    Set oHTTP = Nothing
End Function

Function GetData(token, streamId, fromDate, toDate)
    Dim oHTTP As Object
    
    Set oHTTP = CreateObject("MSXML2.XMLHTTP.6.0")
    oHTTP.Open "GET", "https://api.nrgstream.com/api/StreamData/" & streamId & "?fromDate=" & fromDate & "&toDate=" & toDate
    oHTTP.setRequestHeader "Authorization", "Bearer " & token
    oHTTP.setRequestHeader "Accept", "text/csv"
    oHTTP.send
    
    If oHTTP.Status = 200 Then
        GetData = oHTTP.responseText
    Else
        GetData = ""
    End If
    Set oHTTP = Nothing
End Function

Sub ReleaseToken(token)
    Dim oHTTP As Object
    Dim Json As Object
    
    Set oHTTP = CreateObject("MSXML2.XMLHTTP.6.0")
    oHTTP.Open "DELETE", "https://api.nrgstream.com/api/ReleaseToken/"
    oHTTP.setRequestHeader "Authorization", "Bearer " & token
    oHTTP.send
    
End Sub

Function findToken(jsonString As String)
    '{"access_token":"really long token","token_type":"bearer","expires_in":299}
    'split the string by the ,
    'then split those records by :
    'find the access_token record and return the value

    Dim records() As String
    Dim valuepairs() As String
    
    records = Split(jsonString, ",")
    
    For i = LBound(records()) To UBound(records())
        valuepairs = Split(records(i), ":")
        If InStr(valuepairs(0), "access_token") > 0 Then
            findToken = Replace(valuepairs(1), """", "")
            Exit Function
        End If
    Next i
    
End Function
