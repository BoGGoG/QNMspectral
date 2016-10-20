(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* ::Input::Initialization:: *)
BeginPackage["QNMspectral`"];


(* ::Input::Initialization:: *)
GetModes::usage ="GetModes[\!\(\*
StyleBox[\"equation\",\nFontSlant->\"Italic\"]\),{\!\(\*
StyleBox[\"N\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\",\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"prec\",\nFontSlant->\"Italic\"]\)}] computes the quasinormal mode spectrum of \!\(\*
StyleBox[\"equation\",\nFontSlant->\"Italic\"]\) using a spectral grid of \!\(\*
StyleBox[\"N\",\nFontSlant->\"Italic\"]\)+1 points with \!\(\*
StyleBox[\"prec\",\nFontSlant->\"Italic\"]\) digits of precision.";
GetAccurateModes::usage = "GetAccurateModes[\!\(\*
StyleBox[\"equation\",\nFontSlant->\"Italic\"]\),{\!\(\*
StyleBox[\"N1\",\nFontSlant->\"Italic\"]\),\!\(\*
StyleBox[\"prec1\",\nFontSlant->\"Italic\"]\)},{\!\(\*
StyleBox[\"N2\",\nFontSlant->\"Italic\"]\),\!\(\*
StyleBox[\"prec2\",\nFontSlant->\"Italic\"]\)}] computes the quasinormal mode spectrum using GetModes with two different grid sizes and precisions specified by {\!\(\*
StyleBox[\"N1\",\nFontSlant->\"Italic\"]\),\!\(\*
StyleBox[\"prec1\",\nFontSlant->\"Italic\"]\)} and {\!\(\*
StyleBox[\"N2\",\nFontSlant->\"Italic\"]\),\!\(\*
StyleBox[\"prec2\",\nFontSlant->\"Italic\"]\)} returning only those digits which are the same for both.";
PlotFrequencies::usage = "PlotFrequencies[\!\(\*
StyleBox[\"modes\",\nFontSlant->\"Italic\"]\)] plots the quasinormal mode frequencies contained in \!\(\*
StyleBox[\"modes\",\nFontSlant->\"Italic\"]\) on the complex plane.";
MakeTable::usage = "MakeTable[\!\(\*
StyleBox[\"modes\",\nFontSlant->\"Italic\"]\)] creates a table of quasinormal mode frequencies.";
ShowModes::usage = "ShowModes[\!\(\*
StyleBox[\"modes\",\nFontSlant->\"Italic\"]\)] gives a plot and a table of the quasinormal modes contained in \!\(\*
StyleBox[\"modes\",\nFontSlant->\"Italic\"]\).";
PlotEigenfunctions::usage = "PlotEigenfunctions[\!\(\*
StyleBox[\"modes\",\nFontSlant->\"Italic\"]\)] plots the eigenfunctions contained in \!\(\*
StyleBox[\"modes\",\nFontSlant->\"Italic\"]\).";
FitFunction::usage = "FitFunction[\!\(\*
StyleBox[\"modes\",\nFontSlant->\"Italic\"]\),\!\(\*
StyleBox[\"f\",\nFontSlant->\"Italic\"]\)] fits the eigenfunctions in \!\(\*
StyleBox[\"modes\",\nFontSlant->\"Italic\"]\) to the function \!\(\*
StyleBox[\"f\",\nFontSlant->\"Italic\"]\).";
PlotFit::usage = "PlotFit[\!\(\*
StyleBox[\"fit\",\nFontSlant->\"Italic\"]\)] plots the time evolution of the \!\(\*
StyleBox[\"fit\",\nFontSlant->\"Italic\"]\) as given by the corresponding quasinormal modes.";


(* ::Input::Initialization:: *)
analyzeEquation::usage = "Internal function used to process the equation.";
computeMatrix::usage = "Internal function used to compute the numerical matrices representing the equation.";
sameModes::usage="Internal function used by GetAccurateModes. SameModes[\!\(\*
StyleBox[\"modes1\",\nFontSlant->\"Italic\"]\),\!\(\*
StyleBox[\"modes2\",\nFontSlant->\"Italic\"]\)] compares two lists of modes and returns those that occur in both lists.";
detFunction::usage = "Internal function used for sweeping.";


(* ::Input::Initialization:: *)
$QNMMemory::usage = "Global option that determines whether or not results are saved in GetModes (True by default).";
$QNMQuiet::usage="Global option that determines whether anything is printed (False by default).";


(* ::Input::Initialization:: *)
Horizon::usage="Option for GetModes that specifies the location of the horizon (defaults to 1).";
Eigenfunctions::usage="Option for GetModes that specifies whether or not to compute the eigenfunctions (defaults to False).";
NumericalBackground::usage="Option for GetModes that allows to specify numerical background functions directly as values on the same spectral grid.";


(* ::Input::Initialization:: *)
Protect@@{Horizon,Eigenfunctions,Method,NumericalBackground,SweepGrid,Parallel,Plot,Quiet,Cutoff,NModes,Precision,FunctionNumber,Rescale,RealCutoff,FrequencySign,tMax,GridPoint,Rescale,RescaleFrequency,Name,Conjugates,ConjugateCutoff};


(* ::Input::Initialization:: *)
Begin["`Private`"];


(* ::Input::Initialization:: *)
paQ=Developer`PackedArrayQ;
topa=Developer`ToPackedArray;
format[expr_]:=If[$MinPrecision<=$MachinePrecision//TrueQ,expr//N//topa,expr//(SetPrecision[#,$MinPrecision]&)]


(* ::Input::Initialization:: *)
Attributes[catchError]=Attributes[throwError]={HoldAll};
catchError[expr_,returnLocation___]:=Catch[expr,$Failed,Return[#1,returnLocation]&]
throwError[message_,messageArguments___]:=(Message[message,messageArguments];Throw[$Failed,$Failed])


(* ::Input::Initialization:: *)
printIf[expr_]:=If[Not@$QNMQuiet,Print[expr]]
printTemporaryIf[expr_]:=If[Not@$QNMQuiet,PrintTemporary[expr]]


(* ::Input::Initialization:: *)
eqs={(3 (3+4 z^2+9 z^4)-18 I z \[Lambda]) Z3[z]+(3 z (-3+7 z^4)-12 I z^2 \[Lambda]) Derivative[1][Z3][z]+3 z^2 (-1+z^4) (Z3^\[Prime]\[Prime])[z],1000000 ((3 (3+400 z^2+9 z^4)-18 I z \[Lambda]) bla[z]+(3 z (-3+7 z^4)-12 I z^2 \[Lambda]) Derivative[1][bla][z]+3 z^2 (-1+z^4) (bla^\[Prime]\[Prime])[z])};
old[n_,prec_]:=computeMatrix[Sequence@@Most[analyzeEquation[eqs]],1,{n,prec}]
new[n_,prec_]:=computeMatrix2[Sequence@@Most[analyzeEquation[eqs]],1,{n,prec}]


(* ::Input::Initialization:: *)
coefficientToMatrixC=Compile[{{vecList,_Complex,2},{matList,_Real,3}},Total[vecList*matList],CompilationTarget->"C"];


(* ::Input::Initialization:: *)
$QNMMemory=True;
$QNMQuiet=False;


(* ::Input::Initialization:: *)
Options[GetModes]={Horizon->1,Eigenfunctions->False,Method->"Direct",NumericalBackground->False,SweepGrid->{{-1,5,10^-1},{-5,1,10^-1}},Parallel->False,Plot->False,Quiet->False};
GetModes[equation_,{order_},opts : OptionsPattern[]]:=GetModes[equation,{order,order/2},opts]
GetModes[equation_,{order_,precision_ },opts : OptionsPattern[]]:=
Block[{method=OptionValue[Method],hor=OptionValue[Horizon],numBG=OptionValue[NumericalBackground],quiet=OptionValue[Quiet],eigenfuncts=OptionValue[Eigenfunctions],
eqn,Neqs,functs,var,\[Omega],bgfuncts,maxder,maxpower,
grid,Mcoeffs,
computeEigensyst,eigensyst,
result},

catchError[{eqn,Neqs,functs,var,\[Omega],bgfuncts,maxder,maxpower}=analyzeEquation[equation,numBG,order],Block];

If[method=!="Sweep"&&quiet==False,\[Omega]powerMessage[maxpower,Neqs,order]];

{grid,Mcoeffs}=computeMatrix[eqn,Neqs,functs,var,\[Omega],bgfuncts,maxder,hor,{order,precision}];

computeEigensyst=catchError[Switch[method,
"Direct",direct,
"Sweep",sweep[##,OptionValue[SweepGrid],OptionValue[Parallel],OptionValue[Plot]]&,
_,throwError[GetModes::method,ToString@method]],Block];

eigensyst=catchError[computeEigensyst[Mcoeffs,precision,order,maxpower,eigenfuncts],Block];

result=reorganize[eigensyst,grid,order,Neqs,maxpower];

If[TrueQ@$QNMMemory,GetModes[equation,{order,precision},opts]=result,result]
]


(* ::Input::Initialization:: *)
GetModes::method="Unknown Method `1`.";


(* ::Input::Initialization:: *)
analyzeEquation[equation_,numBG_ : False,order_ : False]:=Block[{eqn=equation/.(a_==b_:>a-b)//Expand,Neqs,functs,var,\[Omega],bgfuncts,maxpower,maxder},
If[Head[eqn]=!=List,eqn={eqn}];

With[{symbols=Union@Cases[eqn,s_Symbol/;Not@NumericQ[s],\[Infinity]]},
If[Length[symbols]>2,throwError[analyzeEquation::manysymb,ToString@symbols]];
If[Length[symbols]<2,throwError[analyzeEquation::fewsymb,ToString@symbols]];
];

var=Union[Cases[eqn,f_Symbol[z_Symbol]:>z,\[Infinity]],Cases[eqn,
\!\(\*SuperscriptBox[\(f_Symbol\), 
TagBox[
RowBox[{"(", "n_", ")"}],
Derivative],
MultilineFunction->None]\)[z_Symbol]:>z,\[Infinity]]]//Last;
\[Omega]=Union@Cases[equation,_Symbol,\[Infinity]]//DeleteCases[#,var]&//Last;

(* Check which functions are background functions supplied with their value on the grid, and if it is done correctly (check if length equals length of grid) *)
bgfuncts=If[numBG===False,{},
If[Not@(And@@(Length[#[[2]]]==order+1&)/@numBG),throwError[analyzeEquation::bg],
numBG/.(f_Symbol[var]->values_List):>(f->values)]];

functs=Complement[Union[Cases[equation,f_Symbol[var]/;Context[f]=!="System`":> f,\[Infinity]]~Join~Cases[equation,
\!\(\*SuperscriptBox[\(f_Symbol\), 
TagBox[
RowBox[{"(", "_", ")"}],
Derivative],
MultilineFunction->None]\)[var]:>f,\[Infinity]]],bgfuncts[[All,1]]];

Neqs=Length[eqn];
If[Neqs<Length[functs],throwError[analyzeEquation::manyfcts,ToString@functs]];
If[Neqs>Length[functs],throwError[analyzeEquation::fewfcts,ToString@functs]];

maxpower=Cases[eqn,\[Omega]^(pow_ : 1):>pow,\[Infinity]]//Max;
maxder=Cases[eqn,
\!\(\*SuperscriptBox[\(f_\), 
TagBox[
RowBox[{"(", "n_", ")"}],
Derivative],
MultilineFunction->None]\)[var]:>n/;Intersection[{f},functs]!={},\[Infinity]]//Max;

{eqn,Neqs,functs,var,\[Omega],bgfuncts,maxder,maxpower}
]


(* ::Input::Initialization:: *)
analyzeEquation::manysymb="Too many symbols in equation, symbols found: `1`.";
analyzeEquation::fewsymb="Too few symbols in equation, symbols found: `1`.";
analyzeEquation::bg="Background not given as values evaluated on grid of same size.";
analyzeEquation::manyfcts="More functions than equations, functions found: `1`.";
analyzeEquation::fewfcts="More equations than functions, functions found: `1`.";


(* ::Input::Initialization:: *)
\[Omega]powerMessage[maxpower_,Neqs_,order_]:=Switch[{Neqs,maxpower},
{1,1},0,
{1,_},printTemporaryIf["Equation depending on frequency to power "<>ToString[maxpower]<>", computing with matrix of size "<>ToString[(order+1)maxpower]<>" ("<>ToString[maxpower]<>" times the gridsize)."];,
{_,1},
printTemporaryIf["System of "<>ToString[Neqs]<>" coupled equations, computing with matrix of size "<>ToString[(order+1)Neqs]<>" ("<>ToString[Neqs]<>" times the gridsize)."];,
{_,_},
printTemporaryIf["System of "<>ToString[Neqs]<>" coupled equations depending on frequency to power "<>ToString[maxpower]<>", computing with matrix of size "<>ToString[maxpower Neqs (order+1)]<>" ("<>ToString[Neqs maxpower]<>" times the gridsize)."]];



(* ::Input::Initialization:: *)
computeMatrix[equation_,Neqs_,functs_,var_,\[Omega]_,numBG_,maxder_,hor_,{order_,precision_}]:=Block[{grid,der,coeffs,coeffsEval,M\[Omega]List},

coeffs=coefficients[equation,functs,var,\[Omega],maxder];

makeSpectralGrid[{grid,der},{order,precision,hor}];

coeffsEval=evaluateCoefficients[coeffs,grid,der,var,numBG,precision];

M\[Omega]List=coeffsToMatrix[coeffsEval,der,maxder,Neqs,precision];

{grid,M\[Omega]List}
]


(* ::Input::Initialization:: *)
coefficients[equation_,functs_,var_,\[Omega]_,maxder_]:=Block[{\[Omega]coeffs,functsAndDers},
\[Omega]coeffs=CoefficientList[equation,\[Omega]]//PadRight;

functsAndDers=Table[
\!\(\*SuperscriptBox[\(#1\), 
TagBox[
RowBox[{"(", "i", ")"}],
Derivative],
MultilineFunction->None]\)[var],{i,0,maxder}]&/@functs//Flatten;

Map[Coefficient[#,functsAndDers]&,\[Omega]coeffs,{2}]//Transpose
]


(* ::Input::Initialization:: *)
Attributes[makeSpectralGrid]={HoldFirst};
makeSpectralGrid[{grid_Symbol,der_Symbol},{order_Integer,prec_?NumericQ,hor_?NumericQ}]:=Block[{$MinPrecision=prec},
grid=Rescale[Cos[\[Pi]/order format@Range[0,order]],{-1,1},{0,hor}] //format;
der[0]=IdentityMatrix[order+1]//format;(* Note there is a bug with the function below, using ["DifferentiationMatrix"] gives a wrong last column *)
der[n_]:=der[n]=(-1)^n NDSolve`FiniteDifferenceDerivative[n,grid//Reverse,DifferenceOrder->"Pseudospectral"]/@IdentityMatrix[order+1]//Transpose;
]


(* ::Input::Initialization:: *)
evaluateCoefficients[coeffs_,grid_,der_,var_,numBG_,precision_]:=Block[{$MinPrecision=Max[precision,$MachinePrecision],maxderBG,replace,idVec},
maxderBG=Cases[coeffs,
\!\(\*SuperscriptBox[\(f_\), 
TagBox[
RowBox[{"(", "n_", ")"}],
Derivative],
MultilineFunction->None]\)[var]:>n,\[Infinity]]//Max;

replace=If[numBG=!={},Flatten[Table[
\!\(\*SuperscriptBox[\(f\[LeftDoubleBracket]1\[RightDoubleBracket]\), 
TagBox[
RowBox[{"(", "n", ")"}],
Derivative],
MultilineFunction->None]\)[var]->der[n].f[[2]],{f,format@numBG},{n,0,maxderBG}],1],{}]~Join~{var->grid};

idVec=Table[1,{Length@grid}]//format;
Map[idVec*#&,coeffs/.replace,{3}]
]


(* ::Input::Initialization:: *)
coeffsToMatrix[coeffs_,der_,maxder_,Neqs_,precision_]:=Block[{$MinPrecision=Max[precision,$MachinePrecision],Nfuncts=Neqs,Mpart,ders,coeffToMatFunc},
Mpart=Map[First[Partition[Partition[#,maxder+1],Nfuncts]]&,coeffs,{2}];

ders=der/@Range[0,maxder];

coeffToMatFunc=If[$MinPrecision<=$MachinePrecision,coefficientToMatrixC,{vs,ms}\[Function]Total[vs*ms]];
ArrayFlatten/@Map[coeffToMatFunc[# , ders]&,Mpart,{3}]
]


(* ::Input::Initialization:: *)
direct[Mcoeffs_,precision_,order_,maxpower_,eigenfuncts_]:=Block[{
$MinPrecision=Max[precision,$MachinePrecision],
\[Alpha],\[Beta],mat0=0 IdentityMatrix[Length@First[Mcoeffs]],mat1=IdentityMatrix[Length@First[Mcoeffs]]},

If[maxpower==1,\[Alpha]=Mcoeffs[[0+1]];\[Beta]=-Mcoeffs[[1+1]];,
\[Alpha]=Table[If[i==0,Mcoeffs[[j+1]],If[i==j,mat1,mat0]],{i,0,maxpower-1},{j,0,maxpower-1}]//ArrayFlatten;
\[Beta]=Table[If[i==0&&j==maxpower-1,-Mcoeffs[[maxpower+1]],If[i==j+1,mat1,mat0]],{i,0,maxpower-1},{j,0,maxpower-1}]//ArrayFlatten;];

\[Alpha]=\[Alpha]+If[$MinPrecision<$MachinePrecision,0. I,0]//format; 
\[Beta]=\[Beta]+If[$MinPrecision<$MachinePrecision,0. I,0]//format;

If[TrueQ@eigenfuncts,Eigensystem[{\[Alpha],\[Beta]}],Eigenvalues[{\[Alpha],\[Beta]}]]
]


(* ::Input::Initialization:: *)
sweep[Mcoeffs_,precision_,order_,maxpower_,eigenfuncts_,sweepGrid_,parallel_,plot_]:=Block[{$MinPrecision=Max[precision,$MachinePrecision],
eigensyst0,detf,
\[Omega]ReMin,\[Omega]ReMax,\[Delta]\[Omega]Re,\[Omega]ImMin,\[Omega]ImMax,\[Delta]\[Omega]Im,
\[Omega]grid,\[Omega]detgrid,\[Omega]ReVals,\[Omega]ImVals,\[Omega]DetVals,neighbors,tests,count,map,
eigenvalues,eigenvectors,
M,\[Omega]},
M=Inner[Times,Mcoeffs,\[Omega]^Range[0,maxpower],Plus,1];

If[MatchQ[sweepGrid,{{_?NumericQ,_?NumericQ,_?NumericQ},{_?NumericQ,_?NumericQ,_?NumericQ}}]//TrueQ,
{{\[Omega]ReMin,\[Omega]ReMax,\[Delta]\[Omega]Re},{\[Omega]ImMin,\[Omega]ImMax,\[Delta]\[Omega]Im}}=sweepGrid//format,
throwError[sweep::grid]];
\[Omega]grid=Table[a+b I,{a,\[Omega]ReMin,\[Omega]ReMax,\[Delta]\[Omega]Re},{b,\[Omega]ImMin,\[Omega]ImMax,\[Delta]\[Omega]Im}]//Flatten[#,1]&//format;

detf=detFunction[M,\[Omega]];

count=0;
If[TrueQ@parallel,SetSharedVariable[count];DistributeDefinitions[detf];map=ParallelMap;,map=Map;];
\[Omega]detgrid=Monitor[Quiet[If[TrueQ@parallel,ParallelMap,Map][{Re[#],Im[#],count++;detf[#]}&,\[Omega]grid],LinearSolve::luc],
{ProgressIndicator[count,{0,Length@\[Omega]grid}],ToString[count]<>"/"<>ToString[Length@\[Omega]grid]}];

If[TrueQ@plot,printIf[Show[ListContourPlot[\[Omega]detgrid,(*Mesh\[Rule]All,*)FrameLabel->{"Re \[Omega]","Im \[Omega]"}],ListPlot[\[Omega]detgrid[[All,1;;2]],PlotStyle->Red]]]];

neighbors=List@@@DelaunayMesh[\[Omega]detgrid[[All,1;;2]]]["VertexVertexConnectivityRules"];
{\[Omega]ReVals,\[Omega]ImVals,\[Omega]DetVals}=Transpose[\[Omega]detgrid];
tests=And@@Thread[\[Omega]DetVals[[#1]]<\[Omega]DetVals[[#2]]&&\[Omega]ReMin<\[Omega]ReVals[[#1]]<\[Omega]ReMax&&\[Omega]ImMin<\[Omega]ImVals[[#1]]<\[Omega]ImMax]&@@@neighbors;

eigenvalues=#[[1]]+I #[[2]]&/@Pick[\[Omega]detgrid[[All,1;;2]],tests];
If[TrueQ@eigenfuncts,
eigenvectors=(Eigensystem[M/.\[Omega]->#,-1][[2,1]]&)/@eigenvalues; 
{eigenvalues,eigenvectors},
eigenvalues]
]


(* ::Input::Initialization:: *)
sweep::grid="Grid should be of the form {{\[Omega]ReMin,\[Omega]ReMax,\[Delta]\[Omega]Re},{\[Omega]ImMin,\[Omega]ImMax,\[Delta]\[Omega]Im}} .";


(* ::Input::Initialization:: *)
detFunction[M_List,\[Omega]_Symbol]:=Block[{$MinPrecision=Max[Precision@M,$MachinePrecision],dM},
dM=\!\(
\*SubscriptBox[\(\[PartialD]\), \(\[Omega]\)]M\);
If[$MinPrecision<=$MachinePrecision,M=M+0.0 I//format;dM=dM+0.0 I//format;];

Hold[Function][\[Omega],1/Hold[Abs][Hold[Tr][Hold[LinearSolve][M,dM]]]]/.Hold[x_]:>x
]


(* ::Input::Initialization:: *)
reorganize[eigensyst_,grid_,order_,Neqs_,maxpower_]:=Block[{eigenvalues,eigenvectors,eigenvectorsSorted,eigenvectorsNormalized},
If[Length[Dimensions@eigensyst]==1,
eigensyst//Select[#,NumericQ]&//SortBy[#,Im]&//Reverse,

{eigenvalues,eigenvectors}=eigensyst;
eigenvectorsSorted=Partition[#,order+1]&/@(Take[#,Neqs(order+1)]&/@eigenvectors);
eigenvectorsNormalized=Map[Transpose[{grid,If[Max[Abs@#]>10^-10,Conjugate[First@#]/Norm[First@#]^2,1]#}]&,eigenvectorsSorted,{2}];
{eigenvalues,eigenvectorsNormalized}//Transpose//Cases[#,x_/;NumericQ@First[x]]&//SortBy[#,(-Im[First[#1]]&)]&
]
]


(* ::Input::Initialization:: *)
Options[GetAccurateModes]={Cutoff->1};
GetAccurateModes[equation_,{N1_,M1_  : "default",opts1___},{N2_,M2_  : "default",opts2___},opts:OptionsPattern[{GetAccurateModes,GetModes}]]:=Block[
{prec1=M1/."default"->N1/2,prec2=M2/."default"->N2/2,modes1,modes2},

modes1=GetModes[equation,{N1,prec1},FilterRules[{opts1,opts},Options[GetModes]]/.{}->Sequence[]];
modes2=GetModes[equation,{N2,prec2},FilterRules[{opts2,opts},Options[GetModes]]/.{}->Sequence[]];

sameModes[modes1,modes2,OptionValue[Cutoff]]
]


(* ::Input::Initialization:: *)
sameModes[modes1_,modes2_,cutoff_ : 1]:=Block[{modesMax,modesMin,prec1=Precision[modes1],prec2=Precision[modes2],agreedModes1,agreedModes2},
{modesMax,modesMin}=Sort[{modes1,modes2},Length[#1]>Length[#2]&];

agreedModes1=Cases[modesMax,(mode_/;minDiff[modesMin][mode]<10^-cutoff)];

catchError[If[agreedModes1==={},throwError[sameModes::noconvergedmodes,cutoff]],Block];

agreedModes2=SetPrecision[#,(-Floor@Log[10,Abs@minDiff[modesMin][#]])/.Indeterminate->Max[Min[prec1,prec2],$MachinePrecision]]&/@agreedModes1;

agreedModes2//If[Length[#[[1]]]==0,SortBy[#,(-Im[#1]&)],SortBy[#,(-Im[First[#1]]&)]]&
]


(* ::Input::Initialization:: *)
sameModes::noconvergedmodes="No modes found that agree up to order \!\(\*SuperscriptBox[\(10\), \(-`1`\)]\)";


(* ::Input::Initialization:: *)
minDiff[refmodes_][singleMode_]:=If[Length[singleMode]==0,
Abs[MinimalBy[Abs][(#-refmodes)]&[singleMode]]//Last,
Abs[MinimalBy[Abs][(#-refmodes[[All,1]])]&[singleMode[[1]]]]//Last]


(* ::Input::Initialization:: *)
plotopts=Sequence[
Axes->True,
ImageSize->600,
Frame->True,
PlotStyle->{{Blue,Thick}},
AxesOrigin->{0,0},
BaseStyle->{FontSize->30},
LabelStyle->{FontSize->30}];


(* ::Input::Initialization:: *)
Options[PlotFrequencies]={NModes->All,Name->"\[Omega]"};
PlotFrequencies[modes_,opts : OptionsPattern[{PlotFrequencies,ListPlot}]]:=Block[{n=OptionValue[NModes]/.All->-1,\[Omega]=OptionValue[Name],freqs},
catchError[If[Not@StringQ@\[Omega],throwError[PlotFrequencies::name]],Block];

If[n>Length[modes],Message[PlotFrequencies::nmodes,n,n=Length[modes]]];

freqs=modes[[1;;n]]//If[Length[modes[[1]]]==0,#,#[[All,1]]]&;

ListPlot[freqs/.{Complex[a_,b_]:>{a,b},0->{0,0}},FilterRules[{opts},Options[ListPlot]],FrameLabel->{"Re "<>\[Omega],"Im "<>\[Omega]},PlotStyle->{Blue,PointSize[Large]},plotopts]
]


(* ::Input::Initialization:: *)
PlotFrequencies::nmodes="There are not as many modes as `1`, plotting all `2` instead.";
PlotFrequencies::name="The name should be a string.";


(* ::Input::Initialization:: *)
nrtostring[nr_]:=ToString[nr,TraditionalForm];


(* ::Input::Initialization:: *)
Options[MakeTable]={NModes->All,Precision->10,Name->"\!\(\*SubscriptBox[\(\[Omega]\), \(n\)]\)",ConjugateCutoff->3};

MakeTable[modes_,OptionsPattern[]]:=Block[{n=OptionValue[NModes]/.All->-1,prec=OptionValue[Precision],\[Omega]=OptionValue[Name],conjCutoff=OptionValue[ConjugateCutoff],
conjQ,uniquefreqs},
catchError[If[Not@StringQ@\[Omega],throwError[MakeTable::name]],Block];

catchError[conjQ=If[conjCutoff===False,(False&),
If[NumericQ@conjCutoff,
(Abs[Im[#1]-Im[#2]]<10^-conjCutoff||N[Abs[Im[#1]-Im[#2]]]==0.&),
throwError[MakeTable::conjugates]]],
Block];

uniquefreqs=DeleteDuplicates[modes,conjQ];
If[n>Length[uniquefreqs],Message[MakeTable::nmodes,n,n=Length[uniquefreqs]]];
uniquefreqs=uniquefreqs[[1;;n]]//If[Length[modes[[1]]]==0,#,#[[All,1]]]&;
(*If[n>Length[modes],Message[MakeTable::nmodes,n,n=Length[modes]]];*)

Block[{
setPrec=If[prec==\[Infinity]//TrueQ,#&,N[#,   Min[Precision[#],prec]      ]&]},
{{"n","Re "<>\[Omega],"Im "<>\[Omega]}}~Join~Table[
{i,If[Abs[Re[uniquefreqs[[i]]]]>10^-10,"\[PlusMinus] ",""]<>nrtostring[Abs@Re@uniquefreqs[[i]]//setPrec],Im@uniquefreqs[[i]]//setPrec},
{i,1,Length@uniquefreqs}]//Grid[#,Frame->All]&
]
]


(* ::Input::Initialization:: *)
MakeTable::nmodes="There are not as many modes as `1`, showing all `2` instead.";
MakeTable::name="The name should be a string.";
MakeTable::conjugateCutoff="Option ConjugateCutoff should be a number.";


(* ::Input::Initialization:: *)
ShowModes[modes_,opts :OptionsPattern[{PlotFrequencies,ListPlot,MakeTable}]]:=Block[{n=OptionValue[NModes]},
If[n>Length[modes],Message[ShowModes::nmodes,n,n=Length[modes]]];

{PlotFrequencies[modes,FilterRules[{NModes->n,opts},Options[PlotFrequencies]~Join~Options[ListPlot]]],MakeTable[modes,FilterRules[{NModes->n,opts},Options[MakeTable]]]}
]


(* ::Input::Initialization:: *)
ShowModes::nmodes="There are not as many modes as `1`, showing all `2` instead.";


(* ::Input::Initialization:: *)
eigenfunctionsQ[modes_]:=Length[Dimensions@modes]==2


(* ::Input::Initialization:: *)
Options[PlotEigenfunctions]={NModes->All,FunctionNumber->1,Rescale->0,Conjugates ->(#[[-3]]<0&)};

PlotEigenfunctions[modes_,opts : OptionsPattern[{PlotEigenfunctions,Plot}]]:=Block[{n=OptionValue[NModes]/.All->Length[modes],fn=OptionValue[FunctionNumber],resc=OptionValue[Rescale],conjQ=OptionValue[Conjugates]/.False->(False&),eigenfcts,grid,fRe,fIm,hor,fname},

If[n>Length[modes],Message[PlotEigenfunctions::nmodes,n,n=Length[modes]]];
catchError[If[Not@eigenfunctionsQ[modes],throwError[PlotEigenfunctions::efcomputed]],Block];
If[fn>Length[modes[[1,2]]],Message[PlotEigenfunctions::nfuncts,fn];fn=1];

grid=modes[[1,2,1,All,1]];hor=grid[[1]];
eigenfcts=If[resc==0,1,(grid/hor)^resc] #&/@ modes[[1;;n,2,fn,All,2]];
fRe=eigenfcts//Re;
fIm=eigenfcts//Im;

fIm=DeleteCases[fIm,x_/;conjQ[x]];

fRe=Transpose[{grid,#}]&/@fRe;
fIm=Transpose[{grid,#}]&/@fIm;

fname="\!\(\*SubscriptBox[\(f\), \(n\)]\)(z)"<>If[resc==0//TrueQ,"","\!\(\*SuperscriptBox[\(z\), \("<>nrtostring[resc]<>"\)]\)"];
ListPlot[fRe~Join~fIm,FilterRules[{opts},Options[Plot]],PlotRange->{{0,hor},Automatic},Joined->True,
PlotStyle->Table[{Blue,Thick},{n}]~Join~Table[{Red,Thick},{n}],
PlotLegends->Placed[LineLegend[{Blue,Red},{"Re","Im"},LegendFunction->(Framed[#,RoundingRadius->5,Background->White]&)],{.9,.825}],
FrameLabel->{"z",fname},plotopts]
]


(* ::Input::Initialization:: *)
PlotEigenfunctions::nmodes="There are not as many modes as `1`, using all `2` instead.";
PlotEigenfunctions::efcomputed="Eigenfunctions not computed, use option Eigenfunctions -> True in GetModes.";
PlotEigenfunctions::nfuncts="There are not as many functions as `1`, plotting the first function instead.";


(* ::Input::Initialization:: *)
Options[FitFunction]={FunctionNumber->1,NModes->All,RealCutoff->10^-5,FrequencySign->-1};

FitFunction[modes_List,function_,OptionsPattern[]]:=(Message[FitFunction::puref];Return[$Failed])

FitFunction[modes_List,function_Function,OptionsPattern[]]:=FitFunction[modes,function]=
Block[{n=OptionValue[NModes]/.All->-1,fn=OptionValue[FunctionNumber],
modes2,realModes,complexModes,
eigenfunctions,realEigenfunctions,complexEigenfunctions,
grid,
mat,vec,cns0,cns,cnsRe,cnsComplex,cnsSorted,
fitFunc,errors,frequencies,timeFunc},

If[n>Length[modes],Message[FitFunction::nmodes,n,n=Length[modes]]];
catchError[If[Not@eigenfunctionsQ[modes],throwError[FitFunction::efcomputed]],Block];
If[fn>Length[modes[[1,2]]],Message[FitFunction::nfuncts,fn];fn=1];

printTemporaryIf["Fitting "<>ToString[n/.-1->Length[modes]]<>" modes..."];

grid=modes[[1,2,1,All,1]];

(* All real modes, and all complex modes with any missing conjugates added and conjugate pairs reduced to one *)
(* In the critically overdamped case where eigenfunctions are real and doubly degenerate, if we remove the doubled modes the fit is worse..? *)
modes2=(SetPrecision[#,Max[Precision[#],Length[modes[[1,2,fn]]]/2]]&)/@modes[[1;;n]];
realModes=Select[modes2,Max[Abs[Im@#[[2,fn,All,2]]]]<OptionValue[RealCutoff]&](*//DeleteDuplicates[#,Norm[(#1\[LeftDoubleBracket]2,fn,All,2\[RightDoubleBracket]-#2\[LeftDoubleBracket]2,fn,All,2\[RightDoubleBracket])]<10^-3&]&*);
complexModes=Complement[modes2,realModes]//#~Join~(#/.{freq_,vec_}:>{-Conjugate[freq],Conjugate[vec]})&//DeleteDuplicates[#,Max[Abs/@(#1[[2,fn,All,2]]-#2[[2,fn,All,2]])]<10^-3&]&//Select[#,Im[#[[2,fn,All,2]][[-4]]]>10^-8&]&;

(* Real eigenfunctions, complex eigenfunctions *)
realEigenfunctions=If[Length[realModes]==0,{},realModes[[All,2,fn,All,2]]]//Re;
complexEigenfunctions=If[Length[complexModes]==0,{},complexModes[[All,2,fn,All,2]]];

(* Corresponding frequencies and eigenfunctions including conjugates *)
eigenfunctions=realEigenfunctions~Join~complexEigenfunctions~Join~Conjugate[complexEigenfunctions];
frequencies=(realModes[[All,1]]/.Complex[a_,b_]:>Complex[0,b])~Join~complexModes[[All,1]]~Join~(-Conjugate[complexModes[[All,1]]]);
printTemporaryIf["with "<>ToString[Length@realEigenfunctions]<>" real eigenfunctions and "<>ToString[Length@complexEigenfunctions]<>" complex eigenfunctions."];

(* Construct the matrix equation fitting the real part of the sum of QNM's to the given function *)
mat=realEigenfunctions~Join~Re[complexEigenfunctions]~Join~(-Im[complexEigenfunctions])//Transpose;
vec=function/@grid;

(* Solve it, using LeastSquares and not LinearSolve because the system is overconstrained *) 
cns0=LeastSquares[mat,vec];
(* Recombine coefficients to complex numbers for complex eigenfunctions *)
cnsRe=cns0[[1;;Length[realEigenfunctions]]];
cnsComplex=1/2 If[Length[complexEigenfunctions]==0,{},(cns0[[Length[realEigenfunctions]+1;;Length[realEigenfunctions]+Length[complexEigenfunctions]]]+I cns0[[-Length[complexEigenfunctions];;-1]])];
cns=cnsRe~Join~cnsComplex~Join~Conjugate[cnsComplex];

(* The results: fitted function, errors, coefficients, and resulting function of time*)
fitFunc=Transpose[{grid,(cns*eigenfunctions//Re//Total)}];
errors=Transpose[{grid,fitFunc[[All,2]]-vec}];

timeFunc=Exp[OptionValue[FrequencySign]I frequencies #]cns*eigenfunctions//Total //Re;

(* sort coefficients by imaginary part of corresponding frequency *)
cnsSorted=Transpose[{cns,frequencies}]//SortBy[#,OptionValue[FrequencySign] Im[Last@#1]&]&//#[[All,1]]&;

(* Output the result, the errors, the coefficients and the resulting function on the boundary *)
{fitFunc,errors,cnsSorted,timeFunc}
]


(* ::Input::Initialization:: *)
FitFunction::nmodes="There are not as many modes as `1`, using all `2` instead.";
FitFunction::efcomputed="Eigenfunctions not computed, use option Eigenfunctions -> True in GetModes.";
FitFunction::nfuncts="There are not as many functions as `1`, plotting the first function instead.";
FitFunction::puref="The second argument must be a pure function.";


(* ::Input::Initialization:: *)
Options[PlotFit]={tMax->1,GridPoint->-1,Rescale->0,RescaleFrequency->1};
PlotFit[fit_List,opts: OptionsPattern[{PlotFit,Plot}]]:=Block[{tmax=OptionValue[tMax]//SetPrecision[#,Max[Precision[#],100]]&,
\[Omega]resc=OptionValue[RescaleFrequency]//SetPrecision[#,Max[Precision[#],100]]&,
gridpoint=OptionValue[GridPoint],resc=OptionValue[Rescale],grid=fit[[1,All,1]],
fitfunc,fitlist},
fitfunc=(If[resc==0//TrueQ,func[fit[[-1,gridpoint]]],func[fit[[-1,gridpoint/.-1->-2]]/grid[[gridpoint/.-1->-2]]^resc]]//SetPrecision[#,100]&)/.func->Function;
fitlist={#,fitfunc[\[Omega]resc #]}&/@Range[0,tmax,tmax/200];
ListPlot[fitlist,FilterRules[{opts},Options[Plot]]//Evaluate,FrameLabel->{"t",""},Joined->True,plotopts//Evaluate]
]


(* ::Input::Initialization:: *)
End[];
EndPackage[];
