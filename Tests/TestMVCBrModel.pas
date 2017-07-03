unit TestMVCBrModel;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit
  being tested.

}

interface

uses
  TestFramework, System.Classes,
  Forms,
  System.Generics.collections, MVCBr.Interf,
  MVCBr.Controller, System.JSON,
  MVCBr.Model, MVCBr.ModuleModel, System.SysUtils;

type
  // Test methods for class TModelFactory

  TModelFactoryMock = class(TModelFactory)
  private
    FRefCount: Integer;
    function GetStubInt: Integer;
    function Update: IModel; override;

  end;

  TestTModelFactory = class(TTestCase)
  strict private

    FModelFactory: TModelFactoryMock;

  Type
    TTesteController = class(TControllerFactory)
    end;
  protected
    FController: IController;
  public

    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestGetController;
    procedure TestGetOwned;
    procedure TestController;
    procedure TestThis;
    procedure TestGetID;
    procedure TestID;
    procedure TestUpdate;
    procedure TestAfterInit;

    procedure TestRegisterObserver;
    procedure TestUnRegisterObserverNamed;
    procedure TestUnRegisterObserverNamedOnly;
    procedure TesteObserver;

  end;

  TModuleFactoryMock = class(TModuleFactory)

  end;

  TestTModuleModelFactory = class(TTestCase)
  strict private

  [unsafe]
    FModelFactory: IModel;

  Type
    TTesteController = class(TControllerFactory)
    end;
  private
    procedure SetUp; override;
    procedure TearDown; override;

  protected
    [unsafe]
    FController: IController;
  public
    procedure TestGetOwned;
    procedure TestController;
    procedure TestThis;
    procedure TestGetID;
    procedure TestID;
    procedure TestUpdate;
    procedure TestAfterInit;

    procedure TestRegisterObserver;
    procedure TestUnRegisterObserverNamed;
    procedure TestUnRegisterObserverNamedOnly;
    procedure TesteObserver;
  published
    procedure TestGetController;
  end;

implementation

procedure TestTModelFactory.SetUp;
begin
  FController := TTesteController.Create;
  FModelFactory := TModelFactoryMock.Create;
  FController.add(FModelFactory);
end;

procedure TestTModelFactory.TearDown;
begin
  FModelFactory := nil;
  FController.release;
  FController := nil;
end;

procedure TestTModelFactory.TestGetController;
var
  ReturnValue: IController;
begin
  ReturnValue := FModelFactory.GetController;
  CheckNotNull(ReturnValue, 'Nao retornou');
  CheckTrue(TMVCBr.IsSame(IController, TMVCBr.GetGuid(ReturnValue)));
  // TODO: Validate method results
end;

procedure TestTModelFactory.TestGetOwned;
var
  ReturnValue: TComponent;
begin
  ReturnValue := FModelFactory.GetOwner;
  CheckNotNull(ReturnValue, 'Nao retornou');

  // TODO: Validate method results
end;

procedure TestTModelFactory.TestController;
var
  ReturnValue: IModel;
  AController: IController;
begin
  // TODO: Setup method call parameters
  ReturnValue := FModelFactory.Controller(AController);
  CheckNotNull(ReturnValue, 'Nao retornou');
  // TODO: Validate method results
end;

procedure TestTModelFactory.TesteObserver;
var
  ref: Integer;
begin
  TMVCBr.RegisterObserver('x', FModelFactory);
  ref := FModelFactory.GetStubInt;
  FModelFactory.UpdateObserver('x', nil);

  CheckTrue(FModelFactory.GetStubInt > ref, 'N�o chamou o evento do Observer');

  TMVCBr.UnRegisterObserver('x', FModelFactory);
end;

procedure TestTModelFactory.TestThis;
var
  ReturnValue: TObject;
begin
  ReturnValue := FModelFactory.This;
  CheckNotNull(ReturnValue, 'Nao retornou');
  // TODO: Validate method results
end;

