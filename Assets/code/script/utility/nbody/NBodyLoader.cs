
/********************************************************************
created:	2013-10-18
author:		lixianmin

purpose:	data config
Copyright (C) - All Rights Reserved
*********************************************************************/
using System;
using System.Collections;
using System.Collections.Generic;

class NBodyLoader
{
	public NBodyLoader()
	{
		_AddThreeOnCelticKnot();
		_AddTheFigure8();
		_AddTheSuper8();
		_AddFourOnCircularChain();
		_AddFiveOnCircularChain();
		_AddNoSymmetry();
		_AddSixOnBallerina();
		_AddSixOnSquare();
		_AddSixOnTensorSign();
		_AddSixOnPropellor();
		_AddSixOn5Daisy();
		_AddSixOnPentagram();
		_AddSixOn5PetalFlower();
		_AddSixOnHeptagram();
		_AddSixOn7PetalFlower();
		_AddSixOnAtom();
		_AddSevenOnButterfly();
		_AddSevenOnFigure8();
		_AddBowtie();
		_AddMoustache();
		_AddEightOn3PetalFlower();
		_AddEightOnClover();
		_AddEightOnTrefoil();
		_AddEightOn92Enneagram();
		_AddEightOn94Enneagram();
		_AddNineOnPieceOfGinger();
		_AddNineOnBear();
		_AddNineOnPropellor();
		_AddTenOnPentagram();
		_AddTenOnOctagram();
	}

