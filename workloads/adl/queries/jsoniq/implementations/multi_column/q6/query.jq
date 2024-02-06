import module namespace hep = "../../common/function_subset.jq";

let $filtered :=
  for $event in collection("adl")
  where size($event.Jet) gt 2
  return (
    for $jet1 at $i in $event.Jet[]
    for $jet2 at $j in $event.Jet[]
    for $jet3 at $k in $event.Jet[]
    where $i lt $j and $j lt $k
    let $PtEtaPhiM-to-PxPyPzE1 := (
      let $x1 := $jet1.pt * cos($jet1.phi)
      let $y1 := $jet1.pt * sin($jet1.phi)
      let $z1 := $jet1.pt * ((exp($jet1.eta) - exp(-$jet1.eta)) div 2.0)
      let $temp1 := $jet1.pt * ((exp($jet1.eta) + exp(-$jet1.eta)) div 2.0)
      let $e1 := sqrt($temp1 * $temp1 + $jet1.mass * $jet1.mass)
      return {"x": $x1, "y": $y1, "z": $z1, "e": $e1}
    )
    let $PtEtaPhiM-to-PxPyPzE2 := (
      let $x2 := $jet2.pt * cos($jet2.phi)
      let $y2 := $jet2.pt * sin($jet2.phi)
      let $z2 := $jet2.pt * ((exp($jet2.eta) - exp(-$jet2.eta)) div 2.0)
      let $temp2 := $jet2.pt * ((exp($jet2.eta) + exp(-$jet2.eta)) div 2.0)
      let $e2 := sqrt($temp2 * $temp2 + $jet2.mass * $jet2.mass)
      return {"x": $x2, "y": $y2, "z": $z2, "e": $e2}
    )
    let $PtEtaPhiM-to-PxPyPzE3 := (
      let $x3 := $jet3.pt * cos($jet3.phi)
      let $y3 := $jet3.pt * sin($jet3.phi)
      let $z3 := $jet3.pt * ((exp($jet3.eta) - exp(-$jet3.eta)) div 2.0)
      let $temp3 := $jet3.pt * ((exp($jet3.eta) + exp(-$jet3.eta)) div 2.0)
      let $e3 := sqrt($temp3 * $temp3 + $jet3.mass * $jet3.mass)
      return {"x": $x3, "y": $y3, "z": $z3, "e": $e3}
    )
    let $add-PxPyPzESum := (
      let $x4 := $PtEtaPhiM-to-PxPyPzE1.x + $PtEtaPhiM-to-PxPyPzE2.x + $PtEtaPhiM-to-PxPyPzE3.x
      let $y4 := $PtEtaPhiM-to-PxPyPzE1.y + $PtEtaPhiM-to-PxPyPzE2.y + $PtEtaPhiM-to-PxPyPzE3.y
      let $z4 := $PtEtaPhiM-to-PxPyPzE1.z + $PtEtaPhiM-to-PxPyPzE2.z + $PtEtaPhiM-to-PxPyPzE3.z
      let $e4 := $PtEtaPhiM-to-PxPyPzE1.e + $PtEtaPhiM-to-PxPyPzE2.e + $PtEtaPhiM-to-PxPyPzE3.e
      return {"x": $x4, "y": $y4, "z": $z4, "e": $e4}
      )
    let $tri-jet := (
      let $x5 := $add-PxPyPzESum.x * $add-PxPyPzESum.x
      let $y5 := $add-PxPyPzESum.y * $add-PxPyPzESum.y
      let $z5 := $add-PxPyPzESum.z * $add-PxPyPzESum.z
      let $e5 := $add-PxPyPzESum.e * $add-PxPyPzESum.e
      let $pt5 := sqrt($x5 + $y5)
      let $eta5 := log(($add-PxPyPzESum.z div $pt5) + sqrt(($add-PxPyPzESum.z div $pt5) * ($add-PxPyPzESum.z div $pt5) + 1.0))
      let $phi5 := if ($add-PxPyPzESum.x eq 0.0 and $add-PxPyPzESum.y eq 0.0)
      then 0.0
      else atan2($add-PxPyPzESum.y, $add-PxPyPzESum.x)
      let $mass5 := sqrt($e5 - $z5 - $y5 - $x5)
      return {"pt": $pt5, "eta": $eta5, "phi": $phi5, "mass": $mass5}
    )
    let $ob := abs(172.5 - $tri-jet.mass)
    order by $ob ascending
    return $tri-jet
)[1].pt

return hep:histogram($filtered, 15, 40, 100)