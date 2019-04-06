-- Description: auto-created by ExcelToLua tool.
-- Author:jjc

module("resimg", package.seeall)


keys = {
	"﻿id", "icon_path", 
}

resimgTable = {
    id_1 = {"Image/imgres/common/silver.png", },
    id_2 = {"Image/imgres/common/yuanbao.png", },
    id_3 = {"Image/imgres/common/tili.png", },
    id_4 = {"Image/imgres/common/naili.png", },
    id_5 = {"Image/imgres/common/userexp.png", },
    id_6 = {"Image/imgres/common/heroexp.png", },
    id_9 = {"Image/imgres/common/biwumoney.png", },
    id_10 = {"Image/imgres/common/contribute.png", },
    id_12 = {"Image/imgres/common/corpscion.png", },
    id_13 = {"Image/imgres/common/corpsmoney.png", },
    id_17 = {"Image/imgres/common/xh.png", },
    id_30 = {"Image/imgres/equip/icon/jindan/JDan00.png", },
    id_31 = {"Image/imgres/equip/icon/jindan/JDan01.png", },
    id_32 = {"Image/imgres/equip/icon/jindan/JDan02.png", },
    id_33 = {"Image/imgres/equip/icon/jindan/JDan03.png", },
    id_34 = {"Image/imgres/equip/icon/jindan/JDan04.png", },
    id_35 = {"Image/imgres/equip/icon/jindan/JDan05.png", },
    id_36 = {"Image/imgres/equip/icon/jindan/JDan06.png", },
    id_37 = {"Image/imgres/equip/icon/jindan/JDan07.png", },
    id_38 = {"Image/imgres/equip/icon/jindan/JDan08.png", },
    id_39 = {"Image/imgres/equip/icon/jindan/JDan09.png", },
    id_40 = {"Image/imgres/equip/icon/jindan/JDan10.png", },
    id_50 = {"Image/imgres/wujiang/warrior.png", },
    id_51 = {"Image/imgres/wujiang/zhj_1.png", },
    id_52 = {"Image/imgres/wujiang/zhj_2.png", },
    id_53 = {"Image/imgres/wujiang/zhj_3.png", },
    id_54 = {"Image/imgres/wujiang/zhj_4.png", },
    id_55 = {"Image/imgres/wujiang/mage.png", },
    id_56 = {"Image/imgres/wujiang/zhj_1.png", },
    id_57 = {"Image/imgres/wujiang/zhj_2.png", },
    id_58 = {"Image/imgres/wujiang/zhj_3.png", },
    id_59 = {"Image/imgres/wujiang/zhj_4.png", },
    id_60 = {"Image/imgres/wujiang/archer.png", },
    id_61 = {"Image/imgres/wujiang/zhj_1.png", },
    id_62 = {"Image/imgres/wujiang/zhj_2.png", },
    id_63 = {"Image/imgres/wujiang/zhj_3.png", },
    id_64 = {"Image/imgres/wujiang/zhj_4.png", },
    id_141 = {"Image/imgres/hero/head_icon/man1.png", },
    id_142 = {"Image/imgres/hero/head_icon/man2.png", },
    id_143 = {"Image/imgres/hero/head_icon/man3.png", },
    id_144 = {"Image/imgres/hero/head_icon/wm1.png", },
    id_145 = {"Image/imgres/hero/head_icon/wm2.png", },
    id_146 = {"Image/imgres/hero/head_icon/wm3.png", },
    id_147 = {"Image/imgres/hero/head_icon/vip_pes1.png", },
    id_148 = {"Image/imgres/hero/head_icon/vip_pes2.png", },
    id_149 = {"Image/imgres/hero/head_icon/vip_pes3.png", },
    id_150 = {"Image/imgres/hero/head_icon/bw_man1.png", },
    id_151 = {"Image/imgres/hero/head_icon/bw_wm1.png", },
    id_201 = {"Image/imgres/equip/icon/daojv/item001.png", },
    id_202 = {"Image/imgres/equip/icon/daojv/item002.png", },
    id_203 = {"Image/imgres/equip/icon/daojv/item003.png", },
    id_204 = {"Image/imgres/equip/icon/daojv/item004.png", },
    id_205 = {"Image/imgres/equip/icon/daojv/item005.png", },
    id_206 = {"Image/imgres/equip/icon/daojv/item006.png", },
    id_207 = {"Image/imgres/equip/icon/daojv/item007.png", },
    id_208 = {"Image/imgres/equip/icon/daojv/item008.png", },
    id_209 = {"Image/imgres/equip/icon/daojv/item009.png", },
    id_210 = {"Image/imgres/equip/icon/daojv/item010.png", },
    id_211 = {"Image/imgres/equip/icon/daojv/item011.png", },
    id_212 = {"Image/imgres/equip/icon/daojv/item012.png", },
    id_213 = {"Image/imgres/equip/icon/daojv/item013.png", },
    id_214 = {"Image/imgres/equip/icon/daojv/item014.png", },
    id_215 = {"Image/imgres/equip/icon/daojv/item015.png", },
    id_216 = {"Image/imgres/equip/icon/daojv/item016.png", },
    id_217 = {"Image/imgres/equip/icon/daojv/item017.png", },
    id_218 = {"Image/imgres/equip/icon/daojv/item018.png", },
    id_219 = {"Image/imgres/equip/icon/daojv/item019.png", },
    id_220 = {"Image/imgres/equip/icon/daojv/item020.png", },
    id_221 = {"Image/imgres/equip/icon/daojv/item021.png", },
    id_222 = {"Image/imgres/equip/icon/daojv/item037.png", },
    id_223 = {"Image/imgres/equip/icon/daojv/item022.png", },
    id_224 = {"Image/imgres/equip/icon/daojv/item023.png", },
    id_225 = {"Image/imgres/equip/icon/daojv/item024.png", },
    id_226 = {"Image/imgres/equip/icon/daojv/item025.png", },
    id_227 = {"Image/imgres/equip/icon/daojv/item026.png", },
    id_228 = {"Image/imgres/equip/icon/daojv/item027.png", },
    id_229 = {"Image/imgres/equip/icon/daojv/item028.png", },
    id_230 = {"Image/imgres/equip/icon/daojv/item029.png", },
    id_231 = {"Image/imgres/equip/icon/daojv/item030.png", },
    id_232 = {"Image/imgres/equip/icon/daojv/item031.png", },
    id_233 = {"Image/imgres/equip/icon/daojv/item032.png", },
    id_234 = {"Image/imgres/equip/icon/daojv/item033.png", },
    id_235 = {"Image/imgres/equip/icon/daojv/item034.png", },
    id_236 = {"Image/imgres/equip/icon/daojv/item035.png", },
    id_237 = {"Image/imgres/equip/icon/daojv/item036.png", },
    id_238 = {"Image/imgres/equip/icon/daojv/item038.png", },
    id_239 = {"Image/imgres/equip/icon/daojv/item039.png", },
    id_240 = {"Image/imgres/equip/icon/daojv/item040.png", },
    id_241 = {"Image/imgres/equip/icon/daojv/item041.png", },
    id_242 = {"Image/imgres/equip/icon/daojv/item042.png", },
    id_243 = {"Image/imgres/equip/icon/daojv/item043.png", },
    id_244 = {"Image/imgres/equip/icon/daojv/item044.png", },
    id_292 = {"Image/imgres/equip/icon/lihe/lh02.png", },
    id_293 = {"Image/imgres/equip/icon/lihe/lh03.png", },
    id_294 = {"Image/imgres/equip/icon/lihe/lh04.png", },
    id_295 = {"Image/imgres/equip/icon/lihe/lh05.png", },
    id_296 = {"Image/imgres/equip/icon/lihe/lh06.png", },
    id_297 = {"Image/imgres/equip/icon/lihe/lh07.png", },
    id_298 = {"Image/imgres/equip/icon/lihe/lh08.png", },
    id_299 = {"Image/imgres/equip/icon/lihe/lh09.png", },
    id_300 = {"Image/imgres/equip/icon/lihe/lh10.png", },
    id_301 = {"Image/imgres/equip/icon/danyao/fan/DYao00.png", },
    id_302 = {"Image/imgres/equip/icon/danyao/fan/DYao01.png", },
    id_303 = {"Image/imgres/equip/icon/danyao/fan/DYao02.png", },
    id_304 = {"Image/imgres/equip/icon/danyao/fan/DYao03.png", },
    id_305 = {"Image/imgres/equip/icon/danyao/fan/DYao04.png", },
    id_306 = {"Image/imgres/equip/icon/danyao/fan/DYao05.png", },
    id_307 = {"Image/imgres/equip/icon/danyao/fan/DYao06.png", },
    id_308 = {"Image/imgres/equip/icon/danyao/fan/DYao07.png", },
    id_309 = {"Image/imgres/equip/icon/danyao/fan/DYao08.png", },
    id_311 = {"Image/imgres/equip/icon/danyao/1/DYao09.png", },
    id_312 = {"Image/imgres/equip/icon/danyao/1/DYao10.png", },
    id_313 = {"Image/imgres/equip/icon/danyao/1/DYao11.png", },
    id_314 = {"Image/imgres/equip/icon/danyao/1/DYao12.png", },
    id_315 = {"Image/imgres/equip/icon/danyao/1/DYao13.png", },
    id_316 = {"Image/imgres/equip/icon/danyao/1/DYao14.png", },
    id_317 = {"Image/imgres/equip/icon/danyao/1/DYao15.png", },
    id_318 = {"Image/imgres/equip/icon/danyao/1/DYao16.png", },
    id_319 = {"Image/imgres/equip/icon/danyao/1/DYao17.png", },
    id_321 = {"Image/imgres/equip/icon/danyao/2/DYao18.png", },
    id_322 = {"Image/imgres/equip/icon/danyao/2/DYao19.png", },
    id_323 = {"Image/imgres/equip/icon/danyao/2/DYao20.png", },
    id_324 = {"Image/imgres/equip/icon/danyao/2/DYao21.png", },
    id_325 = {"Image/imgres/equip/icon/danyao/2/DYao22.png", },
    id_326 = {"Image/imgres/equip/icon/danyao/2/DYao23.png", },
    id_327 = {"Image/imgres/equip/icon/danyao/2/DYao24.png", },
    id_328 = {"Image/imgres/equip/icon/danyao/2/DYao25.png", },
    id_329 = {"Image/imgres/equip/icon/danyao/2/DYao26.png", },
    id_331 = {"Image/imgres/equip/icon/danyao/3/DYao27.png", },
    id_332 = {"Image/imgres/equip/icon/danyao/3/DYao28.png", },
    id_333 = {"Image/imgres/equip/icon/danyao/3/DYao29.png", },
    id_334 = {"Image/imgres/equip/icon/danyao/3/DYao30.png", },
    id_335 = {"Image/imgres/equip/icon/danyao/3/DYao31.png", },
    id_336 = {"Image/imgres/equip/icon/danyao/3/DYao32.png", },
    id_337 = {"Image/imgres/equip/icon/danyao/3/DYao33.png", },
    id_338 = {"Image/imgres/equip/icon/danyao/3/DYao34.png", },
    id_339 = {"Image/imgres/equip/icon/danyao/3/DYao35.png", },
    id_341 = {"Image/imgres/equip/icon/danyao/4/DYao36.png", },
    id_342 = {"Image/imgres/equip/icon/danyao/4/DYao37.png", },
    id_343 = {"Image/imgres/equip/icon/danyao/4/DYao38.png", },
    id_344 = {"Image/imgres/equip/icon/danyao/4/DYao39.png", },
    id_345 = {"Image/imgres/equip/icon/danyao/4/DYao40.png", },
    id_346 = {"Image/imgres/equip/icon/danyao/4/DYao41.png", },
    id_347 = {"Image/imgres/equip/icon/danyao/4/DYao42.png", },
    id_348 = {"Image/imgres/equip/icon/danyao/4/DYao43.png", },
    id_349 = {"Image/imgres/equip/icon/danyao/4/DYao44.png", },
    id_351 = {"Image/imgres/equip/icon/danyao/5/DYao45.png", },
    id_352 = {"Image/imgres/equip/icon/danyao/5/DYao46.png", },
    id_353 = {"Image/imgres/equip/icon/danyao/5/DYao47.png", },
    id_354 = {"Image/imgres/equip/icon/danyao/5/DYao48.png", },
    id_355 = {"Image/imgres/equip/icon/danyao/5/DYao49.png", },
    id_356 = {"Image/imgres/equip/icon/danyao/5/DYao50.png", },
    id_357 = {"Image/imgres/equip/icon/danyao/5/DYao51.png", },
    id_358 = {"Image/imgres/equip/icon/danyao/5/DYao52.png", },
    id_359 = {"Image/imgres/equip/icon/danyao/5/DYao53.png", },
    id_361 = {"Image/imgres/equip/icon/danyao/6/DYao54.png", },
    id_362 = {"Image/imgres/equip/icon/danyao/6/DYao55.png", },
    id_363 = {"Image/imgres/equip/icon/danyao/6/DYao56.png", },
    id_364 = {"Image/imgres/equip/icon/danyao/6/DYao57.png", },
    id_365 = {"Image/imgres/equip/icon/danyao/6/DYao58.png", },
    id_366 = {"Image/imgres/equip/icon/danyao/6/DYao59.png", },
    id_367 = {"Image/imgres/equip/icon/danyao/6/DYao60.png", },
    id_368 = {"Image/imgres/equip/icon/danyao/6/DYao61.png", },
    id_369 = {"Image/imgres/equip/icon/danyao/6/DYao62.png", },
    id_371 = {"Image/imgres/equip/icon/danyao/7/DYao63.png", },
    id_372 = {"Image/imgres/equip/icon/danyao/7/DYao64.png", },
    id_373 = {"Image/imgres/equip/icon/danyao/7/DYao65.png", },
    id_374 = {"Image/imgres/equip/icon/danyao/7/DYao66.png", },
    id_375 = {"Image/imgres/equip/icon/danyao/7/DYao67.png", },
    id_376 = {"Image/imgres/equip/icon/danyao/7/DYao68.png", },
    id_377 = {"Image/imgres/equip/icon/danyao/7/DYao69.png", },
    id_378 = {"Image/imgres/equip/icon/danyao/7/DYao70.png", },
    id_379 = {"Image/imgres/equip/icon/danyao/7/DYao71.png", },
    id_381 = {"Image/imgres/equip/icon/danyao/8/DYao72.png", },
    id_382 = {"Image/imgres/equip/icon/danyao/8/DYao73.png", },
    id_383 = {"Image/imgres/equip/icon/danyao/8/DYao74.png", },
    id_384 = {"Image/imgres/equip/icon/danyao/8/DYao75.png", },
    id_385 = {"Image/imgres/equip/icon/danyao/8/DYao76.png", },
    id_386 = {"Image/imgres/equip/icon/danyao/8/DYao77.png", },
    id_387 = {"Image/imgres/equip/icon/danyao/8/DYao78.png", },
    id_388 = {"Image/imgres/equip/icon/danyao/8/DYao79.png", },
    id_389 = {"Image/imgres/equip/icon/danyao/8/DYao80.png", },
    id_391 = {"Image/imgres/equip/icon/danyao/9/DYao81.png", },
    id_392 = {"Image/imgres/equip/icon/danyao/9/DYao82.png", },
    id_393 = {"Image/imgres/equip/icon/danyao/9/DYao83.png", },
    id_394 = {"Image/imgres/equip/icon/danyao/9/DYao84.png", },
    id_395 = {"Image/imgres/equip/icon/danyao/9/DYao85.png", },
    id_396 = {"Image/imgres/equip/icon/danyao/9/DYao86.png", },
    id_397 = {"Image/imgres/equip/icon/danyao/9/DYao87.png", },
    id_398 = {"Image/imgres/equip/icon/danyao/9/DYao88.png", },
    id_399 = {"Image/imgres/equip/icon/danyao/9/DYao89.png", },
    id_401 = {"Image/imgres/equip/icon/danyao/xian/DYao90.png", },
    id_402 = {"Image/imgres/equip/icon/danyao/xian/DYao91.png", },
    id_403 = {"Image/imgres/equip/icon/danyao/xian/DYao92.png", },
    id_404 = {"Image/imgres/equip/icon/danyao/xian/DYao93.png", },
    id_405 = {"Image/imgres/equip/icon/danyao/xian/DYao94.png", },
    id_406 = {"Image/imgres/equip/icon/danyao/xian/DYao95.png", },
    id_407 = {"Image/imgres/equip/icon/danyao/xian/DYao96.png", },
    id_408 = {"Image/imgres/equip/icon/danyao/xian/DYao97.png", },
    id_409 = {"Image/imgres/equip/icon/danyao/xian/DYao98.png", },
    id_1011 = {"Image/imgres/equip/icon/pei/Pei01.png", },
    id_1012 = {"Image/imgres/equip/icon/jia/Jia01.png", },
    id_1013 = {"Image/imgres/equip/icon/kui/Kui01.png", },
    id_1014 = {"Image/imgres/equip/icon/xue/Xue01.png", },
    id_1021 = {"Image/imgres/equip/icon/pei/Pei02.png", },
    id_1022 = {"Image/imgres/equip/icon/jia/Jia02.png", },
    id_1023 = {"Image/imgres/equip/icon/kui/Kui02.png", },
    id_1024 = {"Image/imgres/equip/icon/xue/Xue02.png", },
    id_1031 = {"Image/imgres/equip/icon/pei/Pei03.png", },
    id_1032 = {"Image/imgres/equip/icon/jia/Jia03.png", },
    id_1033 = {"Image/imgres/equip/icon/kui/Kui03.png", },
    id_1034 = {"Image/imgres/equip/icon/xue/Xue03.png", },
    id_1041 = {"Image/imgres/equip/icon/pei/Pei04.png", },
    id_1042 = {"Image/imgres/equip/icon/jia/Jia04.png", },
    id_1043 = {"Image/imgres/equip/icon/kui/Kui04.png", },
    id_1044 = {"Image/imgres/equip/icon/xue/Xue04.png", },
    id_2051 = {"Image/imgres/equip/icon/pei/Pei05.png", },
    id_2052 = {"Image/imgres/equip/icon/jia/Jia05.png", },
    id_2053 = {"Image/imgres/equip/icon/kui/Kui05.png", },
    id_2054 = {"Image/imgres/equip/icon/xue/Xue05.png", },
    id_1061 = {"Image/imgres/equip/icon/pei/Pei06.png", },
    id_1062 = {"Image/imgres/equip/icon/jia/Jia06.png", },
    id_1063 = {"Image/imgres/equip/icon/kui/Kui06.png", },
    id_1064 = {"Image/imgres/equip/icon/xue/Xue06.png", },
    id_1071 = {"Image/imgres/equip/icon/pei/Pei07.png", },
    id_1072 = {"Image/imgres/equip/icon/jia/Jia07.png", },
    id_1073 = {"Image/imgres/equip/icon/kui/Kui07.png", },
    id_1074 = {"Image/imgres/equip/icon/xue/Xue07.png", },
    id_1081 = {"Image/imgres/equip/icon/pei/Pei08.png", },
    id_1082 = {"Image/imgres/equip/icon/jia/Jia08.png", },
    id_1083 = {"Image/imgres/equip/icon/kui/Kui08.png", },
    id_1084 = {"Image/imgres/equip/icon/xue/Xue08.png", },
    id_2091 = {"Image/imgres/equip/icon/pei/Pei09.png", },
    id_2092 = {"Image/imgres/equip/icon/jia/Jia09.png", },
    id_2093 = {"Image/imgres/equip/icon/kui/Kui09.png", },
    id_2094 = {"Image/imgres/equip/icon/xue/Xue09.png", },
    id_2101 = {"Image/imgres/equip/icon/pei/Pei10.png", },
    id_2102 = {"Image/imgres/equip/icon/jia/Jia10.png", },
    id_2103 = {"Image/imgres/equip/icon/kui/Kui10.png", },
    id_2104 = {"Image/imgres/equip/icon/xue/Xue10.png", },
    id_1111 = {"Image/imgres/equip/icon/pei/Pei11.png", },
    id_1112 = {"Image/imgres/equip/icon/jia/Jia11.png", },
    id_1113 = {"Image/imgres/equip/icon/kui/Kui11.png", },
    id_1114 = {"Image/imgres/equip/icon/xue/Xue11.png", },
    id_1121 = {"Image/imgres/equip/icon/pei/Pei12.png", },
    id_1122 = {"Image/imgres/equip/icon/jia/Jia12.png", },
    id_1123 = {"Image/imgres/equip/icon/kui/Kui12.png", },
    id_1124 = {"Image/imgres/equip/icon/xue/Xue12.png", },
    id_1131 = {"Image/imgres/equip/icon/pei/Pei13.png", },
    id_1132 = {"Image/imgres/equip/icon/jia/Jia13.png", },
    id_1133 = {"Image/imgres/equip/icon/kui/Kui13.png", },
    id_1134 = {"Image/imgres/equip/icon/xue/Xue13.png", },
    id_2141 = {"Image/imgres/equip/icon/pei/Pei14.png", },
    id_2142 = {"Image/imgres/equip/icon/jia/Jia14.png", },
    id_2143 = {"Image/imgres/equip/icon/kui/Kui14.png", },
    id_2144 = {"Image/imgres/equip/icon/xue/Xue14.png", },
    id_2151 = {"Image/imgres/equip/icon/pei/Pei15.png", },
    id_2152 = {"Image/imgres/equip/icon/jia/Jia15.png", },
    id_2153 = {"Image/imgres/equip/icon/kui/Kui15.png", },
    id_2154 = {"Image/imgres/equip/icon/xue/Xue15.png", },
    id_1161 = {"Image/imgres/equip/icon/pei/Pei16.png", },
    id_1162 = {"Image/imgres/equip/icon/jia/Jia16.png", },
    id_1163 = {"Image/imgres/equip/icon/kui/Kui16.png", },
    id_1164 = {"Image/imgres/equip/icon/xue/Xue16.png", },
    id_3199 = {"Image/imgres/equip/icon/wu/Wu19.png", },
    id_3200 = {"Image/imgres/equip/icon/wu/Wu00.png", },
    id_3201 = {"Image/imgres/equip/icon/wu/Wu01.png", },
    id_3202 = {"Image/imgres/equip/icon/wu/Wu02.png", },
    id_3211 = {"Image/imgres/equip/icon/wu/Wu03.png", },
    id_3212 = {"Image/imgres/equip/icon/wu/Wu04.png", },
    id_3213 = {"Image/imgres/equip/icon/wu/Wu05.png", },
    id_3214 = {"Image/imgres/equip/icon/wu/Wu06.png", },
    id_3221 = {"Image/imgres/equip/icon/wu/Wu07.png", },
    id_3222 = {"Image/imgres/equip/icon/wu/Wu08.png", },
    id_3231 = {"Image/imgres/equip/icon/wu/Wu09.png", },
    id_3232 = {"Image/imgres/equip/icon/wu/Wu10.png", },
    id_3233 = {"Image/imgres/equip/icon/wu/Wu11.png", },
    id_3234 = {"Image/imgres/equip/icon/wu/Wu12.png", },
    id_3241 = {"Image/imgres/equip/icon/wu/Wu13.png", },
    id_3242 = {"Image/imgres/equip/icon/wu/Wu14.png", },
    id_3243 = {"Image/imgres/equip/icon/wu/Wu15.png", },
    id_3244 = {"Image/imgres/equip/icon/wu/Wu16.png", },
    id_3245 = {"Image/imgres/equip/icon/wu/Wu17.png", },
    id_3246 = {"Image/imgres/equip/icon/wu/Wu18.png", },
    id_4199 = {"Image/imgres/equip/icon/ma/Ma19.png", },
    id_4200 = {"Image/imgres/equip/icon/ma/Ma00.png", },
    id_4201 = {"Image/imgres/equip/icon/ma/Ma01.png", },
    id_4202 = {"Image/imgres/equip/icon/ma/Ma02.png", },
    id_4211 = {"Image/imgres/equip/icon/ma/Ma03.png", },
    id_4212 = {"Image/imgres/equip/icon/ma/Ma04.png", },
    id_4213 = {"Image/imgres/equip/icon/ma/Ma05.png", },
    id_4214 = {"Image/imgres/equip/icon/ma/Ma06.png", },
    id_4221 = {"Image/imgres/equip/icon/ma/Ma07.png", },
    id_4222 = {"Image/imgres/equip/icon/ma/Ma08.png", },
    id_4231 = {"Image/imgres/equip/icon/ma/Ma09.png", },
    id_4232 = {"Image/imgres/equip/icon/ma/Ma10.png", },
    id_4233 = {"Image/imgres/equip/icon/ma/Ma11.png", },
    id_4234 = {"Image/imgres/equip/icon/ma/Ma12.png", },
    id_4241 = {"Image/imgres/equip/icon/ma/Ma13.png", },
    id_4242 = {"Image/imgres/equip/icon/ma/Ma14.png", },
    id_4243 = {"Image/imgres/equip/icon/ma/Ma15.png", },
    id_4244 = {"Image/imgres/equip/icon/ma/Ma16.png", },
    id_4245 = {"Image/imgres/equip/icon/ma/Ma17.png", },
    id_4246 = {"Image/imgres/equip/icon/ma/Ma18.png", },
    id_5301 = {"Image/imgres/equip/icon/lingbao/di/Bao01.png", },
    id_5302 = {"Image/imgres/equip/icon/lingbao/di/Bao02.png", },
    id_5303 = {"Image/imgres/equip/icon/lingbao/di/Bao03.png", },
    id_5304 = {"Image/imgres/equip/icon/lingbao/di/Bao04.png", },
    id_5305 = {"Image/imgres/equip/icon/lingbao/di/Bao05.png", },
    id_5306 = {"Image/imgres/equip/icon/lingbao/di/Bao06.png", },
    id_5311 = {"Image/imgres/equip/icon/lingbao/tian/Bao07.png", },
    id_5312 = {"Image/imgres/equip/icon/lingbao/tian/Bao08.png", },
    id_5313 = {"Image/imgres/equip/icon/lingbao/tian/Bao09.png", },
    id_5314 = {"Image/imgres/equip/icon/lingbao/tian/Bao10.png", },
    id_5315 = {"Image/imgres/equip/icon/lingbao/tian/Bao11.png", },
    id_5316 = {"Image/imgres/equip/icon/lingbao/tian/Bao12.png", },
    id_5321 = {"Image/imgres/equip/icon/lingbao/huang/Bao13.png", },
    id_5322 = {"Image/imgres/equip/icon/lingbao/huang/Bao14.png", },
    id_5323 = {"Image/imgres/equip/icon/lingbao/huang/Bao15.png", },
    id_5324 = {"Image/imgres/equip/icon/lingbao/huang/Bao16.png", },
    id_5325 = {"Image/imgres/equip/icon/lingbao/huang/Bao17.png", },
    id_5326 = {"Image/imgres/equip/icon/lingbao/huang/Bao18.png", },
    id_5331 = {"Image/imgres/equip/icon/lingbao/xuan/Bao19.png", },
    id_5332 = {"Image/imgres/equip/icon/lingbao/xuan/Bao20.png", },
    id_5333 = {"Image/imgres/equip/icon/lingbao/xuan/Bao21.png", },
    id_5334 = {"Image/imgres/equip/icon/lingbao/xuan/Bao22.png", },
    id_5335 = {"Image/imgres/equip/icon/lingbao/xuan/Bao23.png", },
    id_5336 = {"Image/imgres/equip/icon/lingbao/xuan/Bao24.png", },
    id_5341 = {"Image/imgres/equip/icon/lingbao/ling/Bao25.png", },
    id_5342 = {"Image/imgres/equip/icon/lingbao/ling/Bao26.png", },
    id_5343 = {"Image/imgres/equip/icon/lingbao/ling/Bao27.png", },
    id_5344 = {"Image/imgres/equip/icon/lingbao/ling/Bao28.png", },
    id_5345 = {"Image/imgres/equip/icon/lingbao/ling/Bao29.png", },
    id_5346 = {"Image/imgres/equip/icon/lingbao/ling/Bao30.png", },
    id_5351 = {"Image/imgres/equip/icon/lingbao/xian/Bao31.png", },
    id_5352 = {"Image/imgres/equip/icon/lingbao/xian/Bao32.png", },
    id_5353 = {"Image/imgres/equip/icon/lingbao/xian/Bao33.png", },
    id_5354 = {"Image/imgres/equip/icon/lingbao/xian/Bao34.png", },
    id_5355 = {"Image/imgres/equip/icon/lingbao/xian/Bao35.png", },
    id_5356 = {"Image/imgres/equip/icon/lingbao/xian/Bao36.png", },
    id_80011 = {"Image/imgres/hero/head_icon/nanzhujue_zs_1.png", },
    id_80012 = {"Image/imgres/hero/head_icon/nanzhujue_zs_2.png", },
    id_80013 = {"Image/imgres/hero/head_icon/nanzhujue_zs_3.png", },
    id_80021 = {"Image/imgres/hero/head_icon/nanzhujue_ms_1.png", },
    id_80032 = {"Image/imgres/hero/head_icon/nanzhujue_ms_2.png", },
    id_80043 = {"Image/imgres/hero/head_icon/nanzhujue_ms_3.png", },
    id_80031 = {"Image/imgres/hero/head_icon/nanzhujue_gs_1.png", },
    id_80042 = {"Image/imgres/hero/head_icon/nanzhujue_gs_2.png", },
    id_80053 = {"Image/imgres/hero/head_icon/nanzhujue_gs_3.png", },
    id_81011 = {"Image/imgres/hero/head_icon/nvzhujue_zs_1.png", },
    id_81012 = {"Image/imgres/hero/head_icon/nvzhujue_zs_2.png", },
    id_81013 = {"Image/imgres/hero/head_icon/nvzhujue_zs_3.png", },
    id_81021 = {"Image/imgres/hero/head_icon/nvzhujue_ms_1.png", },
    id_81032 = {"Image/imgres/hero/head_icon/nvzhujue_ms_2.png", },
    id_81043 = {"Image/imgres/hero/head_icon/nvzhujue_ms_3.png", },
    id_81031 = {"Image/imgres/hero/head_icon/nvzhujue_gs_1.png", },
    id_81042 = {"Image/imgres/hero/head_icon/nvzhujue_gs_2.png", },
    id_81053 = {"Image/imgres/hero/head_icon/nvzhujue_gs_3.png", },
    id_6001 = {"Image/imgres/hero/head_icon/touxiang_diaochan01.png", },
    id_6002 = {"Image/imgres/hero/head_icon/touxiang_guanyu.png", },
    id_6003 = {"Image/imgres/hero/head_icon/touxiang_zhaoyun.png", },
    id_6004 = {"Image/imgres/hero/head_icon/touxiang_ganning.png", },
    id_6005 = {"Image/imgres/hero/head_icon/touxiang_lvbu.png", },
    id_6006 = {"Image/imgres/hero/head_icon/touxiang_machao.png", },
    id_6007 = {"Image/imgres/hero/head_icon/touxiang_huatuo.png", },
    id_6008 = {"Image/imgres/hero/head_icon/touxiang_caoren.png", },
    id_6009 = {"Image/imgres/hero/head_icon/touxiang_caocao.png", },
    id_6010 = {"Image/imgres/hero/head_icon/touxiang_dianwei.png", },
    id_6011 = {"Image/imgres/hero/head_icon/touxiang_dongzhuo.png", },
    id_6012 = {"Image/imgres/hero/head_icon/touxiang_zhangfei.png", },
    id_6013 = {"Image/imgres/hero/head_icon/touxiang_zhugeliang.png", },
    id_6014 = {"Image/imgres/hero/head_icon/touxiang_daqiao.png", },
    id_6015 = {"Image/imgres/hero/head_icon/touxiang_xiaoqiao.png", },
    id_6016 = {"Image/imgres/hero/head_icon/touxiang_zhurong.png", },
    id_6017 = {"Image/imgres/hero/head_icon/touxiang_huanggai.png", },
    id_6018 = {"Image/imgres/hero/head_icon/touxiang_zhangjiao.png", },
    id_6019 = {"Image/imgres/hero/head_icon/touxiang_taishici.png", },
    id_6020 = {"Image/imgres/hero/head_icon/touxiang_zhanghe.png", },
    id_6021 = {"Image/imgres/hero/head_icon/touxiang_huaxiong.png", },
    id_6022 = {"Image/imgres/hero/head_icon/touxiang_liru.png", },
    id_6023 = {"Image/imgres/hero/head_icon/touxiang_jiaxu.png", },
    id_6024 = {"Image/imgres/hero/head_icon/touxiang_menghuo.png", },
    id_6025 = {"Image/imgres/hero/head_icon/touxiang_liubei.png", },
    id_6026 = {"Image/imgres/hero/head_icon/touxiang_gaoshun.png", },
    id_6027 = {"Image/imgres/hero/head_icon/touxiang_chengong.png", },
    id_6028 = {"Image/imgres/hero/head_icon/touxiang_xuhuang.png", },
    id_6029 = {"Image/imgres/hero/head_icon/touxiang_yujin.png", },
    id_6030 = {"Image/imgres/hero/head_icon/touxiang_guojia.png", },
    id_6031 = {"Image/imgres/hero/head_icon/touxiang_zhouyu.png", },
    id_6032 = {"Image/imgres/hero/head_icon/touxiang_lvmeng.png", },
    id_6033 = {"Image/imgres/hero/head_icon/touxiang_lusu.png", },
    id_6034 = {"Image/imgres/hero/head_icon/touxiang_zhoutai.png", },
    id_6035 = {"Image/imgres/hero/head_icon/touxiang_luxun.png", },
    id_6036 = {"Image/imgres/hero/head_icon/touxiang_zhangliao.png", },
    id_6037 = {"Image/imgres/hero/head_icon/touxiang_lingtong.png", },
    id_6038 = {"Image/imgres/hero/head_icon/touxiang_sunshangxiang.png", },
    id_6039 = {"Image/imgres/hero/head_icon/touxiang_huangyueying.png", },
    id_6040 = {"Image/imgres/hero/head_icon/touxiang_zhenji.png", },
    id_6041 = {"Image/imgres/hero/head_icon/touxiang_maliang.png", },
    id_6042 = {"Image/imgres/hero/head_icon/touxiang_simayi.png", },
    id_6043 = {"Image/imgres/hero/head_icon/touxiang_sunquan.png", },
    id_6044 = {"Image/imgres/hero/head_icon/touxiang_xiahoudun.png", },
    id_6045 = {"Image/imgres/hero/head_icon/touxiang_xuchu.png", },
    id_6046 = {"Image/imgres/hero/head_icon/touxiang_daqiao01.png", },
    id_6047 = {"Image/imgres/hero/head_icon/touxiang_xiaoqiao01.png", },
    id_6048 = {"Image/imgres/hero/head_icon/touxiang_weiyan.png", },
    id_6049 = {"Image/imgres/hero/head_icon/touxiang_yuji.png", },
    id_6050 = {"Image/imgres/hero/head_icon/touxiang_yuanshao.png", },
    id_6100 = {"Image/imgres/hero/head_icon/touxiang_toushiche.png", },
    id_6101 = {"Image/imgres/hero/head_icon/touxiang_dunbing.png", },
    id_6102 = {"Image/imgres/hero/head_icon/touxiang_qiangbing.png", },
    id_6103 = {"Image/imgres/hero/head_icon/touxiang_pushanbing.png", },
    id_6104 = {"Image/imgres/hero/head_icon/touxiang_jigushou.png", },
    id_6105 = {"Image/imgres/hero/head_icon/touxiang_daobing.png", },
    id_6106 = {"Image/imgres/hero/head_icon/touxiang_gongbing.png", },
    id_6107 = {"Image/imgres/hero/head_icon/touxiang_yiliaobing.png", },
    id_6108 = {"Image/imgres/hero/head_icon/touxiang_yanlang.png", },
    id_6109 = {"Image/imgres/hero/head_icon/touxiang_maoxiang.png", },
    id_6110 = {"Image/imgres/hero/head_icon/touxiang_fuzhouxiong.png", },
    id_6111 = {"Image/imgres/hero/head_icon/touxiang_zhanbao.png", },
    id_6112 = {"Image/imgres/hero/head_icon/touxiang_houshi.png", },
    id_6113 = {"Image/imgres/hero/head_icon/touxiang_jiguanbing.png", },
    id_6114 = {"Image/imgres/hero/head_icon/touxiang_hongzhaji.png", },
    id_6115 = {"Image/imgres/hero/head_icon/touxiang_wajueji.png", },
    id_6116 = {"Image/imgres/hero/head_icon/touxiang_nuche.png", },
    id_6117 = {"Image/imgres/hero/head_icon/touxiang_sunquan.png", },
    id_6118 = {"Image/imgres/hero/head_icon/touxiang_luxun.png", },
    id_6119 = {"Image/imgres/hero/head_icon/touxiang_jiaxu.png", },
    id_6120 = {"Image/imgres/hero/head_icon/touxiang_lusu.png", },
    id_6121 = {"Image/imgres/hero/head_icon/touxiang_taishici.png", },
    id_6200 = {"Image/imgres/hero/head_icon/touxiang_dunbing.png", },
    id_6201 = {"Image/imgres/hero/head_icon/touxiang_qiangbing.png", },
    id_6202 = {"Image/imgres/hero/head_icon/touxiang_pushanbing.png", },
    id_6203 = {"Image/imgres/hero/head_icon/touxiang_jigushou.png", },
    id_6204 = {"Image/imgres/hero/head_icon/touxiang_daobing.png", },
    id_6205 = {"Image/imgres/hero/head_icon/touxiang_gongbing.png", },
    id_6206 = {"Image/imgres/hero/head_icon/touxiang_yiliaobing.png", },
    id_6207 = {"Image/imgres/hero/head_icon/touxiang_yanlang.png", },
    id_6208 = {"Image/imgres/hero/head_icon/touxiang_maoxiang.png", },
    id_6209 = {"Image/imgres/hero/head_icon/touxiang_fuzhouxiong.png", },
    id_6210 = {"Image/imgres/hero/head_icon/touxiang_zhanbao.png", },
    id_6211 = {"Image/imgres/hero/head_icon/touxiang_houshi.png", },
    id_6212 = {"Image/imgres/hero/head_icon/touxiang_toushiche.png", },
    id_6213 = {"Image/imgres/hero/head_icon/touxiang_jiguanbing.png", },
    id_6214 = {"Image/imgres/hero/head_icon/touxiang_hongzhaji.png", },
    id_6215 = {"Image/imgres/hero/head_icon/touxiang_wajueji.png", },
    id_6216 = {"Image/imgres/hero/head_icon/touxiang_nuche.png", },
    id_6217 = {"Image/imgres/hero/head_icon/touxiang_sunquan.png", },
    id_6218 = {"Image/imgres/hero/head_icon/touxiang_luxun.png", },
    id_6219 = {"Image/imgres/hero/head_icon/touxiang_jiaxu.png", },
    id_6220 = {"Image/imgres/hero/head_icon/touxiang_lusu.png", },
    id_6221 = {"Image/imgres/hero/head_icon/touxiang_taishici.png", },
    id_7001 = {"Image/imgres/hero/head_icon/touxiang_hufalong.png", },
    id_7002 = {"Image/imgres/hero/head_icon/touxiang_huajing.png", },
    id_7003 = {"Image/imgres/hero/head_icon/touxiang_hufazhu.png", },
    id_7004 = {"Image/imgres/hero/head_icon/touxiang_hufanvshen.png", },
    id_7005 = {"Image/imgres/hero/head_icon/touxiang_hufasishen.png", },
    id_7006 = {"Image/imgres/hero/head_icon/touxiang_hufananshen.png", },
    id_8001 = {"Image/imgres/mission/missionState_1.png", },
    id_8002 = {"Image/imgres/mission/missionState_2.png", },
    id_8003 = {"Image/imgres/mission/missionState_3.png", },
    id_8004 = {"Image/imgres/mission/missionState_4.png", },
    id_8005 = {"Image/imgres/mission/missionState_5.png", },
    id_8006 = {"Image/imgres/mission/missionState_6.png", },
    id_8007 = {"Image/imgres/mission/missionState_7.png", },
    id_8008 = {"Image/imgres/mission/missionState_8.png", },
    id_8009 = {"Image/imgres/mission/missionState_9.png", },
    id_8010 = {"Image/imgres/mission/missionState_10.png", },
    id_8011 = {"Image/imgres/mission/missionState_11.png", },
    id_8012 = {"Image/imgres/mission/missionState_12.png", },
    id_8013 = {"Image/imgres/mission/missionState_13.png", },
    id_8014 = {"Image/imgres/mission/missionState_14.png", },
    id_8015 = {"Image/imgres/mission/missionState_15.png", },
    id_8016 = {"Image/imgres/mission/missionState_16.png", },
    id_8017 = {"Image/imgres/mission/missionState_17.png", },
    id_8018 = {"Image/imgres/mission/missionState_18.png", },
    id_8019 = {"Image/imgres/mission/missionState_19.png", },
    id_8020 = {"Image/imgres/mission/missionState_20.png", },
    id_8021 = {"Image/imgres/mission/missionState_21.png", },
    id_8022 = {"Image/imgres/mission/missionState_22.png", },
    id_8023 = {"Image/imgres/mission/missionState_23.png", },
    id_8024 = {"Image/imgres/mission/missionState_24.png", },
    id_8025 = {"Image/imgres/mission/missionState_25.png", },
    id_8026 = {"Image/imgres/mission/missionState_26.png", },
    id_8027 = {"Image/imgres/mission/missionState_27.png", },
    id_8028 = {"Image/imgres/mission/missionState_28.png", },
    id_8029 = {"Image/imgres/mission/missionState_29.png", },
    id_8030 = {"Image/imgres/mission/missionState_30.png", },
    id_8031 = {"Image/imgres/mission/missionState_31.png", },
    id_8032 = {"Image/imgres/mission/missionState_32.png", },
    id_8033 = {"Image/imgres/mission/missionState_33.png", },
    id_8034 = {"Image/imgres/mission/missionState_34.png", },
    id_8035 = {"Image/imgres/mission/missionState_35.png", },
    id_8036 = {"Image/imgres/mission/missionState_36.png", },
    id_8037 = {"Image/imgres/mission/missionState_37.png", },
    id_8038 = {"Image/imgres/mission/missionState_38.png", },
    id_8039 = {"Image/imgres/mission/missionState_39.png", },
    id_8040 = {"Image/imgres/mission/missionState_40.png", },
    id_8041 = {"Image/imgres/mission/missionState_41.png", },
    id_8042 = {"Image/imgres/mission/missionState_42.png", },
    id_8043 = {"Image/imgres/mission/missionState_43.png", },
    id_8101 = {"Image/imgres/guide/guide_activity.png", },
    id_8102 = {"Image/imgres/guide/guide_bag.png", },
    id_8103 = {"Image/imgres/guide/guide_biwu.png", },
    id_8104 = {"Image/imgres/guide/guide_chonglou.png", },
    id_8105 = {"Image/imgres/guide/guide_danyao.png", },
    id_8106 = {"Image/imgres/guide/guide_dobk.png", },
    id_8107 = {"Image/imgres/guide/guide_grogshop.png", },
    id_8108 = {"Image/imgres/guide/guide_jingying.png", },
    id_8109 = {"Image/imgres/guide/guide_qh.png", },
    id_8110 = {"Image/imgres/guide/guide_wjUp.png", },
    id_8111 = {"Image/imgres/guide/guide_world.png", },
    id_8112 = {"Image/imgres/countrywar/ui_army.png", },
    id_8113 = {"Image/imgres/main/btn_rz.png", },
    id_8114 = {"Image/imgres/guide/guide_zj.png", },
    id_8115 = {"Image/imgres/guide/guide_grogshop.png", },
    id_8116 = {"Image/imgres/guide/guide_wj.png", },
    id_8117 = {"Image/imgres/guide/guide_world.png", },
    id_8201 = {"Image/imgres/prison/prison1.png", },
    id_8202 = {"Image/imgres/prison/prison2.png", },
    id_8203 = {"Image/imgres/prison/prison3.png", },
    id_8204 = {"Image/imgres/prison/prison4.png", },
    id_8205 = {"Image/imgres/prison/prison5.png", },
    id_8206 = {"Image/imgres/prison/prison6.png", },
    id_8207 = {"Image/imgres/prison/prison7.png", },
    id_8208 = {"Image/imgres/prison/prison8.png", },
    id_8209 = {"Image/imgres/prison/prison9.png", },
    id_8210 = {"Image/imgres/prison/prison10.png", },
    id_8301 = {"Image/imgres/VIPCharge/gold1.png", },
    id_8302 = {"Image/imgres/VIPCharge/gold2.png", },
    id_8303 = {"Image/imgres/VIPCharge/gold3.png", },
    id_8304 = {"Image/imgres/VIPCharge/gold4.png", },
    id_8305 = {"Image/imgres/VIPCharge/goldCard.png", },
    id_8306 = {"Image/imgres/VIPCharge/silverCard.png", },
    id_10000 = {"Image/imgres/shop/shop_head.png", },
    id_10050 = {"Image/imgres/countrywar/state1.png", },
    id_10051 = {"Image/imgres/countrywar/state2.png", },
    id_10052 = {"Image/imgres/countrywar/state3.png", },
    id_10053 = {"Image/imgres/countrywar/state4.png", },
    id_10054 = {"Image/imgres/countrywar/state5.png", },
    id_10055 = {"Image/imgres/countrywar/yz_1.png", },
    id_10056 = {"Image/imgres/countrywar/yz_2.png", },
    id_10057 = {"Image/imgres/countrywar/yz_3.png", },
    id_10058 = {"Image/imgres/countrywar/corps_1.png", },
    id_10059 = {"Image/imgres/countrywar/corps_2.png", },
    id_10060 = {"Image/imgres/countrywar/corps_3.png", },
    id_10061 = {"Image/imgres/countrywar/main_1.png", },
    id_10062 = {"Image/imgres/countrywar/main_2.png", },
    id_10063 = {"Image/imgres/countrywar/main_3.png", },
    id_10101 = {"Image/imgres/countrywar/wei_yz.png", },
    id_10102 = {"Image/imgres/countrywar/shu_yz.png", },
    id_10103 = {"Image/imgres/countrywar/wu_yz.png", },
    id_10111 = {"Image/imgres/countrywar/huang_event.png", },
    id_10112 = {"Image/imgres/countrywar/man_event.png", },
    id_10113 = {"Image/imgres/countrywar/wei_ls.png", },
    id_10114 = {"Image/imgres/countrywar/wei_ql.png", },
    id_10115 = {"Image/imgres/countrywar/wei_bh.png", },
    id_10116 = {"Image/imgres/countrywar/wei_zq.png", },
    id_10117 = {"Image/imgres/countrywar/wei_xw.png", },
    id_10118 = {"Image/imgres/countrywar/shu_ls.png", },
    id_10119 = {"Image/imgres/countrywar/shu_ql.png", },
    id_10120 = {"Image/imgres/countrywar/shu_bh.png", },
    id_10121 = {"Image/imgres/countrywar/shu_zq.png", },
    id_10122 = {"Image/imgres/countrywar/shu_xw.png", },
    id_10123 = {"Image/imgres/countrywar/wu_ls.png", },
    id_10124 = {"Image/imgres/countrywar/wu_ql.png", },
    id_10125 = {"Image/imgres/countrywar/wu_bh.png", },
    id_10126 = {"Image/imgres/countrywar/wu_zq.png", },
    id_10127 = {"Image/imgres/countrywar/wu_xw.png", },
    id_10201 = {"Image/imgres/corps/dabenying.png", },
    id_10202 = {"Image/imgres/corps/chengyuan.png", },
    id_10203 = {"Image/imgres/corps/guanyuan.png", },
    id_10204 = {"Image/imgres/corps/shitang.png", },
    id_10205 = {"Image/imgres/corps/juanxian.png", },
    id_10206 = {"Image/imgres/corps/shangdian.png", },
    id_10207 = {"Image/imgres/corps/yongbing.png", },
    id_10208 = {"Image/imgres/corps/lingshou.png", },
    id_10209 = {"Image/imgres/corps/laofang.png", },
    id_10210 = {"Image/imgres/corps/renwu.png", },
}


