local _, DR = ...

local PLACEHOLDER = "[PH]"

DR.DragonRaceCurrencies = {
-- Waking Shores
	2042, 2044, 2154, 2421, 2422, 2664,	 -- Ruby Lifeshrine Loop
	2048, 2049, 2176, 2423, 2424,		 -- Wild Preserve Slalom
	2052, 2053, 2177, 2425, 2426,		 -- Emberflow Flight
	2054, 2055, 2178, 2427, 2428,		 -- Apex Canopy River Run
	2056, 2057, 2179, 2429, 2430,		 -- Uktulut Coaster
	2058, 2059, 2180, 2431, 2432,		 -- Wingrest Roundabout
	2046, 2047, 2181, 2433, 2434,		 -- Flashfrost Flyover
	2050, 2051, 2182, 2435, 2436,		 -- Wild Preserve Circuit

-- Ohn'ahran Plains
	2060, 2061, 2183, 2437, 2439,		 -- Sundapple Copse Circuit
	2062, 2063, 2184, 2440, 2441, 2665,	 -- Fen Flythrough
	2064, 2065, 2185, 2442, 2443,		 -- Ravine River Run
	2066, 2067, 2186, 2444, 2445,		 -- Emerald Gardens Ascent
	2069,		2446,					 -- Maruukai Dash
	2070,		2447,					 -- Mirror of the Sky Dash
	2119, 2120, 2187, 2448, 2449,		 -- River Rapids Route

-- Azure Span
	2074, 2075, 2188, 2450, 2451,		 -- The Azure Span Sprint
	2076, 2077, 2189, 2452, 2453,		 -- The Azure Span Slalom
	2078, 2079, 2190, 2454, 2455, 2666,	 -- The Vakthros Ascent
	2083, 2084, 2191, 2456, 2457,		 -- Iskaara Tour
	2085, 2086, 2192, 2458, 2459,		 -- Frostland Flyover
	2089, 2090, 2193, 2460, 2461,		 -- Archive Ambit

-- Thaldraszus
	2080, 2081, 2194, 2462, 2463,		 -- The Flowing Forest Flight
	2092, 2093, 2195, 2464, 2465, 2667,	 -- Tyrhold Trial
	2096, 2097, 2196, 2466, 2467,		 -- Cliffside Circuit
	2098, 2099, 2197, 2468, 2469,		 -- Academy Ascent
	2101, 2102, 2198, 2470, 2471,		 -- Garden Gallivant
	2103, 2104, 2199, 2472, 2473,		 -- Caverns Criss-Cross

-- Forbidden Reach
	2201, 2207, 2213, 2474, 2475, 2668,	 -- Stormsunder Crater Circuit
	2202, 2208, 2214, 2476, 2477,		 -- Morqut Ascent
	2203, 2209, 2215, 2478, 2479,		 -- Aerie Chasm
	2204, 2210, 2216, 2480, 2481,		 -- Southern Reach Route
	2205, 2211, 2217, 2482, 2483,		 -- Caldera Coaster
	2206, 2212, 2218, 2484, 2485,		 -- Forbidden Reach Rush

-- Zaralek Caverns
	2246, 2252, 2258, 2486, 2487, 2669,	 -- Crystal Circuit
	2247, 2253, 2259, 2488, 2489,		 -- Caldera Cruise
	2248, 2254, 2260, 2490, 2491,		 -- Brimstone Scramble
	2249, 2255, 2261, 2492, 2493,		 -- Shimmering Slalom
	2250, 2256, 2262, 2494, 2495,		 -- Loamm Roamm
	2251, 2257, 2263, 2496, 2497,		 -- Sulfur Sprint

-- Emerald Dream
	2676, 2682, 2688, 2694, 2695,		 -- Ysera Invitational
	2677, 2683, 2689, 2696, 2697,		 -- Smoldering Sprint
	2678, 2684, 2690, 2698, 2699,		 -- Viridescent Venture
	2679, 2685, 2691, 2700, 2701,		 -- Shoreline Switchback
	2680, 2686, 2692, 2702, 2703,		 -- Canopy Concours
	2681, 2687, 2693, 2704, 2705,		 -- Emerald Amble

-- Kalimdor Cup
	2312, 2342, 2372, 2498, 2499, -- Felwood Flyover
	2313, 2343, 2373, 2500, 2501, -- Winter Wander
	2314, 2344, 2374, 2502, 2503, -- Nordrassil Spiral
	2315, 2345, 2375, 2504, 2505, -- Hyjal Hotfoot
	2316, 2346, 2376, 2506, 2507, -- Rocketway Ride
	2317, 2347, 2377, 2508, 2509, -- Ashenvale Ambit
	2318, 2348, 2378, 2510, 2511, -- Durotar Tour
	2319, 2349, 2379, 2512, 2513, -- Webwinder Weave
	2320, 2350, 2380, 2514, 2515, -- Desolace Drift
	2321, 2351, 2381, 2516, 2517, -- Great Divide Dive
	2322, 2352, 2382, 2518, 2519, -- Razorfen Roundabout
	2323, 2353, 2383, 2520, 2521, -- Thousand Needles Thread
	2324, 2354, 2384, 2522, 2523, -- Feralas Ruins Ramble
	2325, 2355, 2385, 2524, 2525, -- Ahn'Qiraj Circuit
	2326, 2356, 2386, 2526, 2527, -- Uldum Tour
	2327, 2357, 2387, 2528, 2529, -- Un'Goro Crater Circuit

-- Eastern Kingdoms Cup
	2536, 2552, 2568, -- Gilneas Gambit
	2537, 2553, 2569, -- Loch Modan Loop
	2538, 2554, 2570, -- Searing Slalom
	2539, 2555, 2571, -- Twilight Terror
	2540, 2556, 2572, -- Deadwind Derby
	2541, 2557, 2573, -- Elwynn Forest Flash
	2542, 2558, 2574, -- Gurubashi Gala
	2543, 2559, 2575, -- Ironforge Interceptor
	2544, 2560, 2576, -- Blasted Lands Bolt
	2545, 2561, 2577, -- Plaguelands Plunge
	2546, 2562, 2578, -- Booty Bay Blast
	2547, 2563, 2579, -- Fuselight Night Flight
	2548, 2564, 2580, -- Krazzworks Klash
	2549, 2565, 2581, -- Redridge Rally

-- Outland Cup
	2600, 2615, 2630, -- Hellfire Hustle
	2601, 2616, 2631, -- Coilfang Caper
	2602, 2617, 2632, -- Blade's Edge Brawl
	2603, 2618, 2633, -- Telaar Tear
	2604, 2619, 2634, -- Razorthorn Rise Rush
	2605, 2620, 2635, -- Auchindoun Coaster
	2606, 2621, 2636, -- Tempest Keep Sweep
	2607, 2622, 2637, -- Shattrath City Sashay
	2608, 2623, 2638, -- Shadowmoon Slam
	2609, 2624, 2639, -- Eco-Dome Excursion
	2610, 2625, 2640, -- Warmaul Wingding
	2611, 2626, 2641, -- Skettis Scramble
	2612, 2627, 2642, -- Fel Pit Fracas

-- Northrend Cup
	2720, 2738, 2756, -- Scalawag Slither
	2721, 2739, 2757, -- Daggercap Dart
	2722, 2740, 2758, -- Blackriver Burble
	2723, 2741, 2759, -- Zul'Drak Zephyr
	2724, 2742, 2760, -- Makers' Marathon
	2725, 2743, 2761, -- Crystalsong Crisis
	2726, 2744, 2762, -- Dragonblight Dragon Flight
	2727, 2745, 2763, -- Citadel Sortie
	2728, 2746, 2764, -- Sholazar Spree
	2729, 2747, 2765, -- Geothermal Jaunt
	2730, 2748, 2766, -- Gundrak Fast Track
	2731, 2749, 2767, -- Coldarra Climb
};

