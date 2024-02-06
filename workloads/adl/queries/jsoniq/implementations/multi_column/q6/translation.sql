SELECT object_construct('x', "CENTER", 'y', "COUNT(BUCKET-IDX)") FROM ( SELECT  *  FROM ( SELECT "CENTER", count("bucket-idx") AS "COUNT(BUCKET-IDX)" FROM ( SELECT *, ((("bucket-idx" * 0.25 :: FLOAT) + 0.125 :: FLOAT) + 0.0 :: FLOAT) AS "CENTER" FROM ( SELECT *, floor(("truncated-value" / 0.25 :: FLOAT)) AS "bucket-idx" FROM ( SELECT *, iff(("GET(""SUBQUERY_RESULT"", 0:: INTEGER)['PT']" < 15.0 :: FLOAT), (15.0 :: FLOAT - 0.125 :: FLOAT), iff(("GET(""SUBQUERY_RESULT"", 0:: INTEGER)['PT']" > 40.0 :: FLOAT), (40.0 :: FLOAT + 0.125 :: FLOAT), ("GET(""SUBQUERY_RESULT"", 0:: INTEGER)['PT']" - 0.0 :: FLOAT))) AS "truncated-value" FROM ( SELECT * FROM ( SELECT get("SUBQUERY_RESULT", 0:: INTEGER)['pt'] FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "SUBQUERY_RESULT" FROM ( SELECT "STATIC_INDEX_4", any_value("RUN") AS "RUN", any_value("LUMINOSITYBLOCK") AS "LUMINOSITYBLOCK", any_value("EVENT") AS "EVENT", any_value("HLT") AS "HLT", any_value("PV") AS "PV", any_value("MET") AS "MET", any_value("MUON") AS "MUON", any_value("ELECTRON") AS "ELECTRON", any_value("TAU") AS "TAU", any_value("PHOTON") AS "PHOTON", any_value("JET") AS "JET", any_value("STATIC_INDEX_4") AS "STATIC_INDEX_4", any_value("I") AS "I", any_value("JET1") AS "JET1", any_value("J") AS "J", any_value("JET2") AS "JET2", any_value("K") AS "K", any_value("JET3") AS "JET3", any_value("SHOULD_KEEP_4") AS "SHOULD_KEEP_4", any_value("PtEtaPhiM-to-PxPyPzE1") AS "PtEtaPhiM-to-PxPyPzE1", any_value("PtEtaPhiM-to-PxPyPzE2") AS "PtEtaPhiM-to-PxPyPzE2", any_value("PtEtaPhiM-to-PxPyPzE3") AS "PtEtaPhiM-to-PxPyPzE3", any_value("add-PxPyPzESum") AS "add-PxPyPzESum", any_value("tri-jet") AS "tri-jet", any_value("OB") AS "OB", any_value("RETURN_TEMP_COLUMN") AS "RETURN_TEMP_COLUMN", array_agg("RETURN_TEMP_COLUMN") WITHIN GROUP ( ORDER BY "OB" ASC NULLS FIRST) AS "SUBQUERY_RESULT" FROM ( SELECT *, iff("SHOULD_KEEP_4", NULL, "tri-jet") AS "RETURN_TEMP_COLUMN" FROM ( SELECT *, abs((172.5 :: FLOAT - "tri-jet"['mass'])) AS "OB" FROM ( SELECT * FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "I", "JET1", "J", "JET2", "K", "JET3", "SHOULD_KEEP_4", "PtEtaPhiM-to-PxPyPzE1", "PtEtaPhiM-to-PxPyPzE2", "PtEtaPhiM-to-PxPyPzE3", "add-PxPyPzESum", "SUBQUERY_RESULT" AS "tri-jet" FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "I", "JET1", "J", "JET2", "K", "JET3", "SHOULD_KEEP_4", "PtEtaPhiM-to-PxPyPzE1", "PtEtaPhiM-to-PxPyPzE2", "PtEtaPhiM-to-PxPyPzE3", "add-PxPyPzESum", "SUBQUERY_RESULT" FROM ( SELECT *, object_construct('pt', "PT5", 'eta', "ETA5", 'phi', "PHI5", 'mass', "MASS5") AS "SUBQUERY_RESULT" FROM ( SELECT *, sqrt(((("E5" - "Z5") - "Y5") - "X5")) AS "MASS5" FROM ( SELECT *, iff((("add-PxPyPzESum"['x'] = 0.0 :: FLOAT) AND ("add-PxPyPzESum"['y'] = 0.0 :: FLOAT)), 0.0 :: FLOAT, atan2("add-PxPyPzESum"['y'], "add-PxPyPzESum"['x'])) AS "PHI5" FROM ( SELECT *, log(2.718281828459045:: FLOAT, (("add-PxPyPzESum"['z'] / "PT5") + sqrt(((("add-PxPyPzESum"['z'] / "PT5") * ("add-PxPyPzESum"['z'] / "PT5")) + 1.0 :: FLOAT)))) AS "ETA5" FROM ( SELECT *, sqrt(("X5" + "Y5")) AS "PT5" FROM ( SELECT *, ("add-PxPyPzESum"['e'] * "add-PxPyPzESum"['e']) AS "E5" FROM ( SELECT *, ("add-PxPyPzESum"['z'] * "add-PxPyPzESum"['z']) AS "Z5" FROM ( SELECT *, ("add-PxPyPzESum"['y'] * "add-PxPyPzESum"['y']) AS "Y5" FROM ( SELECT *, ("add-PxPyPzESum"['x'] * "add-PxPyPzESum"['x']) AS "X5" FROM ( SELECT * FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "I", "JET1", "J", "JET2", "K", "JET3", "SHOULD_KEEP_4", "PtEtaPhiM-to-PxPyPzE1", "PtEtaPhiM-to-PxPyPzE2", "PtEtaPhiM-to-PxPyPzE3", "SUBQUERY_RESULT" AS "add-PxPyPzESum" FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "I", "JET1", "J", "JET2", "K", "JET3", "SHOULD_KEEP_4", "PtEtaPhiM-to-PxPyPzE1", "PtEtaPhiM-to-PxPyPzE2", "PtEtaPhiM-to-PxPyPzE3", "SUBQUERY_RESULT" FROM ( SELECT *, object_construct('x', "X4", 'y', "Y4", 'z', "Z4", 'e', "E4") AS "SUBQUERY_RESULT" FROM ( SELECT *, (("PtEtaPhiM-to-PxPyPzE1"['e'] + "PtEtaPhiM-to-PxPyPzE2"['e']) + "PtEtaPhiM-to-PxPyPzE3"['e']) AS "E4" FROM ( SELECT *, (("PtEtaPhiM-to-PxPyPzE1"['z'] + "PtEtaPhiM-to-PxPyPzE2"['z']) + "PtEtaPhiM-to-PxPyPzE3"['z']) AS "Z4" FROM ( SELECT *, (("PtEtaPhiM-to-PxPyPzE1"['y'] + "PtEtaPhiM-to-PxPyPzE2"['y']) + "PtEtaPhiM-to-PxPyPzE3"['y']) AS "Y4" FROM ( SELECT *, (("PtEtaPhiM-to-PxPyPzE1"['x'] + "PtEtaPhiM-to-PxPyPzE2"['x']) + "PtEtaPhiM-to-PxPyPzE3"['x']) AS "X4" FROM ( SELECT * FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "I", "JET1", "J", "JET2", "K", "JET3", "SHOULD_KEEP_4", "PtEtaPhiM-to-PxPyPzE1", "PtEtaPhiM-to-PxPyPzE2", "SUBQUERY_RESULT" AS "PtEtaPhiM-to-PxPyPzE3" FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "I", "JET1", "J", "JET2", "K", "JET3", "SHOULD_KEEP_4", "PtEtaPhiM-to-PxPyPzE1", "PtEtaPhiM-to-PxPyPzE2", "SUBQUERY_RESULT" FROM ( SELECT *, object_construct('x', "X3", 'y', "Y3", 'z', "Z3", 'e', "E3") AS "SUBQUERY_RESULT" FROM ( SELECT *, sqrt((("TEMP3" * "TEMP3") + ("JET3"['mass'] * "JET3"['mass']))) AS "E3" FROM ( SELECT *, ("JET3"['pt'] * ((exp("JET3"['eta']) + exp(- "JET3"['eta'])) / 2.0 :: FLOAT)) AS "TEMP3" FROM ( SELECT *, ("JET3"['pt'] * ((exp("JET3"['eta']) - exp(- "JET3"['eta'])) / 2.0 :: FLOAT)) AS "Z3" FROM ( SELECT *, ("JET3"['pt'] * sin("JET3"['phi'])) AS "Y3" FROM ( SELECT *, ("JET3"['pt'] * cos("JET3"['phi'])) AS "X3" FROM ( SELECT * FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "I", "JET1", "J", "JET2", "K", "JET3", "SHOULD_KEEP_4", "PtEtaPhiM-to-PxPyPzE1", "SUBQUERY_RESULT" AS "PtEtaPhiM-to-PxPyPzE2" FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "I", "JET1", "J", "JET2", "K", "JET3", "SHOULD_KEEP_4", "PtEtaPhiM-to-PxPyPzE1", "SUBQUERY_RESULT" FROM ( SELECT *, object_construct('x', "X2", 'y', "Y2", 'z', "Z2", 'e', "E2") AS "SUBQUERY_RESULT" FROM ( SELECT *, sqrt((("TEMP2" * "TEMP2") + ("JET2"['mass'] * "JET2"['mass']))) AS "E2" FROM ( SELECT *, ("JET2"['pt'] * ((exp("JET2"['eta']) + exp(- "JET2"['eta'])) / 2.0 :: FLOAT)) AS "TEMP2" FROM ( SELECT *, ("JET2"['pt'] * ((exp("JET2"['eta']) - exp(- "JET2"['eta'])) / 2.0 :: FLOAT)) AS "Z2" FROM ( SELECT *, ("JET2"['pt'] * sin("JET2"['phi'])) AS "Y2" FROM ( SELECT *, ("JET2"['pt'] * cos("JET2"['phi'])) AS "X2" FROM ( SELECT * FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "I", "JET1", "J", "JET2", "K", "JET3", "SHOULD_KEEP_4", "SUBQUERY_RESULT" AS "PtEtaPhiM-to-PxPyPzE1" FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "I", "JET1", "J", "JET2", "K", "JET3", "SHOULD_KEEP_4", "SUBQUERY_RESULT" FROM ( SELECT *, object_construct('x', "X1", 'y', "Y1", 'z', "Z1", 'e', "E1") AS "SUBQUERY_RESULT" FROM ( SELECT *, sqrt((("TEMP1" * "TEMP1") + ("JET1"['mass'] * "JET1"['mass']))) AS "E1" FROM ( SELECT *, ("JET1"['pt'] * ((exp("JET1"['eta']) + exp(- "JET1"['eta'])) / 2.0 :: FLOAT)) AS "TEMP1" FROM ( SELECT *, ("JET1"['pt'] * ((exp("JET1"['eta']) - exp(- "JET1"['eta'])) / 2.0 :: FLOAT)) AS "Z1" FROM ( SELECT *, ("JET1"['pt'] * sin("JET1"['phi'])) AS "Y1" FROM ( SELECT *, ("JET1"['pt'] * cos("JET1"['phi'])) AS "X1" FROM ( SELECT * FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "I", "JET1", "J", "JET2", "K", "JET3", "SHOULD_KEEP_4" FROM ( SELECT  *  FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "I", "JET1", "J", "JET2", "K", "JET3", "TEMP_PREDICATE", "TT" AS "SHOULD_KEEP_4" FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "I", "JET1", "J", "JET2", "K", "JET3", "TEMP_PREDICATE", "TT" FROM ( SELECT *, ("SHOULD_KEEP_4" OR NOT "TEMP_PREDICATE") AS "TT" FROM ( SELECT *, (("I" < "J") AND ("J" < "K")) AS "TEMP_PREDICATE" FROM ( SELECT * FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "SHOULD_KEEP_4", "I", "JET1", "J", "JET2", "INDEX" AS "K", "JET3" FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "SHOULD_KEEP_4", "I", "JET1", "J", "JET2", "INDEX", "VALUE" AS "JET3" FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "SHOULD_KEEP_4", "I", "JET1", "J", "JET2", "INDEX", "VALUE" FROM ( SELECT  *  FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "SHOULD_KEEP_4", "I", "JET1", "INDEX" AS "J", "JET2" FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "SHOULD_KEEP_4", "I", "JET1", "INDEX", "VALUE" AS "JET2" FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "SHOULD_KEEP_4", "I", "JET1", "INDEX", "VALUE" FROM ( SELECT  *  FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "SHOULD_KEEP_4", "INDEX" AS "I", "JET1" FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "SHOULD_KEEP_4", "INDEX", "VALUE" AS "JET1" FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "STATIC_INDEX_4", "SHOULD_KEEP_4", "INDEX", "VALUE" FROM ( SELECT  *  FROM ( SELECT *, (Jet IS NULL OR (array_size(Jet) = 0 :: INTEGER)) AS "SHOULD_KEEP_4" FROM ( SELECT *, seq8(0) AS "STATIC_INDEX_4" FROM ( SELECT  *  FROM ( SELECT  *  FROM (adl)) WHERE (array_size(Jet) > 2:: INTEGER)))),  LATERAL  FLATTEN ( INPUT  => Jet,  PATH  => '',  OUTER  => true,  RECURSIVE  => false,  MODE  => 'ARRAY'))))),  LATERAL  FLATTEN ( INPUT  => Jet,  PATH  => '',  OUTER  => true,  RECURSIVE  => false,  MODE  => 'ARRAY'))))),  LATERAL  FLATTEN ( INPUT  => Jet,  PATH  => '',  OUTER  => true,  RECURSIVE  => false,  MODE  => 'ARRAY')))))))))) WHERE ("TEMP_PREDICATE" IS NULL OR ("TEMP_PREDICATE" OR (NOT "TEMP_PREDICATE" AND ((("K" IS NULL OR ("K" = 0 :: INTEGER)) OR ("J" IS NULL OR ("J" = 0 :: INTEGER))) OR ("I" IS NULL OR ("I" = 0 :: INTEGER)))))))))))))))))))))))))))))))))))))))))))))))))))))))))) GROUP BY "STATIC_INDEX_4"))))))) GROUP BY "CENTER") ORDER BY "CENTER" ASC NULLS FIRST);