function getDataById(key_id)
    local id_data = resimgTable["id_" .. key_id]
    if id_data == nil then
        return nil
    end
    return id_data
end

function getArrDataByField(fieldName, fieldValue)
    local arrData = {}
    local fieldNo = 1
    for i=1, #keys do
        if keys[i] == fieldName then
            fieldNo = i
            break
        end
    end

    for k, v in pairs(resimgTable) do
        if tostring(v[fieldNo-1]) == tostring(fieldValue) then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end

function getTable()
    return resimgTable
end


function getFieldByIdAndIndex(key_id, fieldName)
    local fieldNo = 0
    for i=1, #keys do
        if keys[i] == fieldName then
            fieldNo = i-1
            break
        end
    end
    return getDataById(key_id)[fieldNo]
end


function getIndexByField(fieldName)
    local fieldNo = 0
    for i=1, #keys do
        if keys[i] == fieldName then
            fieldNo = i-1
            break
        end
    end
    return fieldNo
end


function getArrDataBy2Field(fieldName1, fieldValue1, fieldName2, fieldValue2)
	local arrData = {}
	local fieldNo1 = 1
	local fieldNo2 = 1
	for i=1, #keys do
		if keys[i] == fieldName1 then
			fieldNo1 = i
		end
		if keys[i] == fieldName2 then
			fieldNo2 = i
		end
	end

    for k, v in pairs(resimgTable) do
        if tostring(v[fieldNo1-1]) == tostring(fieldValue1) and tostring(v[fieldNo2-1]) == tostring(fieldValue2)  then
            table.insert(arrData, copyTab(v))
        end
    end

    return arrData
end



function release()
    _G["resimg"] = nil
    package.loaded["resimg"] = nil
end