DR.RaceData = {
-- Waking Shores
	--Ruby Lifeshrine Loop
	[2154] = {
		["silverTime"] = 55,
		["goldTime"] = 50,
		["questID"] = 66679,
	},
	[2042] = {
		["silverTime"] = 56,
		["goldTime"] = 53,
		["questID"] = 66679,
	},
	[2044] = {
		["silverTime"] = 57,
		["goldTime"] = 52,
		["questID"] = 66679,
	},
	[2421] = {
		["silverTime"] = 57,
		["goldTime"] = 54,
		["questID"] = 66679,
	},
	[2422] = {
		["silverTime"] = 60,
		["goldTime"] = 57,
		["questID"] = 66679,
	},
	[2664] = {
		["silverTime"] = 70,
		["goldTime"] = 65,
		["questID"] = 66679,
	},

	--Wild Preserve Slalom
	[2176] = {
		["silverTime"] = 46,
		["goldTime"] = 41,
		["questID"] = 66721,
	},
	[2048] = {
		["silverTime"] = 45,
		["goldTime"] = 42,
		["questID"] = 66721,
	},
	[2049] = {
		["silverTime"] = 45,
		["goldTime"] = 40,
		["questID"] = 66721,
	},
	[2424] = {
		["silverTime"] = 52,
		["goldTime"] = 49,
		["questID"] = 66721,
	},
	[2423] = {
		["silverTime"] = 51,
		["goldTime"] = 48,
		["questID"] = 66721,
	},

	--Emberflow Flight
	[2425] = {
		["silverTime"] = 53,
		["goldTime"] = 50,
		["questID"] = 66727,
	},
	[2426] = {
		["silverTime"] = 54,
		["goldTime"] = 51,
		["questID"] = 66727,
	},
	[2177] = {
		["silverTime"] = 50,
		["goldTime"] = 45,
		["questID"] = 66727,
	},
	[2052] = {
		["silverTime"] = 53,
		["goldTime"] = 50,
		["questID"] = 66727,
	},
	[2053] = {
		["silverTime"] = 49,
		["goldTime"] = 44,
		["questID"] = 66727,
	},

	--Apex Canopy River Run
	[2427] = {
		["silverTime"] = 56,
		["goldTime"] = 53,
		["questID"] = 66732,
	},
	[2428] = {
		["silverTime"] = 56,
		["goldTime"] = 53,
		["questID"] = 66732,
	},
	[2178] = {
		["silverTime"] = 53,
		["goldTime"] = 48,
		["questID"] = 66732,
	},
	[2054] = {
		["silverTime"] = 55,
		["goldTime"] = 52,
		["questID"] = 66732,
	},
	[2055] = {
		["silverTime"] = 50,
		["goldTime"] = 45,
		["questID"] = 66732,
	},

	--Uktulut Coaster
	[2429] = {
		["silverTime"] = 49,
		["goldTime"] = 46,
		["questID"] = 66777,
	},
	[2430] = {
		["silverTime"] = 51,
		["goldTime"] = 48,
		["questID"] = 66777,
	},
	[2179] = {
		["silverTime"] = 48,
		["goldTime"] = 43,
		["questID"] = 66777,
	},
	[2056] = {
		["silverTime"] = 48,
		["goldTime"] = 45,
		["questID"] = 66777,
	},
	[2057] = {
		["silverTime"] = 45,
		["goldTime"] = 40,
		["questID"] = 66777,
	},
	
	--Wingrest Roundabout
	[2432] = {
		["silverTime"] = 63,
		["goldTime"] = 60,
		["questID"] = 66786,
	},
	[2431] = {
		["silverTime"] = 63,
		["goldTime"] = 60,
		["questID"] = 66786,
	},
	[2180] = {
		["silverTime"] = 61,
		["goldTime"] = 56,
		["questID"] = 66786,
	},
	[2058] = {
		["silverTime"] = 56,
		["goldTime"] = 53,
		["questID"] = 66786,
	},
	[2059] = {
		["silverTime"] = 58,
		["goldTime"] = 53,
		["questID"] = 66786,
	},
	
	--Flashfrost Flyover
	[2181] = {
		["silverTime"] = 65,
		["goldTime"] = 60,
		["questID"] = 66710,
	},
	[2434] = {
		["silverTime"] = 74,
		["goldTime"] = 69,
		["questID"] = 66710,
	},
	[2433] = {
		["silverTime"] = 67,
		["goldTime"] = 64,
		["questID"] = 66710,
	},
	[2046] = {
		["silverTime"] = 66,
		["goldTime"] = 63,
		["questID"] = 66710,
	},
	[2047] = {
		["silverTime"] = 66,
		["goldTime"] = 61,
		["questID"] = 66710,
	},
	
	--Wild Preserve Circuit
	[2182] = {
		["silverTime"] = 46,
		["goldTime"] = 41,
		["questID"] = 66725,
	},
	[2435] = {
		["silverTime"] = 46,
		["goldTime"] = 43,
		["questID"] = 66725,
	},
	[2050] = {
		["silverTime"] = 43,
		["goldTime"] = 40,
		["questID"] = 66725,
	},
	[2051] = {
		["silverTime"] = 43,
		["goldTime"] = 38,
		["questID"] = 66725,
	},
	[2436] = {
		["silverTime"] = 47,
		["goldTime"] = 44,
		["questID"] = 66725,
	},



-- Ohn'ahran Plains
	-- Sundapple Copse Circuit
	[2437] = {
		["silverTime"] = 54,
		["goldTime"] = 51,
		["questID"] = 66835,
	},
	[2183] = {
		["silverTime"] = 50,
		["goldTime"] = 45,
		["questID"] = 66835,
	},
	[2439] = {
		["silverTime"] = 53,
		["goldTime"] = 50,
		["questID"] = 66835,
	},
	[2060] = {
		["silverTime"] = 52,
		["goldTime"] = 49,
		["questID"] = 66835,
	},
	[2061] = {
		["silverTime"] = 46,
		["goldTime"] = 41,
		["questID"] = 66835,
	},

	-- Fen Flythrough
	[2441] = {
		["silverTime"] = 53,
		["goldTime"] = 50,
		["questID"] = 66877,
	},
	[2184] = {
		["silverTime"] = 52,
		["goldTime"] = 47,
		["questID"] = 66877,
	},
	[2665] = {
		["silverTime"] = 87,
		["goldTime"] = 82,
		["questID"] = 66877,
	},
	[2440] = {
		["silverTime"] = 53,
		["goldTime"] = 50,
		["questID"] = 66877,
	},
	[2062] = {
		["silverTime"] = 51,
		["goldTime"] = 48,
		["questID"] = 66877,
	},
	[2063] = {
		["silverTime"] = 46,
		["goldTime"] = 41,
		["questID"] = 66877,
	},

	-- Ravine River Run
	[2064] = {
		["silverTime"] = 52,
		["goldTime"] = 49,
		["questID"] = 66880,
	},
	[2065] = {
		["silverTime"] = 52,
		["goldTime"] = 47,
		["questID"] = 66880,
	},
	[2442] = {
		["silverTime"] = 53,
		["goldTime"] = 50,
		["questID"] = 66880,
	},
	[2185] = {
		["silverTime"] = 51,
		["goldTime"] = 46,
		["questID"] = 66880,
	},
	[2443] = {
		["silverTime"] = 54,
		["goldTime"] = 51,
		["questID"] = 66880,
	},

	-- Emerald Gardens Ascent
	[2066] = {
		["silverTime"] = 66,
		["goldTime"] = 63,
		["questID"] = 66885,
	},
	[2067] = {
		["silverTime"] = 60,
		["goldTime"] = 55,
		["questID"] = 66885,
	},
	[2444] = {
		["silverTime"] = 69,
		["goldTime"] = 66,
		["questID"] = 66885,
	},
	[2186] = {
		["silverTime"] = 62,
		["goldTime"] = 57,
		["questID"] = 66885,
	},
	[2445] = {
		["silverTime"] = 69,
		["goldTime"] = 66,
		["questID"] = 66885,
	},

	-- Maruukai Dash

	[2446] = {
		["silverTime"] = 27,
		["goldTime"] = 24,
		["questID"] = 66921,
	},
	[2069] = {
		["silverTime"] = 28,
		["goldTime"] = 25,
		["questID"] = 66921,
	},

	-- Mirror of the Sky Dash
	[2447] = {
		["silverTime"] = 30,
		["goldTime"] = 27,
		["questID"] = 66933,
	},
	[2070] = {
		["silverTime"] = 29,
		["goldTime"] = 26,
		["questID"] = 66933,
	},

	-- River Rapids Route
	[2448] = {
		["silverTime"] = 55,
		["goldTime"] = 52,
		["questID"] = 70710,
	},
	[2449] = {
		["silverTime"] = 55,
		["goldTime"] = 52,
		["questID"] = 70710,
	},
	[2119] = {
		["silverTime"] = 51,
		["goldTime"] = 48,
		["questID"] = 70710,
	},
	[2120] = {
		["silverTime"] = 48,
		["goldTime"] = 43,
		["questID"] = 70710,
	},
	[2187] = {
		["silverTime"] = 49,
		["goldTime"] = 44,
		["questID"] = 70710,
	},


-- Azure Span
	 -- The Azure Span Sprint
	[2450] = {
		["silverTime"] = 70,
		["goldTime"] = 67,
		["questID"] = 66946,
	},
	[2451] = {
		["silverTime"] = 72,
		["goldTime"] = 69,
		["questID"] = 66946,
	},
	[2074] = {
		["silverTime"] = 66,
		["goldTime"] = 63,
		["questID"] = 66946,
	},
	[2075] = {
		["silverTime"] = 63,
		["goldTime"] = 58,
		["questID"] = 66946,
	},
	[2188] = {
		["silverTime"] = 65,
		["goldTime"] = 60,
		["questID"] = 66946,
	},

	 -- The Azure Span Slalom
	[2452] = {
		["silverTime"] = 58,
		["goldTime"] = 55,
		["questID"] = 67002,
	},
	[2453] = {
		["silverTime"] = 58,
		["goldTime"] = 55,
		["questID"] = 67002,
	},
	[2076] = {
		["silverTime"] = 61,
		["goldTime"] = 58,
		["questID"] = 67002,
	},
	[2077] = {
		["silverTime"] = 61,
		["goldTime"] = 56,
		["questID"] = 67002,
	},
	[2189] = {
		["silverTime"] = 58,
		["goldTime"] = 53,
		["questID"] = 67002,
	},

	 -- The Vakthros Ascent
	[2454] = {
		["silverTime"] = 66,
		["goldTime"] = 63,
		["questID"] = 67031,
	},
	[2455] = {
		["silverTime"] = 67,
		["goldTime"] = 64,
		["questID"] = 67031,
	},
	[2078] = {
		["silverTime"] = 61,
		["goldTime"] = 58,
		["questID"] = 67031,
	},
	[2079] = {
		["silverTime"] = 61,
		["goldTime"] = 56,
		["questID"] = 67031,
	},
	[2190] = {
		["silverTime"] = 61,
		["goldTime"] = 56,
		["questID"] = 67031,
	},
	[2666] = {
		["silverTime"] = 125,
		["goldTime"] = 120,
		["questID"] = 67031,
	},


	 -- Iskaara Tour
	[2456] = {
		["silverTime"] = 81,
		["goldTime"] = 78,
		["questID"] = 67296,
	},
	[2457] = {
		["silverTime"] = 82,
		["goldTime"] = 79,
		["questID"] = 67296,
	},
	[2083] = {
		["silverTime"] = 78,
		["goldTime"] = 75,
		["questID"] = 67296,
	},
	[2084] = {
		["silverTime"] = 75,
		["goldTime"] = 70,
		["questID"] = 67296,
	},
	[2191] = {
		["silverTime"] = 72,
		["goldTime"] = 67,
		["questID"] = 67296,
	},

	 -- Frostland Flyover
	[2458] = {
		["silverTime"] = 88,
		["goldTime"] = 85,
		["questID"] = 67565,
	},
	[2459] = {
		["silverTime"] = 86,
		["goldTime"] = 83,
		["questID"] = 67565,
	},
	[2085] = {
		["silverTime"] = 79,
		["goldTime"] = 76,
		["questID"] = 67565,
	},
	[2086] = {
		["silverTime"] = 77,
		["goldTime"] = 72,
		["questID"] = 67565,
	},
	[2192] = {
		["silverTime"] = 74,
		["goldTime"] = 69,
		["questID"] = 67565,
	},

	 -- Archive Ambit
	[2460] = {
		["silverTime"] = 93,
		["goldTime"] = 90,
		["questID"] = 67741,
	},
	[2461] = {
		["silverTime"] = 95,
		["goldTime"] = 92,
		["questID"] = 67741,
	},
	[2089] = {
		["silverTime"] = 94,
		["goldTime"] = 91,
		["questID"] = 67741,
	},
	[2090] = {
		["silverTime"] = 86,
		["goldTime"] = 81,
		["questID"] = 67741,
	},
	[2193] = {
		["silverTime"] = 81,
		["goldTime"] = 76,
		["questID"] = 67741,
	},


-- Thaldraszus
	 -- The Flowing Forest Flight
	[2462] = {
		["silverTime"] = 50,
		["goldTime"] = 47,
		["questID"] = 67095,
	},
	[2080] = {
		["silverTime"] = 52,
		["goldTime"] = 49,
		["questID"] = 67095,
	},
	[2463] = {
		["silverTime"] = 49,
		["goldTime"] = 46,
		["questID"] = 67095,
	},
	[2081] = {
		["silverTime"] = 45,
		["goldTime"] = 40,
		["questID"] = 67095,
	},
	[2194] = {
		["silverTime"] = 46,
		["goldTime"] = 41,
		["questID"] = 67095,
	},
	
	 -- Tyrhold Trial
	[2464] = {
		["silverTime"] = 61,
		["goldTime"] = 58,
		["questID"] = 69957,
	},
	[2465] = {
		["silverTime"] = 66,
		["goldTime"] = 63,
		["questID"] = 69957,
	},
	[2092] = {
		["silverTime"] = 84,
		["goldTime"] = 81,
		["questID"] = 69957,
	},
	[2093] = {
		["silverTime"] = 80,
		["goldTime"] = 75,
		["questID"] = 69957,
	},
	[2667] = {
		["silverTime"] = 85,
		["goldTime"] = 80,
		["questID"] = 69957,
	},
	[2195] = {
		["silverTime"] = 64,
		["goldTime"] = 59,
		["questID"] = 69957,
	},
	
	 -- Cliffside Circuit
	[2466] = {
		["silverTime"] = 84,
		["goldTime"] = 81,
		["questID"] = 70051,
	},
	[2467] = {
		["silverTime"] = 83,
		["goldTime"] = 80,
		["questID"] = 70051,
	},
	[2096] = {
		["silverTime"] = 72,
		["goldTime"] = 69,
		["questID"] = 70051,
	},
	[2097] = {
		["silverTime"] = 71,
		["goldTime"] = 66,
		["questID"] = 70051,
	},
	[2196] = {
		["silverTime"] = 74,
		["goldTime"] = 69,
		["questID"] = 70051,
	},
	
	 -- Academy Ascent
	[2468] = {
		["silverTime"] = 68,
		["goldTime"] = 65,
		["questID"] = 70059,
	},
	[2469] = {
		["silverTime"] = 68,
		["goldTime"] = 65,
		["questID"] = 70059,
	},
	[2098] = {
		["silverTime"] = 57,
		["goldTime"] = 54,
		["questID"] = 70059,
	},
	[2099] = {
		["silverTime"] = 57,
		["goldTime"] = 52,
		["questID"] = 70059,
	},
	[2197] = {
		["silverTime"] = 58,
		["goldTime"] = 53,
		["questID"] = 70059,
	},
	
	 -- Garden Gallivant
	[2470] = {
		["silverTime"] = 63,
		["goldTime"] = 60,
		["questID"] = 70157,
	},
	[2471] = {
		["silverTime"] = 67,
		["goldTime"] = 64,
		["questID"] = 70157,
	},
	[2101] = {
		["silverTime"] = 64,
		["goldTime"] = 61,
		["questID"] = 70157,
	},
	[2102] = {
		["silverTime"] = 59,
		["goldTime"] = 54,
		["questID"] = 70157,
	},
	[2198] = {
		["silverTime"] = 62,
		["goldTime"] = 57,
		["questID"] = 70157,
	},
	
	 -- Caverns Criss-Cross
	[2472] = {
		["silverTime"] = 59,
		["goldTime"] = 56,
		["questID"] = 70161,
	},
	[2473] = {
		["silverTime"] = 57,
		["goldTime"] = 54,
		["questID"] = 70161,
	},
	[2103] = {
		["silverTime"] = 53,
		["goldTime"] = 50,
		["questID"] = 70161,
	},
	[2104] = {
		["silverTime"] = 50,
		["goldTime"] = 45,
		["questID"] = 70161,
	},
	[2199] = {
		["silverTime"] = 52,
		["goldTime"] = 47,
		["questID"] = 70161,
	},


-- Forbidden Reach
	 -- Stormsunder Crater Circuit
	[2474] = {
		["silverTime"] = 48,
		["goldTime"] = 45,
		["questID"] = 73017,
	},
	[2475] = {
		["silverTime"] = 47,
		["goldTime"] = 44,
		["questID"] = 73017,
	},
	[2207] = {
		["silverTime"] = 47,
		["goldTime"] = 42,
		["questID"] = 73017,
	},
	[2213] = {
		["silverTime"] = 47,
		["goldTime"] = 42,
		["questID"] = 73017,
	},
	[2201] = {
		["silverTime"] = 46,
		["goldTime"] = 43,
		["questID"] = 73017,
	},
	[2668] = {
		["silverTime"] = 97,
		["goldTime"] = 92,
		["questID"] = 73017,
	},
	
	 -- Morqut Ascent
	[2476] = {
		["silverTime"] = 53,
		["goldTime"] = 50,
		["questID"] = 73020,
	},
	[2477] = {
		["silverTime"] = 53,
		["goldTime"] = 50,
		["questID"] = 73020,
	},
	[2208] = {
		["silverTime"] = 54,
		["goldTime"] = 49,
		["questID"] = 73020,
	},
	[2214] = {
		["silverTime"] = 57,
		["goldTime"] = 52,
		["questID"] = 73020,
	},
	[2202] = {
		["silverTime"] = 55,
		["goldTime"] = 52,
		["questID"] = 73020,
	},
	
	 -- Aerie Chasm
	[2478] = {
		["silverTime"] = 56,
		["goldTime"] = 53,
		["questID"] = 73025,
	},
	[2479] = {
		["silverTime"] = 55,
		["goldTime"] = 52,
		["questID"] = 73025,
	},
	[2215] = {
		["silverTime"] = 55,
		["goldTime"] = 50,
		["questID"] = 73025,
	},
	[2209] = {
		["silverTime"] = 55,
		["goldTime"] = 50,
		["questID"] = 73025,
	},
	[2203] = {
		["silverTime"] = 56,
		["goldTime"] = 53,
		["questID"] = 73025,
	},
	
	 -- Southern Reach Route
	[2480] = {
		["silverTime"] = 73,
		["goldTime"] = 70,
		["questID"] = 73029,
	},
	[2481] = {
		["silverTime"] = 71,
		["goldTime"] = 68,
		["questID"] = 73029,
	},
	[2216] = {
		["silverTime"] = 68,
		["goldTime"] = 63,
		["questID"] = 73029,
	},
	[2204] = {
		["silverTime"] = 73,
		["goldTime"] = 70,
		["questID"] = 73029,
	},
	[2210] = {
		["silverTime"] = 73,
		["goldTime"] = 68,
		["questID"] = 73029,
	},
	
	 -- Caldera Coaster
	[2482] = {
		["silverTime"] = 58,
		["goldTime"] = 55,
		["questID"] = 73033,
	},
	[2483] = {
		["silverTime"] = 56,
		["goldTime"] = 53,
		["questID"] = 73033,
	},
	[2217] = {
		["silverTime"] = 54,
		["goldTime"] = 49,
		["questID"] = 73033,
	},
	[2205] = {
		["silverTime"] = 61,
		["goldTime"] = 58,
		["questID"] = 73033,
	},
	[2211] = {
		["silverTime"] = 57,
		["goldTime"] = 52,
		["questID"] = 73033,
	},
	
	 -- Forbidden Reach Rush
	[2484] = {
		["silverTime"] = 63,
		["goldTime"] = 60,
		["questID"] = 73061,
	},
	[2485] = {
		["silverTime"] = 63,
		["goldTime"] = 60,
		["questID"] = 73061,
	},
	[2218] = {
		["silverTime"] = 62,
		["goldTime"] = 57,
		["questID"] = 73061,
	},
	[2206] = {
		["silverTime"] = 62,
		["goldTime"] = 59,
		["questID"] = 73061,
	},
	[2212] = {
		["silverTime"] = 61,
		["goldTime"] = 56,
		["questID"] = 73061,
	},


-- Zaralek Caverns
	 -- Crystal Circuit
	[2246] = {
		["silverTime"] = 68,
		["goldTime"] = 63,
		["questID"] = 74839,
	},
	[2252] = {
		["silverTime"] = 60,
		["goldTime"] = 55,
		["questID"] = 74839,
	},
	[2258] = {
		["silverTime"] = 58,
		["goldTime"] = 53,
		["questID"] = 74839,
	},
	[2486] = {
		["silverTime"] = 60,
		["goldTime"] = 57,
		["questID"] = 74839,
	},
	[2487] = {
		["silverTime"] = 61,
		["goldTime"] = 58,
		["questID"] = 74839,
	},
	[2669] = {
		["silverTime"] = 100,
		["goldTime"] = 95,
		["questID"] = 74839,
	},
	
	 -- Caldera Cruise
	[2247] = {
		["silverTime"] = 80,
		["goldTime"] = 75,
		["questID"] = 74889,
	},
	[2253] = {
		["silverTime"] = 73,
		["goldTime"] = 68,
		["questID"] = 74889,
	},
	[2259] = {
		["silverTime"] = 73,
		["goldTime"] = 68,
		["questID"] = 74889,
	},
	[2488] = {
		["silverTime"] = 75,
		["goldTime"] = 72,
		["questID"] = 74889,
	},
	[2489] = {
		["silverTime"] = 75,
		["goldTime"] = 72,
		["questID"] = 74889,
	},
	
	 -- Brimstone Scramble
	[2248] = {
		["silverTime"] = 72,
		["goldTime"] = 69,
		["questID"] = 74939,
	},
	[2254] = {
		["silverTime"] = 69,
		["goldTime"] = 64,
		["questID"] = 74939,
	},
	[2260] = {
		["silverTime"] = 69,
		["goldTime"] = 64,
		["questID"] = 74939,
	},
	[2490] = {
		["silverTime"] = 72,
		["goldTime"] = 69,
		["questID"] = 74939,
	},
	[2491] = {
		["silverTime"] = 74,
		["goldTime"] = 71,
		["questID"] = 74939,
	},
	
	 -- Shimmering Slalom
	[2249] = {
		["silverTime"] = 80,
		["goldTime"] = 75,
		["questID"] = 74951,
	},
	[2255] = {
		["silverTime"] = 75,
		["goldTime"] = 70,
		["questID"] = 74951,
	},
	[2261] = {
		["silverTime"] = 75,
		["goldTime"] = 70,
		["questID"] = 74951,
	},
	[2492] = {
		["silverTime"] = 82,
		["goldTime"] = 79,
		["questID"] = 74951,
	},
	[2493] = {
		["silverTime"] = 78,
		["goldTime"] = 75,
		["questID"] = 74951,
	},
	
	 -- Loamm Roamm
	[2250] = {
		["silverTime"] = 60,
		["goldTime"] = 55,
		["questID"] = 74972,
	},
	[2256] = {
		["silverTime"] = 55,
		["goldTime"] = 50,
		["questID"] = 74972,
	},
	[2262] = {
		["silverTime"] = 53,
		["goldTime"] = 48,
		["questID"] = 74972,
	},
	[2494] = {
		["silverTime"] = 56,
		["goldTime"] = 53,
		["questID"] = 74972,
	},
	[2495] = {
		["silverTime"] = 55,
		["goldTime"] = 52,
		["questID"] = 74972,
	},
	
	 -- Sulfur Sprint
	 [2251] = {
		["silverTime"] = 67,
		["goldTime"] = 64,
		["questID"] = 75035,
	},
	[2257] = {
		["silverTime"] = 63,
		["goldTime"] = 58,
		["questID"] = 75035,
	},
	[2263] = {
		["silverTime"] = 62,
		["goldTime"] = 57,
		["questID"] = 75035,
	},
	[2496] = {
		["silverTime"] = 70,
		["goldTime"] = 67,
		["questID"] = 75035,
	},
	[2497] = {
		["silverTime"] = 68,
		["goldTime"] = 65,
		["questID"] = 75035,
	},

-- Emerald Dream
	 -- Ysera Invitational
	[2695] = {
		["silverTime"] = 100,
		["goldTime"] = 97,
		["questID"] = 77841,
	},
	[2694] = {
		["silverTime"] = 98,
		["goldTime"] = 95,
		["questID"] = 77841,
	},
	[2688] = {
		["silverTime"] = 90,
		["goldTime"] = 87,
		["questID"] = 77841,
	},
	[2682] = {
		["silverTime"] = 90,
		["goldTime"] = 87,
		["questID"] = 77841,
	},
	[2676] = {
		["silverTime"] = 103,
		["goldTime"] = 98,
		["questID"] = 77841,
	},
	
	 -- Smoldering Sprint
	[2697] = {
		["silverTime"] = 83,
		["goldTime"] = 80,
		["questID"] = 77983,
	},
	[2696] = {
		["silverTime"] = 82,
		["goldTime"] = 79,
		["questID"] = 77983,
	},
	[2689] = {
		["silverTime"] = 76,
		["goldTime"] = 73,
		["questID"] = 77983,
	},
	[2683] = {
		["silverTime"] = 76,
		["goldTime"] = 73,
		["questID"] = 77983,
	},
	[2677] = {
		["silverTime"] = 85,
		["goldTime"] = 80,
		["questID"] = 77983,
	},
	
	 -- Viridescent Venture
	[2699] = {
		["silverTime"] = 76,
		["goldTime"] = 73,
		["questID"] = 77996,
	},
	[2698] = {
		["silverTime"] = 76,
		["goldTime"] = 73,
		["questID"] = 77996,
	},
	[2690] = {
		["silverTime"] = 67,
		["goldTime"] = 64,
		["questID"] = 77996,
	},
	[2684] = {
		["silverTime"] = 67,
		["goldTime"] = 64,
		["questID"] = 77996,
	},
	[2678] = {
		["silverTime"] = 83,
		["goldTime"] = 78,
		["questID"] = 77996,
	},
	
	 -- Shoreline Switchback
	[2701] = {
		["silverTime"] = 73,
		["goldTime"] = 70,
		["questID"] = 78016,
	},
	[2700] = {
		["silverTime"] = 73,
		["goldTime"] = 70,
		["questID"] = 78016,
	},
	[2691] = {
		["silverTime"] = 65,
		["goldTime"] = 62,
		["questID"] = 78016,
	},
	[2685] = {
		["silverTime"] = 66,
		["goldTime"] = 63,
		["questID"] = 78016,
	},
	[2679] = {
		["silverTime"] = 78,
		["goldTime"] = 73,
		["questID"] = 78016,
	},
	
	 -- Canopy Concours
	[2703] = {
		["silverTime"] = 108,
		["goldTime"] = 105,
		["questID"] = 78102,
	},
	[2702] = {
		["silverTime"] = 108,
		["goldTime"] = 105,
		["questID"] = 78102,
	},
	[2692] = {
		["silverTime"] = 99,
		["goldTime"] = 96,
		["questID"] = 78102,
	},
	[2686] = {
		["silverTime"] = 96,
		["goldTime"] = 93,
		["questID"] = 78102,
	},
	[2680] = {
		["silverTime"] = 110,
		["goldTime"] = 105,
		["questID"] = 78102,
	},
	
	 -- Emerald Amble
	[2705] = {
		["silverTime"] = 76,
		["goldTime"] = 73,
		["questID"] = 78115,
	},
	[2704] = {
		["silverTime"] = 76,
		["goldTime"] = 73,
		["questID"] = 78115,
	},
	[2693] = {
		["silverTime"] = 73,
		["goldTime"] = 70,
		["questID"] = 78115,
	},
	[2687] = {
		["silverTime"] = 73,
		["goldTime"] = 70,
		["questID"] = 78115,
	},
	[2681] = {
		["silverTime"] = 89,
		["goldTime"] = 84,
		["questID"] = 78115,
	},



-- Kalimdor Cup
	 -- Felwood Flyover
	
	 -- Winter Wander
	
	 -- Nordrassil Spiral
	
	 -- Hyjal Hotfoot
	
	 -- Rocketway Ride
	
	 -- Ashenvale Ambit
	
	 -- Durotar Tour
	
	 -- Webwinder Weave
	
	 -- Desolace Drift
	
	 -- Great Divide Dive
	
	 -- Razorfen Roundabout
	
	 -- Thousand Needles Thread
	
	 -- Feralas Ruins Ramble
	
	 -- Ahn'Qiraj Circuit
	
	 -- Uldum Tour
	
	 -- Un'Goro Crater Circuit



-- Eastern Kingdoms Cup
	 -- Gilneas Gambit
	
	 -- Loch Modan Loop
	
	 -- Searing Slalom
	
	 -- Twilight Terror
	
	 -- Deadwind Derby
	
	 -- Elwynn Forest Flash
	
	 -- Gurubashi Gala
	
	 -- Ironforge Interceptor
	
	 -- Blasted Lands Bolt
	
	 -- Plaguelands Plunge
	
	 -- Booty Bay Blast
	
	 -- Fuselight Night Flight
	
	 -- Krazzworks Klash
	
	 -- Redridge Rally



-- Outland Cup
	 -- Hellfire Hustle
	[2630] = {
		["silverTime"] = 75,
		["goldTime"] = 72,
		["questID"] = 77102,
	},
	[2615] = {
		["silverTime"] = 76,
		["goldTime"] = 73,
		["questID"] = 77102,
	},
	[2600] = {
		["silverTime"] = 80,
		["goldTime"] = 75,
		["questID"] = 77102,
	},
	
	 -- Coilfang Caper
	[2631] = {
		["silverTime"] = 73,
		["goldTime"] = 70,
		["questID"] = 77169,
	},
	[2616] = {
		["silverTime"] = 73,
		["goldTime"] = 70,
		["questID"] = 77169,
	},
	[2601] = {
		["silverTime"] = 80,
		["goldTime"] = 75,
		["questID"] = 77169,
	},
	
	 -- Blade's Edge Brawl
	[2602] = {
		["silverTime"] = 80,
		["goldTime"] = 75,
		["questID"] = 77205,
	},
	[2632] = {
		["silverTime"] = 78,
		["goldTime"] = 75,
		["questID"] = 77205,
	},
	[2617] = {
		["silverTime"] = 75,
		["goldTime"] = 72,
		["questID"] = 77205,
	},
	
	 -- Telaar Tear
	[2618] = {
		["silverTime"] = 60,
		["goldTime"] = 57,
		["questID"] = 77238,
	},
	[2603] = {
		["silverTime"] = 69,
		["goldTime"] = 64,
		["questID"] = 77238,
	},
	[2633] = {
		["silverTime"] = 61,
		["goldTime"] = 58,
		["questID"] = 77238,
	},
	
	 -- Razorthorn Rise Rush
	[2634] = {
		["silverTime"] = 57,
		["goldTime"] = 54,
		["questID"] = 77260,
	},
	[2619] = {
		["silverTime"] = 57,
		["goldTime"] = 54,
		["questID"] = 77260,
	},
	[2604] = {
		["silverTime"] = 72,
		["goldTime"] = 67,
		["questID"] = 77260,
	},
	
	 -- Auchindoun Coaster
	[2635] = {
		["silverTime"] = 73,
		["goldTime"] = 70,
		["questID"] = 77264,
	},
	[2620] = {
		["silverTime"] = 73,
		["goldTime"] = 70,
		["questID"] = 77264,
	},
	[2605] = {
		["silverTime"] = 78,
		["goldTime"] = 73,
		["questID"] = 77264,
	},
	
	 -- Tempest Keep Sweep
	[2606] = {
		["silverTime"] = 105,
		["goldTime"] = 100,
		["questID"] = 77278,
	},
	[2621] = {
		["silverTime"] = 90,
		["goldTime"] = 87,
		["questID"] = 77278,
	},
	[2636] = {
		["silverTime"] = 91,
		["goldTime"] = 88,
		["questID"] = 77278,
	},
	
	 -- Shattrath City Sashay
	[2637] = {
		["silverTime"] = 69,
		["goldTime"] = 66,
		["questID"] = 77322,
	},
	[2622] = {
		["silverTime"] = 68,
		["goldTime"] = 65,
		["questID"] = 77322,
	},
	[2607] = {
		["silverTime"] = 80,
		["goldTime"] = 75,
		["questID"] = 77322,
	},
	
	 -- Shadowmoon Slam
	[2638] = {
		["silverTime"] = 66,
		["goldTime"] = 63,
		["questID"] = 77346,
	},
	[2623] = {
		["silverTime"] = 66,
		["goldTime"] = 63,
		["questID"] = 77346,
	},
	[2608] = {
		["silverTime"] = 75,
		["goldTime"] = 70,
		["questID"] = 77346,
	},
	
	 -- Eco-Dome Excursion
	[2639] = {
		["silverTime"] = 113,
		["goldTime"] = 110,
		["questID"] = 77398,
	},
	[2624] = {
		["silverTime"] = 112,
		["goldTime"] = 109,
		["questID"] = 77398,
	},
	[2609] = {
		["silverTime"] = 120,
		["goldTime"] = 115,
		["questID"] = 77398,
	},
	
	 -- Warmaul Wingding
	[2610] = {
		["silverTime"] = 85,
		["goldTime"] = 80,
		["questID"] = 77589,
	},
	[2640] = {
		["silverTime"] = 76,
		["goldTime"] = 73,
		["questID"] = 77589,
	},
	[2625] = {
		["silverTime"] = 75,
		["goldTime"] = 72,
		["questID"] = 77589,
	},
	
	 -- Skettis Scramble
	[2626] = {
		["silverTime"] = 66,
		["goldTime"] = 63,
		["questID"] = 77645,
	},
	[2611] = {
		["silverTime"] = 75,
		["goldTime"] = 70,
		["questID"] = 77645,
	},
	[2641] = {
		["silverTime"] = 66,
		["goldTime"] = 63,
		["questID"] = 77645,
	},
	
	 -- Fel Pit Fracas
	[2642] = {
		["silverTime"] = 79,
		["goldTime"] = 76,
		["questID"] = 77684,
	},
	[2627] = {
		["silverTime"] = 76,
		["goldTime"] = 73,
		["questID"] = 77684,
	},
	[2612] = {
		["silverTime"] = 82,
		["goldTime"] = 77,
		["questID"] = 77684,
	},


-- Northrend Cup
	 -- Scalawag Slither
	
	 -- Daggercap Dart
	
	 -- Blackriver Burble
	
	 -- Zul'Drak Zephyr
	
	 -- Makers' Marathon
	
	 -- Crystalsong Crisis
	
	 -- Dragonblight Dragon Flight
	
	 -- Citadel Sortie
	
	 -- Sholazar Spree
	
	 -- Geothermal Jaunt
	
	 -- Gundrak Fast Track
	
	 -- Coldarra Climb


};