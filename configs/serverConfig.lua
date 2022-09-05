Server = {
	ready = false,
}

Cyr = {}

Cyr.Utils = {
	ped = 0,
	pedCoords = vector3(0,0,0),
	aiModel = joaat("mp_m_bogdangoon")
}

Cyr.Zones = {
	cayo_mansion = {
		name = "cayo_mansion",
        isZone = true,
        zMax = 60.0,
        zMin = -20.0,
        coords = {
			vector3(5097.4838867188, -5746.33984375, 16.560176849365),
			vector3(5072.3046875, -5725.6352539063, 15.772180557251),
			vector3(5077.5473632813, -5718.1669921875, 15.93218421936),
			vector3(5058.8662109375, -5702.4741210938, 16.272184371948),
			vector3(5052.7333984375, -5693.3251953125, 16.612192153931),
			vector3(5045.5678710938, -5697.8071289063, 17.052202224731),
			vector3(5020.4677734375, -5675.5595703125, 20.272275924683),
			vector3(4991.6489257813, -5707.8999023438, 19.992244720459),
			vector3(4987.8813476563, -5704.5830078125, 19.992244720459),
			vector3(4974.6025390625, -5719.4760742188, 19.992244720459),
			vector3(4953.8510742188, -5748.5927734375, 20.034812927246),
			vector3(4959.4096679688, -5760.4711914063, 20.414821624756),
			vector3(4961.0107421875, -5783.3090820313, 21.234840393066),
			vector3(4957.4067382813, -5791.2504882813, 21.234840393066),
			vector3(4997.5463867188, -5810.564453125, 21.234840393066),
			vector3(4999.7436523438, -5804.96875, 21.234840393066),
			vector3(5019.7749023438, -5820.7778320313, 18.31477355957),
			vector3(5062.2114257813, -5794.7905273438, 17.374778747559),
			vector3(5080.6318359375, -5771.1186523438, 12.774750709534)
        },
        zoneMap = {
          inEvent = "plouffe_cayorobbery:inMansion",
          outEvent = "plouffe_cayorobbery:exitMansion"
        }
    }
}

