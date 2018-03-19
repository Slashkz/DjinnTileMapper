program DjinnMapper;

uses
  Forms,
  DTMmain in 'DTMmain.pas' {DTM},
  inputbox in 'inputbox.pas' {InputForm},
  Search in 'Search.pas' {SearchForm},
  crtrd in 'crtrd.pas' {crtransform},
  srres in 'srres.pas' {searchresform},
  tmform in 'tmform.pas' {tilemapform},
  teditf in 'teditf.pas' {teditform},
  dataf in 'dataf.pas' {dataform},
  palf in 'palf.pas' {PalForm},
  WorkSpace in 'WorkSpace.pas' {WSForm},
  BitmapUtils in 'BitmapUtils.pas',
  mi_MapImage in 'mi_MapImage.pas',
  DIB in 'DIB.pas',
  DXConsts in 'DXConsts.pas',
  TilesUnit in 'TilesUnit.pas',
  HexUnit in 'HexUnit.pas',
  MyClasses in 'MyClasses.pas',
  NodeLst in 'NodeLst.pas',
  MetaTiles in 'MetaTiles.pas' {f_metatiles};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Tile Map Editor v1.0';
  Application.CreateForm(TDjinnTileMapper, DTM);
  Application.CreateForm(TInputForm, InputForm);
  Application.CreateForm(TSearchForm, SearchForm);
  Application.CreateForm(Tcrtransform, crtransform);
  Application.CreateForm(Tsearchresform, searchresform);
  Application.CreateForm(Ttilemapform, tilemapform);
  Application.CreateForm(Tteditform, teditform);
  Application.CreateForm(Tdataform, dataform);
  Application.CreateForm(TPalForm, PalForm);
  Application.CreateForm(TWSForm, WSForm);
  Application.CreateForm(Tf_metatiles, f_metatiles);
  Application.Run;
end.
