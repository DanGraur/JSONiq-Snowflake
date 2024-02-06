declare type hep-schema:entry-type as {
  "RUN" : "integer",
  "LUMINOSITYBLOCK": "integer",
  "EVENT": "integer",
  "HLT": {
    "IsoMu17_eta2p1_LooseIsoPFTau20": "boolean",
    "IsoMu24": "boolean",
    "IsoMu24_eta2p1": "boolean"
  },
  "PV": {
    "npvs": "integer",
    "x": "double",
    "y": "double",
    "z": "double"
  },
  "MET": {
    "CovXX": "double",
    "CovXY": "double",
    "CovXZ": "double",
    "phi": "double",
    "pt": "double",
    "significance": "double",
    "sumet": "double"
  },
  "MUON": [{
    "charge": "integer",
    "dxy": "double",
    "dxyErr": "double",
    "dz": "double",
    "dzErr": "double",
    "eta": "double",
    "genPartIdx": "integer",
    "jetIdx": "integer",
    "mass": "double",
    "pfRelIso03_all": "double",
    "pfRelIso04_all": "double",
    "phi": "double",
    "pt": "double",
    "softId": "boolean",
    "tightId": "boolean"
  }],
  "ELECTRON": [{
    "charge": "integer",
    "cutBasedId": "boolean",
    "dxy": "double",
    "dxyErr": "double",
    "dz": "double",
    "dzErr": "double",
    "eta": "double",
    "genPartIdx": "integer",
    "jetIdx": "integer",
    "mass": "double",
    "pfId": "boolean",
    "pfRelIso03_all": "double",
    "phi": "double",
    "pt": "double"
  }],
  "TAU": [{
    "charge": "integer",
    "decayMode": "integer",
    "eta": "double",
    "genPartIdx": "integer",
    "idAntiEleLoose": "boolean",
    "idAntiEleMedium": "boolean",
    "idAntiEleTight": "boolean",
    "idAntiMuLoose": "boolean",
    "idAntiMuMedium": "boolean",
    "idAntiMuTight": "boolean",
    "idDecayMode": "boolean",
    "idIsoLoose": "boolean",
    "idIsoMedium": "boolean",
    "idIsoRaw": "double",
    "idIsoTight": "boolean",
    "idIsoVLoose": "boolean",
    "jetIdx": "integer",
    "mass": "double",
    "phi": "double",
    "pt": "double",
    "relIso_all": "double"
  }],
  "PHOTON": [{
    "charge": "integer",
    "eta": "double",
    "genPartIdx": "integer",
    "jetIdx": "integer",
    "mass": "double",
    "pfRelIso03_all": "double",
    "phi": "double",
    "pt": "double"
  }],
  "JET": [{
    "btag": "double",
    "eta": "double",
    "mass": "double",
    "phi": "double",
    "pt": "double",
    "puId": "boolean"
  }]
};