procedure TestTModelFactory.TestGetID;
var
  ReturnValue: string;
begin
  ReturnValue := FModelFactory.GetID;
  CheckTrue(ReturnValue <> '');
  // TODO: Validate method results
end;

procedure TestTModelFactory.TestID;
var
  ReturnValue: IModel;
  AID: string;
begin
  // TODO: Setup method call parameters
  AID := FModelFactory.GetID;
  ReturnValue := FModelFactory.ID(AID);
  // TODO: Validate method results
  CheckNotNull(ReturnValue, 'Nao retornou');
  ReturnValue := nil;
end;

procedure TestTModelFactory.TestRegisterObserver;
var
  ref, ref2: Integer;
begin
  ref := TMVCBr.Observable.Count;
  TMVCBr.RegisterObserver('z', FModelFactory);
  ref2 := TMVCBr.Observable.Count;
  CheckTrue(ref2 > ref, 'N�o incrementou a lista de observable');
  TMVCBr.UnRegisterObserver('z');
end;

procedure TestTModelFactory.TestUnRegisterObserverNamed;
begin
  TMVCBr.RegisterObserver('y', FModelFactory);
  TMVCBr.UnRegisterObserver('y', FModelFactory);

end;

procedure TestTModelFactory.TestUnRegisterObserverNamedOnly;
begin
  TMVCBr.RegisterObserver('k', FModelFactory);
  TMVCBr.UnRegisterObserver('k');

end;

procedure TestTModelFactory.TestUpdate;
var
  ReturnValue: IModel;
begin
  ReturnValue := FModelFactory.Update;
  // TODO: Validate method results
  CheckNotNull(ReturnValue, 'Nao retornou');
end;

procedure TestTModelFactory.TestAfterInit;
begin
  // FModelFactory.AfterInit;
  // TODO: Validate method results
end;

{ TModelFactoryMock }

{ TModelFactoryMock }

function TModelFactoryMock.GetStubInt: Integer;
begin
  result := FRefCount;
end;

function TModelFactoryMock.Update: IModel;
begin
  result := self;
  inc(FRefCount);
end;

{ TestTModuleModelFactory }

procedure TestTModuleModelFactory.SetUp;
var
  o: TModuleFactoryMock;
begin
  FController := TTesteController.Create;
  TTesteController(FController.this).CreateModule(TModuleFactoryMock,o);
  FModelFactory := o;
end;

procedure TestTModuleModelFactory.TearDown;
begin
  FController.release;
  FController := nil;
  FModelFactory.this.free;
  FModelFactory := nil;

end;

procedure TestTModuleModelFactory.TestAfterInit;
begin

end;

procedure TestTModuleModelFactory.TestController;
begin

end;

procedure TestTModuleModelFactory.TesteObserver;
begin

end;

procedure TestTModuleModelFactory.TestGetController;
var
  ReturnValue: IController;
begin
  ReturnValue := FModelFactory.GetController;
  CheckNotNull(ReturnValue, 'Nao retornou');
  CheckTrue(TMVCBr.IsSame(IController, TMVCBr.GetGuid(ReturnValue)));
  ReturnValue := nil;
  // TODO: Validate method results
end;

procedure TestTModuleModelFactory.TestGetID;
begin

end;

procedure TestTModuleModelFactory.TestGetOwned;
begin

end;

procedure TestTModuleModelFactory.TestID;
begin

end;

procedure TestTModuleModelFactory.TestRegisterObserver;
begin

end;

procedure TestTModuleModelFactory.TestThis;
begin

end;

procedure TestTModuleModelFactory.TestUnRegisterObserverNamed;
begin

end;

procedure TestTModuleModelFactory.TestUnRegisterObserverNamedOnly;
begin

end;

procedure TestTModuleModelFactory.TestUpdate;
begin

end;

initialization

// Register any test cases with the test runner
RegisterTest(TestTModelFactory.Suite);
RegisterTest(TestTModuleModelFactory.Suite);

end.
