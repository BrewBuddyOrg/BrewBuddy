unit Unit1; 

{$mode objfpc}{$H+}
{$linklib libdoublefann.dylib}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, fann, fannnetwork;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnrun: TButton;
    btnTrain: TButton;
    btnBuild: TButton;
    btnLoad: TButton;
    btnSave: TButton;
    lblmse: TLabel;
    lblerror: TLabel;
    memoXor: TMemo;
    procedure btnBuildClick(Sender: TObject);
    procedure btnrunClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnTrainClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

var nn :tfannnetwork;

{ TForm1 }

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
   nn.free;
end;

procedure TForm1.btnTrainClick(Sender: TObject);
var inputs: array [0..2] of double;
    outputs: array [0..0] of double;
    e,i,j: integer;
    mse: single;
    a :integer;
begin
        for e:=1 to 30000 do //Train 30000 epochs
        begin

                for i:= 0 to 1 do
                begin
                        for j:= 0 to 1 do
                        begin

                            inputs[0] := i;
                            inputs[1] := j;
                            outputs[0] := i * j;

                            mse := NN.Train(inputs,outputs);
                            lblMse.Caption := Format('%.4f',[mse]);
                            Application.ProcessMessages;

                        end;
                end;
        end;


        ShowMessage('Network Training Ended');

end;

procedure TForm1.btnLoadClick(Sender: TObject);
begin
  nn.LoadFromFile('fann.txt');
  btnbuild.enabled := false;
  btnrun.enabled := true;
  btntrain.enabled := true;
end;

procedure TForm1.btnrunClick(Sender: TObject);
var i,j: integer;
    output: array [0..2] of double;
    inputs: array [0..2] of double;

begin

     MemoXOR.Lines.Clear;

     for i := 0 to 1 do
     begin
        for j:= 0 to 1 do
        begin
                inputs[0] := i;
                inputs[1] := j;
                NN.Run(inputs,output);
                MemoXor.Lines.Add(Format('%d XOR %d = %f',[i,j,Output[0]]));

        end;
     end;

end;

procedure TForm1.btnSaveClick(Sender: TObject);
begin
  nn.savetofile('fann.txt');
end;

procedure TForm1.btnBuildClick(Sender: TObject);
begin
  nn.build;
  btnBuild.Enabled:=false;
  BtnTrain.Enabled:=true;
  btnRun.Enabled:=true;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  s :tstringlist;
begin
  s := tstringlist.create;
  s.add('3');
  s.add('2');
  s.add('1');
  nn := tfannnetwork.create(form1);
  nn.setlayers(s);
  nn. LearningRate := 0.699999988079071100;
  nn.ConnectionRate := 1.000000000000000000;
  nn.TrainingAlgorithm := taFANN_TRAIN_RPROP;
  nn.ActivationFunctionHidden := afFANN_SIGMOID;
  nn.ActivationFunctionOutput := afFANN_SIGMOID;
  //nn.filename := 'fann.txt';
  s.free;
end;

initialization
  {$I unit1.lrs}

end.