	private void _AddThreeOnCelticKnot()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.ThreeOnCelticKnot]	= item;
		item.numParticles	= 3;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ -239, -0.100344031615630e-3, -223, 0.100461948267440e-3, -215, -0.127229956065949e-3, -211, -0.136740642191319e-3, -203, 0.152611374303531e-3, -199, 0.160873994352125e-3, -191, -0.180380449832013e-3, -187, -0.191524144636479e-3, -179, 0.217022137044051e-3, -175, 0.231392047946515e-3, -167, -0.263885397315392e-3, -163, -0.282190159361645e-3, -155, 0.323649901222267e-3, -151, 0.347244638368932e-3, -143, -0.400958930212301e-3, -139, -0.431442020276589e-3, -131, 0.499997406636318e-3, -127, 0.537108825054301e-3, -119, -0.622596972675339e-3, -115, -0.680049895489134e-3, -107, 0.835458175433526e-3, -103, 0.915264506779949e-3, -95, -0.104415030511972e-2, -91, -0.113251683526527e-2, -83, 0.146266783392511e-2, -79, 0.164642609009284e-2, -71, -0.193035918906158e-2, -67, -0.216097638434721e-2, -59, 0.297774878148544e-2, -55, 0.335128603848388e-2, -47, -0.421588771129264e-2, -43, -0.525875606706490e-2, -35, 0.802263941862843e-2, -31, 0.893068924044310e-2, -23, -0.143905871185661e-1, -19, -0.224806611072324e-1, -11, 0.528507659421142e-1, -7, .112312008635147, 1, .339278390151465, 5, -0.950127031051339e-1, 13, 0.763537279058393e-2, 17, 0.410562792765242e-2, 25, -0.222557543630289e-2, 29, -0.147888087544490e-2, 37, 0.904975421476911e-3, 41, 0.704655444817937e-3, 49, -0.421251892950618e-3, 53, -0.360442485452495e-3, 61, 0.282406182198476e-3, 65, 0.219042223779316e-3, 73, -0.140288880560905e-3, 77, -0.128876534777280e-3, 85, 0.111328988021832e-3 
		};

		item.ySin	= new double[]
		{ -239, -0.100344031615630e-3, -223, 0.100461948267440e-3, -215, -0.127229956065949e-3, -211, -0.136740642191319e-3, -203, 0.152611374303531e-3, -199, 0.160873994352125e-3, -191, -0.180380449832013e-3, -187, -0.191524144636479e-3, -179, 0.217022137044051e-3, -175, 0.231392047946515e-3, -167, -0.263885397315392e-3, -163, -0.282190159361645e-3, -155, 0.323649901222267e-3, -151, 0.347244638368932e-3, -143, -0.400958930212301e-3, -139, -0.431442020276589e-3, -131, 0.499997406636318e-3, -127, 0.537108825054301e-3, -119, -0.622596972675339e-3, -115, -0.680049895489134e-3, -107, 0.835458175433526e-3, -103, 0.915264506779949e-3, -95, -0.104415030511972e-2, -91, -0.113251683526527e-2, -83, 0.146266783392511e-2, -79, 0.164642609009284e-2, -71, -0.193035918906158e-2, -67, -0.216097638434721e-2, -59, 0.297774878148544e-2, -55, 0.335128603848388e-2, -47, -0.421588771129264e-2, -43, -0.525875606706490e-2, -35, 0.802263941862843e-2, -31, 0.893068924044310e-2, -23, -0.143905871185661e-1, -19, -0.224806611072324e-1, -11, 0.528507659421142e-1, -7, .112312008635147, 1, .339278390151465, 5, -0.950127031051339e-1, 13, 0.763537279058393e-2, 17, 0.410562792765242e-2, 25, -0.222557543630289e-2, 29, -0.147888087544490e-2, 37, 0.904975421476911e-3, 41, 0.704655444817937e-3, 49, -0.421251892950618e-3, 53, -0.360442485452495e-3, 61, 0.282406182198476e-3, 65, 0.219042223779316e-3, 73, -0.140288880560905e-3, 77, -0.128876534777280e-3, 85, 0.111328988021832e-3
		};

		item.yCos	= item.xSin; 
	}

	private void _AddTheFigure8()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.TheFigure8]	= item;
		item.numParticles	= 3;
		item.xSin	= new double[] 
		{
			1, 1.095877906, 5, -.02527732956, 7, -.005849442954, 11, .000420998914, 13, .0001222406676
		};

		item.xCos	= new double[]
		{ 
		};

		item.ySin	= new double[]
		{ 
			2, .3372830118, 4, .05571189024, 8, -.002990961071, 10, -.0008024248082, 14, 6775455765e-14, 16,
				2070102699e-14
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddTheSuper8()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.TheSuper8]	= item;
		item.numParticles	= 4;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			1, .7687410527, -1, .6013509217, 3, .1280152696, -3, -.1040640502, 5, -.03138811004, -5, .03751653181,
				7, -.004785319913, -7, -.01791151272, 9, .0007824107011, -9, .009632782068, 11, .0009998198411, -11, -
					.005615763317, 13, -.0004618671965, -13, .003404681238, 15, 0.6260937462e-4
		};

		item.ySin	= new double[]
		{ 
			1, .7687410527, -1, .6013509217, 3, .1280152696, -3, -.1040640502, 5, -.03138811004, -5, .03751653181,
				7, -.004785319913, -7, -.01791151272, 9, .0007824107011, -9, .009632782068, 11, .0009998198411, -11, -
					.005615763317, 13, -.0004618671965, -13, .003404681238, 15, 0.6260937462e-4
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddFourOnCircularChain()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.FourOnCircularChain]	= item;
		item.numParticles	= 4;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			1, .3642207032, -5, -.249950974, 7, .05552025098, -11, .06784515105, 13, .01070836263, -17, .02983979151,
				19, -.002330788169, -23, -.01583527736, 25, -.001432809578, -29, -.009129825595, 31, .0005273571969, -
					35, .005605425763, 37, .0003258593342, -41, .003565070837, 43, -.0001434617298
		};

		item.ySin	= new double[]
		{ 
			1, .3642207032, -5, -.249950974, 7, .05552025098, -11, .06784515105, 13, .01070836263, -17, .02983979151,
				19, -.002330788169, -23, -.01583527736, 25, -.001432809578, -29, -.009129825595, 31, .0005273571969, -
					35, .005605425763, 37, .0003258593342, -41, .003565070837, 43, -.0001434617298
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddFiveOnCircularChain()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.FiveOnCircularChain]	= item;
		item.numParticles	= 5;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			1, .3935067602, 7, .2480336273, 9, -.03926278987, 17, .008649947758, 23, -.02552061473, 31, .007594124615
		};

		item.ySin	= new double[]
		{ 
			1, .3935067602, 7, -.2480336273, 9, -.03926278987, 17, .008649947758, 23, .02552061473, 31, -.007594124615
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddNoSymmetry()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.NoSymmetry]	= item;
		item.numParticles	= 6;
		item.xSin	= new double[] 
		{
			1, -.7550946139, 2, .09566311896, 3, -.06222288074, 4, -.05692574636, 5, -.04406894338, 7, .002559046872,
				8, .001441222792, 9, .004526211957, 10, -.005332636768, 11, -.02262429005, 13, .0009855403007, 14, -
					.003086626135, 15, -.001901717624, 16, -.00570575774, 17, -.002111071339, 19, -.0006094957229, 20, -
					.0007306435328
		};

		item.xCos	= new double[]
		{ 
			1, -1.109962224, 2, .4245108806, 3, .1861867012, 4, .1077791693, 5, .04126235116, 7, .005478445066,
				8, .02511172309, 9, .01286401334, 10, .001024818894, 11, .007311536355, 13, -.008193477473, 14, .008394830071, 15, .005588307047, 16, 4150289381e-14, 17, .0004014658717, 19, .0004442403941, 20, .0002751135899
		};

		item.ySin	= new double[]
		{ 
			1, .1290761392, 2, .2795692615, 3, .03066950237, 4, -.02816043296, 5, .09038665578, 7, -.05057211516,
				8, .04130329696, 9, .02368940768, 10, .007773099334, 11, .003248568014, 13, .001485916194, 14, .001701762733, 15, .004124630872, 16, .0002364618875, 17, -.000242833944, 19, -.002959513409, 20, .002550656742
		};

		item.yCos	= new double[]
		{
			1, -.0568973801, 2, -.1306789081, 3, -.04191089847, 4, .005267005641, 5, .1393897003, 7, .009320504379,
				8, .003351111879, 9, .004080150913, 10, .01896049564, 11, .008003083991, 13, .0008604227482, 14, .001905444532, 15, -.0008602334036, 16, .0008371023946, 17, .007774299909, 19, -.001666145432, 20, .001997432777
		};
	}

	private void _AddSixOnBallerina()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.SixOnBallerina]	= item;
		item.numParticles	= 6;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			-199, 0.136931797385510e-3, -195, -0.144825111676292e-3, -191, 0.153991814380894e-3, -187, -0.162945688892412e-3, -183, 0.173918406039951e-3, -179, -0.184600259878405e-3, -175, 0.195870928210306e-3, -171, -0.211443349025266e-3, -167, 0.220966138328811e-3, -163, -0.239359480848290e-3, -159, 0.255777978585574e-3, -155, -0.275567148392276e-3, -151, 0.293956518182862e-3, -147, -0.314246585945967e-3, -143, 0.338347828670719e-3, -139, -0.366252842662505e-3, -135, 0.392909121978625e-3, -131, -0.425893331507200e-3, -127, 0.452878194525851e-3, -123, -0.490974116562459e-3, -119, 0.530925194751793e-3, -115, -0.577639091200144e-3, -111, 0.629421665560632e-3, -107, -0.685951130808046e-3, -103, 0.727105870850387e-3, -99, -0.811199807801194e-3, -95, 0.891997325256865e-3, -91, -0.969597520567600e-3, -87, 0.108239424833805e-2, -83, -0.119568158466858e-2, -79, 0.132764633662485e-2, -75, -0.147430257248271e-2, -71, 0.163452721627674e-2, -67, -0.184729467956626e-2, -63, 0.207802266140905e-2, -59, -0.236875686041711e-2, -55, 0.271535124867412e-2, -51, -0.308504595370930e-2, -47, 0.359812468602419e-2, -43, -0.425419143015691e-2, -39, 0.512300253334579e-2, -35, -0.615334422765069e-2, -31, 0.755095284825059e-2, -27, -0.956758200994697e-2, -23, 0.126610716357905e-1, -19, -0.175508069368560e-1, -15, 0.262232221668111e-1, -11, -0.430408075279342e-1, -7, 0.839101969690972e-1, -3, -.330873297808392, 1, -.754124875610954, 5, -.123244922984870, 9, 0.518036265245804e-1, 13, -0.161580627062618e-1, 17, 0.311851375885261e-2, 21, -0.104914502548375e-2, 25, 0.189332409603151e-2, 29, -0.227965957446446e-2, 33, 0.178607688053192e-2, 37, -0.114766675825761e-2, 41, 0.803465261731841e-3, 45, -0.598685094492429e-3, 49, 0.520100401317597e-3, 53, -0.490611074541034e-3, 57, 0.393263261021835e-3, 61, -0.350360128691492e-3, 65, 0.258676813842574e-3, 69, -0.245128126015620e-3, 73, 0.203185863157789e-3, 77, -0.184396052767618e-3, 81, 0.156971822922686e-3, 85, -0.132571404434116e-3, 89, 0.133504698738536e-3, 93, -0.110713797697416e-3, 97, 0.101222688805108e-3
		};

		item.ySin	= new double[]
		{ 
			-199, 0.136931797385510e-3, -195, -0.144825111676292e-3, -191, 0.153991814380894e-3, -187, -0.162945688892412e-3, -183, 0.173918406039951e-3, -179, -0.184600259878405e-3, -175, 0.195870928210306e-3, -171, -0.211443349025266e-3, -167, 0.220966138328811e-3, -163, -0.239359480848290e-3, -159, 0.255777978585574e-3, -155, -0.275567148392276e-3, -151, 0.293956518182862e-3, -147, -0.314246585945967e-3, -143, 0.338347828670719e-3, -139, -0.366252842662505e-3, -135, 0.392909121978625e-3, -131, -0.425893331507200e-3, -127, 0.452878194525851e-3, -123, -0.490974116562459e-3, -119, 0.530925194751793e-3, -115, -0.577639091200144e-3, -111, 0.629421665560632e-3, -107, -0.685951130808046e-3, -103, 0.727105870850387e-3, -99, -0.811199807801194e-3, -95, 0.891997325256865e-3, -91, -0.969597520567600e-3, -87, 0.108239424833805e-2, -83, -0.119568158466858e-2, -79, 0.132764633662485e-2, -75, -0.147430257248271e-2, -71, 0.163452721627674e-2, -67, -0.184729467956626e-2, -63, 0.207802266140905e-2, -59, -0.236875686041711e-2, -55, 0.271535124867412e-2, -51, -0.308504595370930e-2, -47, 0.359812468602419e-2, -43, -0.425419143015691e-2, -39, 0.512300253334579e-2, -35, -0.615334422765069e-2, -31, 0.755095284825059e-2, -27, -0.956758200994697e-2, -23, 0.126610716357905e-1, -19, -0.175508069368560e-1, -15, 0.262232221668111e-1, -11, -0.430408075279342e-1, -7, 0.839101969690972e-1, -3, -.330873297808392, 1, -.754124875610954, 5, -.123244922984870, 9, 0.518036265245804e-1, 13, -0.161580627062618e-1, 17, 0.311851375885261e-2, 21, -0.104914502548375e-2, 25, 0.189332409603151e-2, 29, -0.227965957446446e-2, 33, 0.178607688053192e-2, 37, -0.114766675825761e-2, 41, 0.803465261731841e-3, 45, -0.598685094492429e-3, 49, 0.520100401317597e-3, 53, -0.490611074541034e-3, 57, 0.393263261021835e-3, 61, -0.350360128691492e-3, 65, 0.258676813842574e-3, 69, -0.245128126015620e-3, 73, 0.203185863157789e-3, 77, -0.184396052767618e-3, 81, 0.156971822922686e-3, 85, -0.132571404434116e-3, 89, 0.133504698738536e-3, 93, -0.110713797697416e-3, 97, 0.101222688805108e-3
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddSixOnSquare()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.SixOnSquare]	= item;
		item.numParticles	= 6;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			1, .7669970506, -3, -.4219853175, 5, .0296658509, -7, -.04264587031, 9, .009045265376, -11, .01714290511,
				13, .001886973281, -15, .01620303782, 17, -7452482708e-14, -19, .004288198157, 21, -.0002709778138, -
					23, -.002437188935, 25, -5979004046e-14, -27, -.002906344259, 29, 743765573e-13, -31, -.0008946926102, 33, 7477956811e-14, -35, .0005667191757, 37, 2318932946e-14, -39, .0007314257655
		};

		item.ySin	= new double[]
		{ 
			1, .7669970506, -3, -.4219853175, 5, .0296658509, -7, -.04264587031, 9, .009045265376, -11, .01714290511,
				13, .001886973281, -15, .01620303782, 17, -7452482708e-14, -19, .004288198157, 21, -.0002709778138, -
					23, -.002437188935, 25, -5979004046e-14, -27, -.002906344259, 29, 743765573e-13, -31, -.0008946926102, 33, 7477956811e-14, -35, .0005667191757, 37, 2318932946e-14, -39, .0007314257655
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddSixOnTensorSign()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.SixOnTensorSign]	= item;
		item.numParticles	= 6;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			-199, 0.293402e-3, -191, -0.326862e-3, -187, -0.345213e-3, -179, 0.385968e-3, -175, 0.409220e-3, -167, -0.459647e-3, -163, -0.487468e-3, -155, 0.549302e-3, -151, 0.584835e-3, -143, -0.663641e-3, -139, -0.706653e-3, -131, 0.806547e-3, -127, 0.864159e-3, -119, -0.990248e-3, -115, -0.106603e-2, -107, 0.123518e-2, -103, 0.133211e-2, -95, -0.156037e-2, -91, -0.170113e-2, -83, 0.201115e-2, -79, 0.221318e-2, -71, -0.268116e-2, -67, -0.296675e-2, -59, 0.369100e-2, -55, 0.414829e-2, -51, 0.123709e-4, -47, -0.539756e-2, -43, -0.617526e-2, -39, -0.605640e-4, -35, 0.855200e-2, -31, 0.102703e-1, -27, 0.335533e-3, -23, -0.161830e-1, -19, -0.209781e-1, -15, -0.339013e-2, -11, 0.463484e-1, -7, 0.750271e-1, -3, .434062, 1, .435459, 5, -.195700, 9, 0.160010e-1, 13, 0.978053e-2, 17, 0.133667e-1, 21, -0.161931e-2, 25, -0.363282e-2, 29, -0.375335e-2, 33, 0.266641e-3, 37, 0.177922e-2, 41, 0.166671e-2, 45, -0.653055e-4, 49, -0.101653e-2, 53, -0.899921e-3, 57, 0.165922e-4, 61, 0.627230e-3, 65, 0.552914e-3, 73, -0.408271e-3, 77, -0.361715e-3, 85, 0.279040e-3, 89, 0.247079e-3, 97, -0.199536e-3, 101, -0.176607e-3, 109, 0.141601e-3, 113, 0.127860e-3, 121, -0.104053e-3, 125, -0.946220e-4, 133, 0.785249e-4, 137, 0.705554e-4, 145, -0.592823e-4, 149, -0.523678e-4, 157, 0.426402e-4, 161, 0.400625e-4, 169, -0.328270e-4, 173, -0.301186e-4, 181, 0.246928e-4, 185, 0.226796e-4, 193, -0.189678e-4, 197, -0.182006e-4
		};

		item.ySin	= new double[]
		{ 
			-199, 0.293402e-3, -191, -0.326862e-3, -187, -0.345213e-3, -179, 0.385968e-3, -175, 0.409220e-3, -167, -0.459647e-3, -163, -0.487468e-3, -155, 0.549302e-3, -151, 0.584835e-3, -143, -0.663641e-3, -139, -0.706653e-3, -131, 0.806547e-3, -127, 0.864159e-3, -119, -0.990248e-3, -115, -0.106603e-2, -107, 0.123518e-2, -103, 0.133211e-2, -95, -0.156037e-2, -91, -0.170113e-2, -83, 0.201115e-2, -79, 0.221318e-2, -71, -0.268116e-2, -67, -0.296675e-2, -59, 0.369100e-2, -55, 0.414829e-2, -51, 0.123709e-4, -47, -0.539756e-2, -43, -0.617526e-2, -39, -0.605640e-4, -35, 0.855200e-2, -31, 0.102703e-1, -27, 0.335533e-3, -23, -0.161830e-1, -19, -0.209781e-1, -15, -0.339013e-2, -11, 0.463484e-1, -7, 0.750271e-1, -3, .434062, 1, .435459, 5, -.195700, 9, 0.160010e-1, 13, 0.978053e-2, 17, 0.133667e-1, 21, -0.161931e-2, 25, -0.363282e-2, 29, -0.375335e-2, 33, 0.266641e-3, 37, 0.177922e-2, 41, 0.166671e-2, 45, -0.653055e-4, 49, -0.101653e-2, 53, -0.899921e-3, 57, 0.165922e-4, 61, 0.627230e-3, 65, 0.552914e-3, 73, -0.408271e-3, 77, -0.361715e-3, 85, 0.279040e-3, 89, 0.247079e-3, 97, -0.199536e-3, 101, -0.176607e-3, 109, 0.141601e-3, 113, 0.127860e-3, 121, -0.104053e-3, 125, -0.946220e-4, 133, 0.785249e-4, 137, 0.705554e-4, 145, -0.592823e-4, 149, -0.523678e-4, 157, 0.426402e-4, 161, 0.400625e-4, 169, -0.328270e-4, 173, -0.301186e-4, 181, 0.246928e-4, 185, 0.226796e-4, 193, -0.189678e-4, 197, -0.182006e-4
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddSixOnPropellor()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.SixOnPropellor]	= item;
		item.numParticles	= 6;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			-199, 0.364184087704319e-3, -191, -0.400540430733269e-3, -187, -0.420268976667089e-3, -179, 0.463739065422134e-3, -175, 0.487544133125714e-3, -167, -0.540058288427605e-3, -163, -0.568958919108966e-3, -155, 0.633108390701264e-3, -151, 0.668649802856038e-3, -143, -0.748456481515465e-3, -139, -0.793473476916412e-3, -131, 0.897655070660553e-3, -127, 0.953651665701352e-3, -119, -0.106765798816072e-2, -115, -0.114943008081818e-2, -107, 0.131089856355032e-2, -103, 0.140959326368906e-2, -95, -0.162746388493335e-2, -91, -0.177177795253364e-2, -83, 0.207366597272140e-2, -79, 0.227625079135340e-2, -71, -0.273187786918162e-2, -67, -0.301072352284767e-2, -59, 0.373298704725538e-2, -55, 0.415731192707663e-2, -47, -0.537476101035058e-2, -43, -0.620438566445316e-2, -35, 0.860478556601385e-2, -31, 0.106091033937610e-1, -23, -0.170941572611795e-1, -19, -0.238119360656024e-1, -15, -0.235697785438194e-3, -11, 0.581543365340273e-1, -7, .142331574155370, -3, -0.534187462030905e-1, 1, .582142960070040, 5, -.222512412803919, 9, 0.250949436269192e-2, 13, 0.256756136590689e-1, 17, 0.179628691719971e-1, 21, 0.480427694822675e-3, 25, -0.712460536504562e-2, 29, -0.550769397025168e-2, 37, 0.312397342257969e-2, 41, 0.248833112516326e-2, 49, -0.166762252950283e-2, 53, -0.135070128498910e-2, 61, 0.980093440537582e-3, 65, 0.820525602729297e-3, 73, -0.622667360430860e-3, 77, -0.539935487246704e-3, 85, 0.427736240989302e-3, 89, 0.378427139953589e-3, 97, -0.311472665253985e-3, 101, -0.284644029877735e-3, 109, 0.227479224379448e-3, 113, 0.198186305928359e-3, 121, -0.173163276341953e-3, 125, -0.156270600898925e-3, 133, 0.127403773401737e-3, 137, 0.115789793645839e-3
		};

		item.ySin	= new double[]
		{ 
			-199, 0.364184087704319e-3, -191, -0.400540430733269e-3, -187, -0.420268976667089e-3, -179, 0.463739065422134e-3, -175, 0.487544133125714e-3, -167, -0.540058288427605e-3, -163, -0.568958919108966e-3, -155, 0.633108390701264e-3, -151, 0.668649802856038e-3, -143, -0.748456481515465e-3, -139, -0.793473476916412e-3, -131, 0.897655070660553e-3, -127, 0.953651665701352e-3, -119, -0.106765798816072e-2, -115, -0.114943008081818e-2, -107, 0.131089856355032e-2, -103, 0.140959326368906e-2, -95, -0.162746388493335e-2, -91, -0.177177795253364e-2, -83, 0.207366597272140e-2, -79, 0.227625079135340e-2, -71, -0.273187786918162e-2, -67, -0.301072352284767e-2, -59, 0.373298704725538e-2, -55, 0.415731192707663e-2, -47, -0.537476101035058e-2, -43, -0.620438566445316e-2, -35, 0.860478556601385e-2, -31, 0.106091033937610e-1, -23, -0.170941572611795e-1, -19, -0.238119360656024e-1, -15, -0.235697785438194e-3, -11, 0.581543365340273e-1, -7, .142331574155370, -3, -0.534187462030905e-1, 1, .582142960070040, 5, -.222512412803919, 9, 0.250949436269192e-2, 13, 0.256756136590689e-1, 17, 0.179628691719971e-1, 21, 0.480427694822675e-3, 25, -0.712460536504562e-2, 29, -0.550769397025168e-2, 37, 0.312397342257969e-2, 41, 0.248833112516326e-2, 49, -0.166762252950283e-2, 53, -0.135070128498910e-2, 61, 0.980093440537582e-3, 65, 0.820525602729297e-3, 73, -0.622667360430860e-3, 77, -0.539935487246704e-3, 85, 0.427736240989302e-3, 89, 0.378427139953589e-3, 97, -0.311472665253985e-3, 101, -0.284644029877735e-3, 109, 0.227479224379448e-3, 113, 0.198186305928359e-3, 121, -0.173163276341953e-3, 125, -0.156270600898925e-3, 133, 0.127403773401737e-3, 137, 0.115789793645839e-3
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddSixOn5Daisy()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.SixOn5Daisy]	= item;
		item.numParticles	= 6;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			1, .6932058558, -4, -.306124454, -9, -.08357786498, 11, .00491379187, -14, -.03176112544, 16, .004737161529, - 19, -.01006167085, 21, .003074044286, 26, .00142750095, -29, .004146451167, 31, .000486885508, -34,
				.005002080697, -39, .00415766228, 41, -.0002241949892, -44, .002658237721
		};

		item.ySin	= new double[]
		{ 
			1, .6932058558, -4, -.306124454, -9, -.08357786498, 11, .00491379187, -14, -.03176112544, 16, .004737161529, - 19, -.01006167085, 21, .003074044286, 26, .00142750095, -29, .004146451167, 31, .000486885508, -34,
				.005002080697, -39, .00415766228, 41, -.0002241949892, -44, .002658237721
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddSixOnPentagram()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.SixOnPentagram]	= item;
		item.numParticles	= 6;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			2, .4468616777, -3, -.4771728097, 7, -.007365138055, -8, -.04184471223, -13, -.008354164386, 17,
				.0008276011763, 22, .0003099240031, -23, .00196338389, 27, .0002204659775, -28, .001874481252, 32,
				7995119096e-14, -33, .00125671506
		};

		item.ySin	= new double[]
		{ 
			2, .4468616777, -3, -.4771728097, 7, -.007365138055, -8, -.04184471223, -13, -.008354164386, 17,
				.0008276011763, 22, .0003099240031, -23, .00196338389, 27, .0002204659775, -28, .001874481252, 32,
				7995119096e-14, -33, .00125671506
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddSixOn5PetalFlower()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.SixOn5PetalFlower]	= item;
		item.numParticles	= 6;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			2, .666017812, -3, .01903670154, 7, -.1706294667, -8, -.001754286285, -13, -.0002563251066, 17, - .004544328892
		};

		item.ySin	= new double[]
		{ 
			2, .666017812, -3, .01903670154, 7, -.1706294667, -8, -.001754286285, -13, -.0002563251066, 17, - .004544328892
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddSixOnHeptagram()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.SixOnHeptagram]	= item;
		item.numParticles	= 6;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			2, .6718030063, -5, .2117062813, 9, -.004498968884, -12, 0, 16, -.0006728660854, -19, .000513212546, 23, .0001515002178
		};

		item.ySin	= new double[]
		{ 
			2, .6718030063, -5, .2117062813, 9, -.004498968884, -12, 0, 16, -.0006728660854, -19, .000513212546, 23, .0001515002178
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddSixOn7PetalFlower()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.SixOn7PetalFlower]	= item;
		item.numParticles	= 6;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			2, .3389259366, -5, .3604619342, 9, -.04442049316, -12, 0, 16, .0140692024, -19, -.02133896304,
				23, -.003686948927, -26, .011287677, 30, 0, -33, .0002029186983, 37, .0008789427699, -40, -.003981710049,
				44, -.0006116942612, -47, .002506622731
		};

		item.ySin	= new double[]
		{ 
			2, .3389259366, -5, .3604619342, 9, -.04442049316, -12, 0, 16, .0140692024, -19, -.02133896304,
				23, -.003686948927, -26, .011287677, 30, 0, -33, .0002029186983, 37, .0008789427699, -40, -.003981710049,
				44, -.0006116942612, -47, .002506622731
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddSixOnAtom()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.SixOnAtom]	= item;
		item.numParticles	= 6;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			3, .252731354, -4, .4422453614, 10, .006512223797, -11, -.01630697113, 17, .0005509055556, -18, 0,
				24, 0, -25, .001871253435, 31, 4278762892e-14, -32, -.001405577419, 38, -39033216e-12, -39, .0007443270428, 45, 1017688347e-14, -46, -.0003142405462
		};

		item.ySin	= new double[]
		{ 
			3, .252731354, -4, .4422453614, 10, .006512223797, -11, -.01630697113, 17, .0005509055556, -18, 0, 24, 0, -25, .001871253435, 31, 4278762892e-14, -32, -.001405577419, 38, -39033216e-12, -39, .0007443270428,
				45, 1017688347e-14, -46, -.0003142405462
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddSevenOnButterfly()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.SevenOnButterfly]	= item;
		item.numParticles	= 7;
		item.xSin	= new double[] 
		{
			2, .6698, 4, -.061516, 6, -.030726, 8, .013552
		};

		item.xCos	= new double[]
		{ 
			2, .33346, 4, -.17573, 6, .0045556, 8, -.016113
		};

		item.ySin	= new double[]
		{ 
			1, .71758, 3, .42748, 5, .093694
		};

		item.yCos	= new double[]
		{
			1, -.41438, 3, .21726, 5, -.080218
		};
	}

	private void _AddSevenOnFigure8()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.SevenOnFigure8]	= item;
		item.numParticles	= 7;
		item.xSin	= new double[] 
		{
			1, 1.654924655, 3, -.0646563788, 5, .009983641036, 9, -.002227071912, 11, -.001801662511, 13, -.001070749384,
				15, -.000506342208, 17, -.0001997124901
		};

		item.xCos	= new double[]
		{ 
		};

		item.ySin	= new double[]
		{ 
			2, .5909346805, 4, .03021664819, 6, .03337493534, 8, .008137225851, 10, .002881644999, 12, .0007370559483,
				16, -.0001650419513, 18, -.0001476340004
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddBowtie()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.Bowtie]	= item;
		item.numParticles	= 7;
		item.xSin	= new double[] 
		{
			1, 1.091365422, 3, .4414472756, 5, -.00365292443, 9, -.02548081852, 11, -.02138477718, 13, .004599397177,
                15, -.003243642377, 17, .007646278321
		};

		item.xCos	= new double[]
		{ 
		};

		item.ySin	= new double[]
		{ 
			2, .6905451088, 4, -.1729103958, 6, .03337493534, 8, -.010122125371, 10, .01425627099, 12, .01933961549,
				16, .005359359294, 18, -.007081545609
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddMoustache()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.Moustache]	= item;
		item.numParticles	= 8;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			1, .5855002517, -2, -.6975795551, 4, -.2107867182, -5, -.1103782792, 7, .0299848468, 10, .02381910033, -
				11, .01161307123, 13, -.01728777475, -14, .003591482109, -17, .001786931865, 19, .00676758542, -20,
				.00151623536, 22, -.003455058244, -23, .0002430321881, 25, -.00128197031, -26, -4663491809e-14, 28,
				.002329249083, -29, .0001553222937
		};

		item.ySin	= new double[]
		{ 
			1, .5855002517, -2, -.6975795551, 4, -.2107867182, -5, -.1103782792, 7, .0299848468, 10, .02381910033, -
				11, .01161307123, 13, -.01728777475, -14, .003591482109, -17, .001786931865, 19, .00676758542, -20,
				.00151623536, 22, -.003455058244, -23, .0002430321881, 25, -.00128197031, -26, -4663491809e-14, 28,
				.002329249083, -29, .0001553222937
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddEightOn3PetalFlower()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.EightOn3PetalFlower]	= item;
		item.numParticles	= 8;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			1, .7656403736, -2, -.7386086907, 4, .07116602246, -5, .01543443541, 7, .0183934114, 10, .005789150532, - 11, .004908743265, 13, .001346512866, -14, .004625955455, -17, .001556790043, 19, -.000347300935, - 20, -7566709546e-14, 22, -.0003311623195, -23, -.0004827558138, 25, -.0002368609203, -26, -.0003673171202, 28, -.0001437820548, -29, -.0001447969848
		};

		item.ySin	= new double[]
		{ 
			1, .7656403736, -2, -.7386086907, 4, .07116602246, -5, .01543443541, 7, .0183934114, 10, .005789150532, - 11, .004908743265, 13, .001346512866, -14, .004625955455, -17, .001556790043, 19, -.000347300935, - 20, -7566709546e-14, 22, -.0003311623195, -23, -.0004827558138, 25, -.0002368609203, -26, -.0003673171202, 28, -.0001437820548, -29, -.0001447969848
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddEightOnClover()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.EightOnClover]	= item;
		item.numParticles	= 8;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			1, .5954570266, -2, -.1073055361, 4, -.4363298113, -5, -.009065054033, 7, -.1024344433, 10, -.01624485444, -
				11, -.0004165597797, 13, .0001680529934, -14, .0009220846361, -17, .001353047496, 19, .001022304836, -
				20, .0008352720423, 22, .003905679087, -23, .0004523099612, 25, .005448226233, -26, .0002555059424,
				28, .004648564484
		};

		item.ySin	= new double[]
		{ 
			1, .5954570266, -2, -.1073055361, 4, -.4363298113, -5, -.009065054033, 7, -.1024344433, 10, -.01624485444, -
				11, -.0004165597797, 13, .0001680529934, -14, .0009220846361, -17, .001353047496, 19, .001022304836, -
				20, .0008352720423, 22, .003905679087, -23, .0004523099612, 25, .005448226233, -26, .0002555059424,
				28, .004648564484
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddEightOnTrefoil()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.EightOnTrefoil]	= item;
		item.numParticles	= 8;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			-1, .433097123, 2, -.838601555, -4, -.01611161518, 5, -.01460819706, -7, -.001665826568, -10, -.0005150074656, 11, .002845040152, -13, -.000139643963, 14, .002961094992, 17, .001611629134
		};

		item.ySin	= new double[]
		{ 
			-1, .433097123, 2, -.838601555, -4, -.01611161518, 5, -.01460819706, -7, -.001665826568, -10, -.0005150074656, 11, .002845040152, -13, -.000139643963, 14, .002961094992, 17, .001611629134
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddEightOn92Enneagram()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.EightOn92Enneagram]	= item;
		item.numParticles	= 8;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			2, .7903901078, -7, .1700926013, 11, -.0008684892342, 20, -.0005169844835, -25, .0001199631619,
				29, 3494606269e-14, -34, -1885282369e-15, 38, 1200959094e-14, -43, -1342914084e-15, 47, -
					3165786479e-15, -52, 6.737328007e-8, -61, 5.131421153e-8, 65, 1.506910009e-7
		};

		item.ySin	= new double[]
		{ 
			2, .7903901078, -7, .1700926013, 11, -.0008684892342, 20, -.0005169844835, -25, .0001199631619,
				29, 3494606269e-14, -34, -1885282369e-15, 38, 1200959094e-14, -43, -1342914084e-15, 47, -
					3165786479e-15, -52, 6.737328007e-8, -61, 5.131421153e-8, 65, 1.506910009e-7
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddEightOn94Enneagram()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.EightOn94Enneagram]	= item;
		item.numParticles	= 8;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			4, .423108347, -5, .3195216723, 13, -.02065156506, -14, .002146368791, 22, .003406550808, -23, -.0010513364,
				31, -.0007181003319, -41, 3152493699e-14, 49, .0001843985573, -50, -1248100811e-14, 58, -.000180792826, -
					59, 1731964787e-14, 67, .0001280941398
		};

		item.ySin	= new double[]
		{ 
			4, .423108347, -5, .3195216723, 13, -.02065156506, -14, .002146368791, 22, .003406550808, -23, -.0010513364,
				31, -.0007181003319, -41, 3152493699e-14, 49, .0001843985573, -50, -1248100811e-14, 58, -.000180792826, -
					59, 1731964787e-14, 67, .0001280941398
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddNineOnPieceOfGinger()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.NineOnPieceOfGinger]	= item;
		item.numParticles	= 9;
		item.xSin	= new double[] 
		{
			1, 1.1283, 2, -.31224, 3, .41648, 4, .14838, 5, .073336, 6, .040019, 7, .010128, 8, .0024523, 10,
				.0092424, 11, -.0013352, 12, .0010912
		};

		item.xCos	= new double[]
		{ 
		};

		item.ySin	= new double[]
		{ 
			1, -.60598, 2, .64057, 3, .30997, 4, -.057501, 5, -.094251, 6, -.034107, 7, -.021146, 8, .021866,
				10, .0028073, 11, -.015569, 12, -.0028514
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddNineOnBear()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.NineOnBear]	= item;
		item.numParticles	= 9;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			1, .5798048546, -3, .07804870416, 5, -.3434430105, -7, .1083329957, -11, .06081926513, 13, .01984584357, -
				15, -.0008731944407, 17, .002928936536, -19, -.02816572417, 21, .003716565953, -23, -.02116817724,
				25, -.0008110307449, 29, -.000351131589, -31, .013357463, 33, .0009533834058, -35, .01078265244, 37,
				9248052645e-14, -39, -755599745e-14, 41, 7565047178e-14, -43, -.007238068821, -47, -.005993109494,
				49, -.0001679080273
		};

		item.ySin	= item.xCos;
		item.yCos	= item.xSin;
	}

	private void _AddNineOnPropellor()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.NineOnPropellor]	= item;
		item.numParticles	= 9;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{ 
			-199, 0.439198298776640e-3, -191, -0.479053139804838e-3, -187, -0.501474648289755e-3, -179, 0.548906065667384e-3, -175, 0.575490330350179e-3, -167, -0.632699726845985e-3, -163, -0.663121490127849e-3, -155, 0.732845044766699e-3, -151, 0.767620088901176e-3, -143, -0.852224832393644e-3, -139, -0.895528410313613e-3, -131, 0.996733460276920e-3, -127, 0.105796527282323e-2, -119, -0.118883127654377e-2, -115, -0.129034563147600e-2, -107, 0.145163651479652e-2, -103, 0.157968031296653e-2, -95, -0.181866101025487e-2, -91, -0.193728260842128e-2, -83, 0.228391515867130e-2, -79, 0.237367626244662e-2, -71, -0.285582707062718e-2, -67, -0.300145183925618e-2, -59, 0.361294591393013e-2, -55, 0.427015972760171e-2, -51, 0.454446492018515e-3, -47, -0.526439607423174e-2, -43, -0.716942340322745e-2, -39, -0.105780196410263e-2, -35, 0.975923841680111e-2, -31, 0.134572645213105e-1, -23, -0.230275713161774e-1, -19, -0.276328834486015e-1, -15, 0.112870027076484e-1, -11, 0.781746582062513e-1, -7, .101114298595888, -3, -.150005913382387, 1, .624524048964416, 5, -.237283209478887, 13, 0.444673299386134e-1, 17, 0.201795966329068e-1, 21, -0.271102600388766e-2, 25, -0.989482466805821e-2, 29, -0.672318406029566e-2, 37, 0.407841005285287e-2, 41, 0.321675443844163e-2, 49, -0.209338154887149e-2, 53, -0.175006679298965e-2, 61, 0.126638228849206e-2, 65, 0.106118514591645e-2, 73, -0.815010354503891e-3, 77, -0.713357812484111e-3, 85, 0.553906539751916e-3, 89, 0.503905712598229e-3, 97, -0.401177560946991e-3, 101, -0.360435420367317e-3, 109, 0.294784102603454e-3, 113, 0.266317574947463e-3, 121, -0.217310360496458e-3, 125, -0.199439782378490e-3, 133, 0.167015740489173e-3, 137, 0.153712792552211e-3, 145, -0.129546357956575e-3, 149, -0.119252282057890e-3, 157, 0.101425209074569e-3
		};

		item.ySin	= item.xCos;
		item.yCos	= item.xSin;
	}

	private void _AddTenOnPentagram()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.TenOnPentagram]	= item;
		item.numParticles	= 10;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{
			2, .71136, 3, -.48089, 7, .0655, 8, .052856, 12, .013293, 13, .025317, 17, .0012211, 18, -.0090739, 22, 40296e-8, 23, -.0068906, 27, 73001e-8, 28, .0029054
		};

		item.ySin	= new double[]
		{
			2, .71136, 3, .48089, 7, .0655, 8, -.052856, 12, .013293, 13, -.025317, 17, .0012211, 18, .0090739, 22, 40296e-8, 23, .0068906, 27, 73001e-8, 28, -.0029054
		};

		item.yCos	= new double[]
		{
		};
	}

	private void _AddTenOnOctagram()
	{
		var item	= new NBodyConfigItem();
		_items[(int)NBodyType.TenOnOctagram]	= item;
		item.numParticles	= 10;
		item.xSin	= new double[] 
		{
		};

		item.xCos	= new double[]
		{
			3, .6241426424, -5, .2843939666, 11, -.01448718416, -13, -.01115310411, 19, .0003101738557, -21, -
				.01001352249, 27, .0009369441432, -29, .003534199437
		};

		item.ySin	= item.xCos;
		item.yCos	= item.xSin;
	}

	public NBodyConfigItem GetNBodyConfigItem(NBodyType type)
	{
		var index	= (int)type;
		if(index >= 0 && index < _items.Length)
		{
			return _items[index];
		}

		return null;
	}

	public static readonly NBodyLoader	Instance	= new NBodyLoader();
	private NBodyConfigItem[]	_items	= new NBodyConfigItem[(int)NBodyType.Count];
}
