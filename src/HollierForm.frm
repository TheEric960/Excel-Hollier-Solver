VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} HollierForm 
   OleObjectBlob   =   "HollierForm.frx":0000
   Caption         =   "Hollier Solver"
   ClientHeight    =   3435
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   7260
   TypeInfoVer     =   62
End
Attribute VB_Name = "HollierForm"
Attribute VB_Base = "0{93B6090F-14BB-4820-9D95-9D919A4BE8C5}{0EB454C2-29A6-4747-9518-0AA4E5A582C5}"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Attribute VB_TemplateDerived = False
Attribute VB_Customizable = False

''=======================================================
'' Form:        HollierForm
'' Desc:        Gathers user settings and data for main
''              program.
'' Called by:   HollierProgram
'' Changes----------------------------------------------
'' Date         Programmer      Change
'' 05/25/2020   TheEric960      Written
''=======================================================


' ===========================================
' VARIABLE DECLARATIONS
' ===========================================

Public InputRange As Range
Public OutputCell As Range


' ===========================================
' FORM INITIALIZATION
' ===========================================

Private Sub UserForm_Initialize()
    Me.Top = Application.Top + (Application.UsableHeight / 2) - (Me.height / 2)
    Me.Left = Application.Left + (Application.UsableWidth / 2) - (Me.Width / 2)
End Sub


' ===========================================
' FORM INTERACTION METHODS
' ===========================================

' -------------------------------------------
' OK button
' -------------------------------------------
Private Sub CommandButton1_Click()
    If (getRange(RefEdit1.Text, InputRange) And Not (InputRange Is Nothing)) Then
        ''check if the array is square
        Dim arr1Length, arr2Length As Integer
        Dim arrRange() As Variant
        
        arrRange = InputRange
        arr1Length = UBound(arrRange, 1) - LBound(arrRange, 1)
        arr2Length = UBound(arrRange, 2) - LBound(arrRange, 2)
        
        If (arr1Length = arr2Length) Then
            ''check for 0s in the diagonals
            For i = LBound(arrRange) To UBound(arrRange)
                If (CheckBox1.Value And i = 1) Then
                    ''continue
                ElseIf (arrRange(i, i) <> 0) Then
                    MsgBox "Warning: Nonzeros found in the diagonal will not be accounted for.", _
                            Title:="Warning"
                            
                    Exit For
                End If
            Next
        
            ''check if output range option is selected, is present, and is correct
            If (OptionButton1.value = True And getRange(RefEdit2.Text, OutputCell) _
                    And Not (OutputCell Is Nothing)) Then
                Set OutputCell = OutputCell.Cells(1, 1)
                
                ''check for existing data in relative output range
                Dim ouputRange As Range
                Dim outputCellValues() As Variant
                Dim flagYes, flagNo As Boolean
                
                Set outputRange = OutputCell
                Set outputRange = outputRange.Resize(arr1Length + 1, arr1Length + 1)
                
                outputCellValues = Application.Transpose(outputRange)
                flagYes = False
                flagNo = False
                
                For i = LBound(outputCellValues, 1) To UBound(outputCellValues, 1)
                    For j = LBound(outputCellValues, 1) To UBound(outputCellValues, 1)
                        If (outputCellValues(i, j) <> "") Then
                            Dim response As Variant
                            response = MsgBox("Data was found in the output range. Continue?", _
                                    vbYesNo, "Warning")
                            
                            If (response = vbYes) Then
                                flagYes = True
                                Exit For
                            Else
                                flagNo = True
                                Exit For
                            End If
                        End If
                    Next
                    
                    If (flagYes Or flagNo) Then
                        Exit For
                    End If
                Next
                
                ''begin program if all checks pass
                Me.Hide
                
                If (Not flagNo) Then
                    HollierProgram.HollierSolver
                End If
                
                Unload Me
                
            ''use a new sheet
            ElseIf (OptionButton2.value = True) Then
                Me.Hide
                HollierProgram.HollierSolver
                Unload Me
            Else
                MsgBox ("Something is wrong with you output range. Please try reselecting it.")
            End If
        Else
            MsgBox ("Please make sure your input has the same number of rows and columns.")
        End If
    Else
        MsgBox ("Something is wrong with your input range. Please try reselecting it.")
    End If
End Sub

' -------------------------------------------
' Cancel button
' -------------------------------------------
Private Sub CommandButton2_Click()
    Unload Me
End Sub

' -------------------------------------------
' Help button
' -------------------------------------------
Private Sub CommandButton3_Click()
    MsgBox ("Input Range:" & vbTab & "Select your data" & vbLf _
           & "Machine Labels:" & vbTab & "Machine numbers are included" & vbLf & vbLf _
           & "Output Range:" & vbTab & "Select the output cell" & vbLf _
           & "New Worksheet:" & vbTab & "Output onto a new worksheet" & vbLf & vbLf _
           & "Hollier Method 2:" & vbTab & "Also solve with Hollier method 2" & vbLf _
           & "Flow Diagram:" & vbTab & "Create a machine flow diagram from the results")
End Sub

' -------------------------------------------
' Output Range option
' -------------------------------------------
Private Sub OptionButton1_Click()
    RefEdit2.Enabled = True
    RefEdit2.BackColor = &H80000005
End Sub

' -------------------------------------------
' New Worksheet option
' -------------------------------------------
Private Sub OptionButton2_Click()
    RefEdit2.Enabled = False
    RefEdit2.BackColor = &H80000016
End Sub


' ===========================================
' FORM SUPPORTING METHODS
' ===========================================

' -------------------------------------------
' Checks refedit and converts to range if valid
' -------------------------------------------
Function getRange(RefEditText As String, myRange As Range) As Boolean
    On Error Resume Next
    Set myRange = Range(RefEditText)
    On Error GoTo 0
    getRange = Not myRange Is Nothing
End Function
