import module namespace hep = "../../common/function_subset.jq";

let $filtered := (
  for $event in collection("adl")
  where (size($event.Muon) + size($event.Electron)) gt 2
  let $leptons := (
      let $muons := 
        for $muonvar in $event.Muon[]
        return { 
          "pt": $muonvar.pt, 
          "eta": $muonvar.eta, 
          "phi": $muonvar.phi, 
          "mass": $muonvar.mass,
          "charge": $muonvar.charge, 
          "type": "m" 
        }
      let $electrons := 
        for $electronvar in $event.Electron[]
        return { 
          "pt": $electronvar.pt, 
          "eta": $electronvar.eta, 
          "phi": $electronvar.phi, 
          "mass": $electronvar.mass,
          "charge": $electronvar.charge, 
          "type": "e" 
      }
      return ($muons, $electrons)
  )
  let $closest-lepton-pair := (
    for $lepton1 at $i in $leptons[]
    for $lepton2 at $j in $leptons[]
    where $i lt $j and $lepton1."type" eq $lepton2."type" and $lepton1.charge ne $lepton2.charge
    let $PtEtaPhiM_to_PxPyPzE1 := ( 
      let $x1 := $lepton1.pt * cos($lepton1.phi)
      let $y1 := $lepton1.pt * sin($lepton1.phi)
      let $z1 := $lepton1.pt * (exp($lepton1.eta) - exp(-$lepton1.eta)) div 2.0
      let $temp1 := $lepton1.pt * (exp($lepton1.eta) + exp(-$lepton1.eta)) div 2.0
      let $e1 := sqrt($temp1 * $temp1 + $lepton1.mass * $lepton1.mass)
      return {"x": $x1, "y": $y1, "z": $z1, "e": $e1}
    )
    let $PtEtaPhiM_to_PxPyPzE2 := (
      let $x2 := $lepton2.pt * cos($lepton2.phi)
      let $y2 := $lepton2.pt * sin($lepton2.phi)
      let $z2 := $lepton2.pt * (exp($lepton2.eta) - exp(-$lepton2.eta)) div 2.0
      let $temp2 := $lepton2.pt * (exp($lepton2.eta) + exp(-$lepton2.eta)) div 2.0
      let $e2 := sqrt($temp2 * $temp2 + $lepton2.mass * $lepton2.mass)
      return {"x": $x2, "y": $y2, "z": $z2, "e": $e2}
    )
    let $particle := (
      let $x3 := $PtEtaPhiM_to_PxPyPzE1.x + $PtEtaPhiM_to_PxPyPzE2.x
      let $y3 := $PtEtaPhiM_to_PxPyPzE1.y + $PtEtaPhiM_to_PxPyPzE2.y
      let $z3 := $PtEtaPhiM_to_PxPyPzE1.z + $PtEtaPhiM_to_PxPyPzE2.z
      let $e3 := $PtEtaPhiM_to_PxPyPzE1.e + $PtEtaPhiM_to_PxPyPzE2.e
      return {"x": $x3, "y": $y3, "z": $z3, "e": $e3}
    )
    let $PxPyPzE_to_PtEtaPhiM := (
      let $x4 := $particle.x * $particle.x
      let $y4 := $particle.y * $particle.y
      let $z4 := $particle.z * $particle.z
      let $e4 := $particle.e * $particle.e
      let $pt4 := sqrt($x4 + $y4)
      let $eta4 := (
                    let $temp4 := $particle.z div $pt4
                    return log($temp4 + sqrt($temp4 * $temp4 + 1.0))
                  )
      let $phi4 := if ($particle.x eq 0.0 and $particle.y eq 0.0)
      then 0.0
      else atan2($particle.y, $particle.x)
      let $mass4 := sqrt($e4 - $z4 - $y4 - $x4)
      return {"pt": $pt4, "eta": $eta4, "phi": $phi4, "mass": $mass4}
    )
    let $order-criterion := abs(91.2 - $PxPyPzE_to_PtEtaPhiM.mass)
    order by $order-criterion ascending
    return {"i": $i, "j": $j}
  )[1]
  where exists($closest-lepton-pair)
  let $other-leption := (
    for $lepton at $k in $leptons[]
    where $k ne $closest-lepton-pair.i and $k ne $closest-lepton-pair.j
    order by $lepton.pt descending
    return $lepton
  )[1]
  return sqrt(2 * $event.MET.pt * $other-leption.pt * (1.0 - cos(($event.MET.phi - $other-leption.phi + pi()) mod (2 * pi()) - pi())))
)

return hep:histogram($filtered, 15, 250, 100)