Cyr.HiddenZones = {
	cyr_hidden_key_1 = {
		name = "cyr_hidden_key_1",
        isZone = true,
		label = "Chercher",
		distance = 1.0,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_1"},
        coords = vector3(5011.00390625, -5797.8022460938, 17.536151885986),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_2 = {
		name = "cyr_hidden_key_2",
        isZone = true,
		label = "Chercher",
		distance = 1.5,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_2"},
        coords = vector3(4994.3330078125, -5771.2294921875, 16.278356552124),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_3 = {
		name = "cyr_hidden_key_3",
        isZone = true,
		label = "Chercher",
		distance = 1.5,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_3"},
        coords = vector3(4999.3247070313, -5774.3344726563, 16.278356552124),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_4 = {
		name = "cyr_hidden_key_4",
        isZone = true,
		label = "Chercher",
		distance = 1.5,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_4"},
        coords = vector3(4968.009765625, -5751.8608398438, 20.038288116455),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_5 = {
		name = "cyr_hidden_key_5",
        isZone = true,
		label = "Chercher",
		distance = 1.5,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_5"},
        coords = vector3(4987.1030273438, -5757.6489257813, 20.038288116455),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_6 = {
		name = "cyr_hidden_key_6",
        isZone = true,
		label = "Chercher",
		distance = 1.0,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_6"},
        coords = vector3(5032.4506835938, -5769.9892578125, 15.69636631012),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_7 = {
		name = "cyr_hidden_key_7",
        isZone = true,
		label = "Chercher",
		distance = 1.0,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_7"},
        coords = vector3(5041.8979492188, -5784.4282226563, 15.715221405029),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_8 = {
		name = "cyr_hidden_key_8",
        isZone = true,
		label = "Chercher",
		distance = 1.0,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_8"},
        coords = vector3(5029.8247070313, -5801.1547851563, 17.477693557739),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_9 = {
		name = "cyr_hidden_key_9",
        isZone = true,
		label = "Chercher",
		distance = 1.0,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_9"},
        coords = vector3(5049.5766601563, -5785.205078125, 15.727548599243),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_10 = {
		name = "cyr_hidden_key_10",
        isZone = true,
		label = "Chercher",
		distance = 1.5,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_10"},
        coords = vector3(5058.3793945313, -5778.3686523438, 16.277030944824),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_11 = {
		name = "cyr_hidden_key_11",
        isZone = true,
		label = "Chercher",
		distance = 1.5,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_11"},
        coords = vector3(5053.3974609375, -5770.5122070313, 16.277030944824),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_12 = {
		name = "cyr_hidden_key_12",
        isZone = true,
		label = "Chercher",
		distance = 1.0,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_12"},
        coords = vector3(5068.1943359375, -5780.3125, 16.277223587036),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_13 = {
		name = "cyr_hidden_key_13",
        isZone = true,
		label = "Chercher",
		distance = 1.0,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_13"},
        coords = vector3(5067.1176757813, -5761.6181640625, 15.722861289978),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_14 = {
		name = "cyr_hidden_key_14",
        isZone = true,
		label = "Chercher",
		distance = 1.0,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_14"},
        coords = vector3(5054.80078125, -5755.4077148438, 15.722861289978),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_15 = {
		name = "cyr_hidden_key_15",
        isZone = true,
		label = "Chercher",
		distance = 1.5,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_15"},
        coords = vector3(5073.1547851563, -5751.1762695313, 15.677449226379),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_16 = {
		name = "cyr_hidden_key_16",
        isZone = true,
		label = "Chercher",
		distance = 1.0,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_16"},
        coords = vector3(5063.0615234375, -5739.9584960938, 15.877458572388),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_17 = {
		name = "cyr_hidden_key_17",
        isZone = true,
		label = "Chercher",
		distance = 1.0,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_17"},
        coords = vector3(5047.5546875, -5719.8984375, 15.69735622406),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_18 = {
		name = "cyr_hidden_key_18",
        isZone = true,
		label = "Chercher",
		distance = 1.0,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_18"},
        coords = vector3(5032.90234375, -5730.3950195313, 17.642246246338),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_19 = {
		name = "cyr_hidden_key_19",
        isZone = true,
		label = "Chercher",
		distance = 1.0,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_19"},
        coords = vector3(5026.142578125, -5701.0483398438, 19.423721313477),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_20 = {
		name = "cyr_hidden_key_20",
        isZone = true,
		label = "Chercher",
		distance = 1.0,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_20"},
        coords = vector3(4984.439453125, -5711.0615234375, 25.235546112061),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_21 = {
		name = "cyr_hidden_key_21",
        isZone = true,
		label = "Chercher",
		distance = 1.0,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_21"},
        coords = vector3(4959.1220703125, -5790.5708007813, 26.271314620972),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_22 = {
		name = "cyr_hidden_key_22",
        isZone = true,
		label = "Chercher",
		distance = 1.0,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_22"},
        coords = vector3(5076.5703125, -5732.0712890625, 15.877449035645),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_23 = {
		name = "cyr_hidden_key_23",
        isZone = true,
		label = "Chercher",
		distance = 1.0,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_23"},
        coords = vector3(5071.98828125, -5721.2231445313, 14.05740737915),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_24 = {
		name = "cyr_hidden_key_24",
        isZone = true,
		label = "Chercher",
		distance = 1.3,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_24"},
        coords = vector3(5047.6953125, -5713.283203125, 14.877426147461),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },

	cyr_hidden_key_25 = {
		name = "cyr_hidden_key_25",
        isZone = true,
		label = "Chercher",
		distance = 1.5,
		params = {fnc = "SearchKey", zone = "cyr_hidden_key_25"},
        coords = vector3(5041.3276367188, -5703.3095703125, 14.877426147461),
		keyMap = {
			key = "E",
			event = "plouffe_cayorobbery:onZone"
		}
    },
}

Cyr.Art = {
	models = {
		"h4_prop_h4_painting_01a",
		"h4_prop_h4_painting_01b",
		"h4_prop_h4_painting_01c",
		"h4_prop_h4_painting_01d",
		"h4_prop_h4_painting_01e",
		"h4_prop_h4_painting_01f",
		"h4_prop_h4_painting_01g",
		"h4_prop_h4_painting_01h",
		"ch_prop_vault_painting_01a",
		"ch_prop_vault_painting_01b",
		"ch_prop_vault_painting_01c",
		"ch_prop_vault_painting_01d",
		"ch_prop_vault_painting_01e",
		"ch_prop_vault_painting_01f",
		"ch_prop_vault_painting_01g",
		"ch_prop_vault_painting_01h",
		"ch_prop_vault_painting_01i",
		"ch_prop_vault_painting_01j"
	},

	frames = {
		h4_int_04_painting001 = {offset = vector3(0.06, -0.45, -1.8)},
		h4_prop_office_painting_01b = {offset = vector3(0.0, -0.43, -1.165)}
	},

	coords = {
		house_1 = {
			frameCoords = vector3(5008.6810156251, -5783.2755273439, 17.848467636108),
			frameRotation = vector3(0.0, -0.0, 33.6),
			paintingCoords = vector3(5008.7548828125, -5783.1782226563, 17.948467254639),
			paintingRotation = vector3(0.0, 0.0, 33.599998474121),
			frameModel = "h4_int_04_painting001",
			version = 2
		},

		house_2 = {
			frameCoords = vector3(5027.124140625, -5738.8955664063, 17.887363128662),
			frameRotation = vector3(0.0, -0.0, -131.66),
			paintingCoords = vector3(5027.0776367188, -5739.0078125, 17.987361907959),
			paintingRotation = vector3(0.0, -0.0, -131.65997314453),
			frameModel = "h4_int_04_painting001",
			version = 2
		},

		house_3 = {
			frameCoords = vector3(5081.1920898438, -5758.676171875, 15.84894203186),
			frameRotation = vector3(0.0, -0.0, -128.08),
			paintingCoords = vector3(5081.15234375, -5758.7915039063, 15.948943138123),
			paintingRotation = vector3(0.0, -0.0, -128.07997131348),
			frameModel = "h4_int_04_painting001",
			version = 2
		},

		office_1 = {
			frameCoords = vector3(5004.8097656251, -5755.5526562499, 28.920558547974),
			frameRotation = vector3(0.0, -0.0, 147.56),
			paintingCoords = vector3(5004.8095703125, -5755.552734375, 29.000558853149),
			paintingRotation = vector3(0.0, -0.0, 147.55996704102),
			frameModel = "h4_prop_office_painting_01b",
			version = 2
		},

		office_2 = {
			frameCoords = vector3(5014.61875, -5751.0473632812, 28.925552825928),
			frameRotation = vector3(0.0, -0.0, -31.26),
			paintingCoords = vector3(5014.6186523438, -5751.0473632813, 28.995552062988),
			paintingRotation = vector3(0.0, 0.0, -31.259994506836),
			frameModel = "h4_prop_office_painting_01b",
			version = 2
		},

		basement_1 = {
			frameCoords = vector3(4997.0841210937, -5745.4955664063, 14.950761566162),
			frameRotation = vector3(0.0, -0.0, 58.300000000001),
			paintingCoords = vector3(4997.083984375, -5745.4956054688, 15.005761146545),
			paintingRotation = vector3(0.0, 0.0, 58.299999237061),
			frameModel = "h4_prop_office_painting_01b",
			version = 2
		},

		basement_2 = {
			frameCoords = vector3(4995.5299414063, -5748.0055273437, 14.950263473511),
			frameRotation = vector3(0.0, -0.0, 56.930000000001),
			paintingCoords = vector3(4995.5297851563, -5748.0053710938, 15.003263473511),
			paintingRotation = vector3(0.0, 0.0, 56.929992675781),
			frameModel = "h4_prop_office_painting_01b",
			version = 2
		}
	}
}

Cyr.Diamond = {
	displayCoords = vector3(5006.3122265625, -5756.8393554688, 15.521945571899),
	displayRotation = vector3(0.0, -0.0, 0.0),
	diamondCoords = vector3(5006.3120117188, -5756.8393554688, 15.721945953369),
	diamondRotation = vector3(0.0, -0.0, 0.0),
	display = "h4_prop_h4_diamond_disp_01a",
	model = "h4_prop_h4_diamond_01a"
}

Cyr.KeysMeta = {
	cayo_mansion_appartment_1 = true,
	cayo_mansion_appartment_2 = true,
	cayo_mansion_mini_appartment_1 = true,
	cayo_mansion_mini_appartment_2 = true,
	cayo_mansion_midle_appartment_1 = true,
	cayo_mansion_midle_appartment_2 = true,
	cayo_mansion_office_entrance = true
}

Cyr.Doors = {
	Houses = {
		cayo_mansion_appartment_1 =  {},
		cayo_mansion_appartment_2 =  {},
		cayo_mansion_mini_appartment_1 =  {},
		cayo_mansion_mini_appartment_2 =  {},
		cayo_mansion_midle_appartment_1 =  {},
		cayo_mansion_midle_appartment_2 =  {},
		cayo_mansion_office_entrance = {}
	},

	Hack = {
		cayo_mansion_side_entrance_right_1_1 = {
			"cayo_mansion_side_entrance_right_1",
			"cayo_mansion_side_entrance_right_2"
		},

		cayo_mansion_side_entrance_right_2_1 = {
			"cayo_mansion_side_entrance_right_1",
			"cayo_mansion_side_entrance_right_2"
		},

		cayo_mansion_side_entrance_left_1_1 = {
			"cayo_mansion_side_entrance_left_1",
			"cayo_mansion_side_entrance_left_2"
		},

		cayo_mansion_side_entrance_left_2_1 = {
			"cayo_mansion_side_entrance_left_1",
			"cayo_mansion_side_entrance_left_2"
		}
	},

	Thermal = {
		cayo_mansion_vault_entrance_middle_1 = {
			"cayo_mansion_vault_entrance_middle"
		},

		cayo_mansion_vault_room_1 = {
			"cayo_mansion_vault_room"
		},

		cayo_mansion_vault_main_1 = {
			"cayo_mansion_vault_main"
		},

		cayo_mansion_vault_entrance_right_1 = {
			"cayo_mansion_vault_entrance_right"
		},

		cayo_mansion_vault_entrance_left_1 = {
			"cayo_mansion_vault_entrance_left"
		}
	}
}

Cyr.Guards = {
	coords = {
		vector3(4972.0551757813, -5792.7631835938, 20.877676010132),
		vector3(4981.7934570313, -5799.4936523438, 20.87760925293),
		vector3(4994.0239257813, -5805.1376953125, 20.877662658691),
		vector3(5011.60546875, -5807.5908203125, 17.473436355591),
		vector3(5026.2866210938, -5803.7919921875, 17.477691650391),
		vector3(5043.0395507813, -5792.787109375, 17.476573944092),
		vector3(5056.337890625, -5786.630859375, 11.47749042511),
		vector3(5065.9169921875, -5781.4174804688, 11.47758769989),
		vector3(5072.359375, -5773.41015625, 11.477610588074),
		vector3(5078.6215820313, -5763.8354492188, 15.677493095398),
		vector3(5084.1884765625, -5753.275390625, 15.677516937256),
		vector3(5094.4047851563, -5746.28515625, 15.677492141724),
		vector3(5087.9619140625, -5741.5629882813, 15.677618026733),
		vector3(5072.3999023438, -5745.2016601563, 15.677438735962),
		vector3(5075.7416992188, -5731.4921875, 15.877449035645),
		vector3(5066.5502929688, -5725.0874023438, 14.457607269287),
		vector3(5061.4272460938, -5709.15234375, 14.568652153015),
		vector3(5050.83203125, -5708.8813476563, 14.567316055298),
		vector3(5037.330078125, -5694.1254882813, 19.877487182617),
		vector3(5019.154296875, -5693.7836914063, 19.872146606445),
		vector3(5002.943359375, -5699.1616210938, 20.078714370728),
		vector3(4997.5185546875, -5714.796875, 19.880224227905),
		vector3(4991.6030273438, -5737.7895507813, 19.880224227905),
		vector3(4972.701171875, -5750.1264648438, 19.880224227905),
		vector3(4977.140625, -5762.169921875, 20.878124237061),
		vector3(5002.5908203125, -5775.0043945313, 16.278448104858),
		vector3(4993.3061523438, -5768.119140625, 16.278928756714),
		vector3(5023.4501953125, -5758.7109375, 16.277828216553),
		vector3(5037.42578125, -5757.1982421875, 15.678511619568),
		vector3(5051.1743164063, -5770.9296875, 16.277126312256),
		vector3(5021.87109375, -5786.08984375, 16.363742828369)
	}
}