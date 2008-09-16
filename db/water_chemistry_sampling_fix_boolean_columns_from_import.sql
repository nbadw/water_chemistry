UPDATE `cdOandM` SET `OandM_DetailsInd` = 1 WHERE `OandM_DetailsInd` = -1;
UPDATE `cdOandM` SET `FishPassageInd`   = 1 WHERE `FishPassageInd` = -1;
UPDATE `cdOandM` SET `BankInd`          = 1 WHERE `BankInd` = -1;

UPDATE `tblAquaticActivity` SET `PrimaryActivityInd` = 1 WHERE `PrimaryActivityInd` = -1;
UPDATE `tblAquaticActivity` SET `IncorporatedInd`    = 1 WHERE `IncorporatedInd` = -1;

UPDATE `tblAquaticSite` SET `IncorporatedInd` = 1 WHERE `IncorporatedInd` = -1;

UPDATE `tblAquaticSiteAgencyUse` SET `IncorporatedInd` = 1 WHERE `IncorporatedInd` = -1;

UPDATE `tblObservations` SET `FishPassageObstructionInd` = 1 WHERE `FishPassageObstructionInd` = -1;