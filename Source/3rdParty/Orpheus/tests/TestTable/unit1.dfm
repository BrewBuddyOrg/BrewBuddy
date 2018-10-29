object Form1: TForm1
  Left = 192
  Top = 114
  Width = 816
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    808
    446)
  PixelsPerInch = 96
  TextHeight = 14
  object OvcTable1: TOvcTable
    Left = 16
    Top = 16
    Width = 777
    Height = 409
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clWindow
    Controller = OvcController1
    GridPenSet.NormalGrid.NormalColor = clBtnShadow
    GridPenSet.NormalGrid.Style = psDot
    GridPenSet.NormalGrid.Effect = geBoth
    GridPenSet.LockedGrid.NormalColor = clBtnShadow
    GridPenSet.LockedGrid.Style = psSolid
    GridPenSet.LockedGrid.Effect = ge3D
    GridPenSet.CellWhenFocused.NormalColor = clBlack
    GridPenSet.CellWhenFocused.Style = psSolid
    GridPenSet.CellWhenFocused.Effect = geBoth
    GridPenSet.CellWhenUnfocused.NormalColor = clBlack
    GridPenSet.CellWhenUnfocused.Style = psDash
    GridPenSet.CellWhenUnfocused.Effect = geBoth
    LockedRowsCell = OvcTCColHead1
    Options = [otoNoRowResizing, otoNoColResizing, otoTabToArrow, otoEnterToArrow, otoAlwaysEditing, otoNoSelection, otoThumbTrack]
    TabOrder = 0
    OnGetCellData = OvcTable1GetCellData
    CellData = (
      'Form1.OvcTCColHead1'
      'Form1.OvcTCRowHead1'
      'Form1.OvcTCString1'
      'Form1.OvcTCMemo1'
      'Form1.OvcTCCheckBox1'
      'Form1.OvcTCComboBox1'
      'Form1.OvcTCBitMap1')
    RowData = (
      35)
    ColData = (
      120
      False
      True
      'Form1.OvcTCRowHead1'
      100
      False
      True
      'Form1.OvcTCString1'
      150
      False
      True
      'Form1.OvcTCMemo1'
      120
      False
      True
      'Form1.OvcTCCheckBox1'
      160
      False
      True
      'Form1.OvcTCComboBox1'
      100
      False
      True
      'Form1.OvcTCBitMap1')
  end
  object OvcTCColHead1: TOvcTCColHead
    Headings.Strings = (
      'TOvcTCRowHead'
      'TOvcTCString'
      'TOvcTCMemo'
      'TOvcTCCheckBox'
      'TOvcTCComboBox'
      'TOvcTCBitmap')
    ShowLetters = False
    Adjust = otaCenter
    Table = OvcTable1
    Left = 48
  end
  object OvcTCRowHead1: TOvcTCRowHead
    Adjust = otaCenter
    Table = OvcTable1
    Left = 80
  end
  object OvcTCString1: TOvcTCString
    AutoAdvanceLeftRight = True
    Table = OvcTable1
    Left = 144
  end
  object OvcTCMemo1: TOvcTCMemo
    Table = OvcTable1
    Left = 264
  end
  object OvcTCCheckBox1: TOvcTCCheckBox
    Adjust = otaCenter
    CellGlyphs.IsDefault = True
    CellGlyphs.GlyphCount = 3
    CellGlyphs.ActiveGlyphCount = 2
    Table = OvcTable1
    Left = 384
  end
  object OvcTCComboBox1: TOvcTCComboBox
    Style = csDropDownList
    Table = OvcTable1
    OnChange = OvcTCComboBox1Change
    Left = 512
  end
  object OvcTCBitMap1: TOvcTCBitMap
    Adjust = otaTopCenter
    Table = OvcTable1
    Left = 624
  end
  object OvcController1: TOvcController
    EntryCommands.TableList = (
      'Default'
      True
      ()
      'WordStar'
      False
      ()
      'Grid'
      False
      ())
    Epoch = 2000
    Left = 16
  end
end
