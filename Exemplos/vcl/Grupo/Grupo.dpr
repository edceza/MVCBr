PROGRAM Grupo;






  MVCBr.ApplicationController,
  MVCBr.Controller,
  Grupo.Controller in 'controller\Grupo.Controller.pas',
  Grupo.ViewModel.Interf in 'viewmodel\Grupo.ViewModel.Interf.pas',
  Grupo.ViewModel in 'viewmodel\Grupo.ViewModel.pas',
  GrupoView in 'view\GrupoView.pas' {GrupoView},
  TabGrupo.ModuleModel in 'TabGrupo\module\TabGrupo.ModuleModel.pas' {TabGrupoModuleModel: TDataModule},
  TabGrupo.ModuleModel.Interf in 'TabGrupo\module\TabGrupo.ModuleModel.Interf.pas',
  Usuarios.Controller in 'Usuarios\controller\Usuarios.Controller.pas',
  UsuarioView in 'Usuarios\View\UsuarioView.pas' {UsuarioForm};

{$R *.res}









