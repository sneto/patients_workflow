object FrmLogin: TFrmLogin
  Left = 480
  Top = 184
  BorderStyle = bsDialog
  Caption = 'Login'
  ClientHeight = 140
  ClientWidth = 258
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 36
    Top = 32
    Width = 26
    Height = 13
    Caption = 'Login'
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object btnCancel: TButton
    Left = 71
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object edtLogin: TEdit
    Left = 89
    Top = 29
    Width = 144
    Height = 21
    TabOrder = 1
  end
  object edtPassword: TEdit
    Left = 89
    Top = 61
    Width = 144
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
  end
  object btnConfirm: TButton
    Left = 158
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Confirm'
    TabOrder = 3
    OnClick = btnConfirmClick
  end
end
