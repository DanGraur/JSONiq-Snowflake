SELECT object_construct('x', "CENTER", 'y', "COUNT(BUCKET-IDX)") FROM ( SELECT  *  FROM ( SELECT "CENTER", count("bucket-idx") AS "COUNT(BUCKET-IDX)" FROM ( SELECT *, ((("bucket-idx" * 0.45 :: FLOAT) + 0.225 :: FLOAT) + 0.1500004 :: FLOAT) AS "CENTER" FROM ( SELECT *, floor(("truncated-value" / 0.45 :: FLOAT)) AS "bucket-idx" FROM ( SELECT *, iff(("JET_VALUE['PT']" < 15.0 :: FLOAT), (15.0 :: FLOAT - 0.225 :: FLOAT), iff(("JET_VALUE['PT']" > 60.0 :: FLOAT), (60.0 :: FLOAT + 0.225 :: FLOAT), ("JET_VALUE['PT']" - 0.1500004 :: FLOAT))) AS "truncated-value" FROM ( SELECT * FROM ( SELECT Jet_VALUE['pt'] FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "INDEX" AS "JET_INDEX", "JET_VALUE" FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "INDEX", "VALUE" AS "JET_VALUE" FROM ( SELECT "RUN", "LUMINOSITYBLOCK", "EVENT", "HLT", "PV", "MET", "MUON", "ELECTRON", "TAU", "PHOTON", "JET", "INDEX", "VALUE" FROM ( SELECT  *  FROM ( SELECT  *  FROM (adl)),  LATERAL  FLATTEN ( INPUT  => Jet,  PATH  => '',  OUTER  => false,  RECURSIVE  => false,  MODE  => 'ARRAY')))))))))) GROUP BY "CENTER") ORDER BY "CENTER" ASC NULLS FIRST);
