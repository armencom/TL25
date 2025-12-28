
{*********************************************************}
{                                                         }
{                    XML Data Binding                     }
{                                                         }
{         Generated on: 4/12/2013 5:37:03 PM              }
{       Generated from: D:\Armen\ofx102spec\OFXMAIN.DTD   }
{   Settings stored in: D:\Armen\ofx102spec\OFXMAIN.xdb   }
{                                                         }
{*********************************************************}

unit OFXMAIN;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLSIGNONMSGSRQV1Type = interface;
  IXMLSONRQType = interface;
  IXMLFIType = interface;
  IXMLPINCHTRNRQType = interface;
  IXMLPINCHRQType = interface;
  IXMLCHALLENGETRNRQType = interface;
  IXMLCHALLENGERQType = interface;
  IXMLSIGNONMSGSRSV1Type = interface;
  IXMLSONRSType = interface;
  IXMLSTATUSType = interface;
  IXMLPINCHTRNRSType = interface;
  IXMLPINCHRSType = interface;
  IXMLCHALLENGETRNRSType = interface;
  IXMLCHALLENGERSType = interface;
  IXMLSIGNONMSGSETType = interface;
  IXMLSIGNONMSGSETV1Type = interface;
  IXMLMSGSETCOREType = interface;
  IXMLBANKMSGSETType = interface;
  IXMLBANKMSGSETV1Type = interface;
  IXMLXFERPROFType = interface;
  IXMLSTPCHKPROFType = interface;
  IXMLEMAILPROFType = interface;
  IXMLCREDITCARDMSGSETType = interface;
  IXMLCREDITCARDMSGSETV1Type = interface;
  IXMLINTERXFERMSGSETType = interface;
  IXMLINTERXFERMSGSETV1Type = interface;
  IXMLWIREXFERMSGSETType = interface;
  IXMLWIREXFERMSGSETV1Type = interface;
  IXMLBANKMSGSRQV1Type = interface;
  IXMLSTMTTRNRQType = interface;
  IXMLSTMTTRNRQTypeList = interface;
  IXMLSTMTRQType = interface;
  IXMLINCTRANType = interface;
  IXMLSTMTENDTRNRQType = interface;
  IXMLSTMTENDTRNRQTypeList = interface;
  IXMLSTMTENDRQType = interface;
  IXMLINTRATRNRQType = interface;
  IXMLINTRATRNRQTypeList = interface;
  IXMLINTRARQType = interface;
  IXMLXFERINFOType = interface;
  IXMLINTRAMODRQType = interface;
  IXMLINTRACANRQType = interface;
  IXMLRECINTRATRNRQType = interface;
  IXMLRECINTRATRNRQTypeList = interface;
  IXMLRECINTRARQType = interface;
  IXMLRECURRINSTType = interface;
  IXMLRECINTRAMODRQType = interface;
  IXMLRECINTRACANRQType = interface;
  IXMLSTPCHKTRNRQType = interface;
  IXMLSTPCHKTRNRQTypeList = interface;
  IXMLSTPCHKRQType = interface;
  IXMLCHKRANGEType = interface;
  IXMLCHKDESCType = interface;
  IXMLBANKMAILTRNRQType = interface;
  IXMLBANKMAILTRNRQTypeList = interface;
  IXMLBANKMAILRQType = interface;
  IXMLMAILType = interface;
  IXMLBANKMAILSYNCRQType = interface;
  IXMLBANKMAILSYNCRQTypeList = interface;
  IXMLSTPCHKSYNCRQType = interface;
  IXMLSTPCHKSYNCRQTypeList = interface;
  IXMLINTRASYNCRQType = interface;
  IXMLINTRASYNCRQTypeList = interface;
  IXMLRECINTRASYNCRQType = interface;
  IXMLRECINTRASYNCRQTypeList = interface;
  IXMLCREDITCARDMSGSRQV1Type = interface;
  IXMLCCSTMTTRNRQType = interface;
  IXMLCCSTMTTRNRQTypeList = interface;
  IXMLCCSTMTRQType = interface;
  IXMLCCSTMTENDTRNRQType = interface;
  IXMLCCSTMTENDTRNRQTypeList = interface;
  IXMLCCSTMTENDRQType = interface;
  IXMLINTERXFERMSGSRQV1Type = interface;
  IXMLINTERTRNRQType = interface;
  IXMLINTERTRNRQTypeList = interface;
  IXMLINTERRQType = interface;
  IXMLINTERMODRQType = interface;
  IXMLINTERCANRQType = interface;
  IXMLRECINTERTRNRQType = interface;
  IXMLRECINTERTRNRQTypeList = interface;
  IXMLRECINTERRQType = interface;
  IXMLRECINTERMODRQType = interface;
  IXMLRECINTERCANRQType = interface;
  IXMLINTERSYNCRQType = interface;
  IXMLINTERSYNCRQTypeList = interface;
  IXMLRECINTERSYNCRQType = interface;
  IXMLRECINTERSYNCRQTypeList = interface;
  IXMLWIREXFERMSGSRQV1Type = interface;
  IXMLWIRETRNRQType = interface;
  IXMLWIRETRNRQTypeList = interface;
  IXMLWIRERQType = interface;
  IXMLWIREBENEFICIARYType = interface;
  IXMLWIREDESTBANKType = interface;
  IXMLEXTBANKDESCType = interface;
  IXMLWIRECANRQType = interface;
  IXMLWIRESYNCRQType = interface;
  IXMLWIRESYNCRQTypeList = interface;
  IXMLBANKMSGSRSV1Type = interface;
  IXMLSTMTTRNRSType = interface;
  IXMLSTMTTRNRSTypeList = interface;
  IXMLSTMTRSType = interface;
  IXMLBANKTRANLISTType = interface;
  IXMLSTMTTRNType = interface;
  IXMLSTMTTRNTypeList = interface;
  IXMLPAYEEType = interface;
  IXMLLEDGERBALType = interface;
  IXMLAVAILBALType = interface;
  IXMLSTMTENDTRNRSType = interface;
  IXMLSTMTENDTRNRSTypeList = interface;
  IXMLSTMTENDRSType = interface;
  IXMLCLOSINGType = interface;
  IXMLCLOSINGTypeList = interface;
  IXMLINTRATRNRSType = interface;
  IXMLINTRATRNRSTypeList = interface;
  IXMLINTRARSType = interface;
  IXMLXFERPRCSTSType = interface;
  IXMLINTRAMODRSType = interface;
  IXMLINTRACANRSType = interface;
  IXMLRECINTRATRNRSType = interface;
  IXMLRECINTRATRNRSTypeList = interface;
  IXMLRECINTRARSType = interface;
  IXMLRECINTRAMODRSType = interface;
  IXMLRECINTRACANRSType = interface;
  IXMLSTPCHKTRNRSType = interface;
  IXMLSTPCHKTRNRSTypeList = interface;
  IXMLSTPCHKRSType = interface;
  IXMLSTPCHKNUMType = interface;
  IXMLSTPCHKNUMTypeList = interface;
  IXMLBANKMAILTRNRSType = interface;
  IXMLBANKMAILTRNRSTypeList = interface;
  IXMLBANKMAILRSType = interface;
  IXMLCHKMAILRSType = interface;
  IXMLDEPMAILRSType = interface;
  IXMLBANKMAILSYNCRSType = interface;
  IXMLBANKMAILSYNCRSTypeList = interface;
  IXMLSTPCHKSYNCRSType = interface;
  IXMLSTPCHKSYNCRSTypeList = interface;
  IXMLINTRASYNCRSType = interface;
  IXMLINTRASYNCRSTypeList = interface;
  IXMLRECINTRASYNCRSType = interface;
  IXMLRECINTRASYNCRSTypeList = interface;
  IXMLCREDITCARDMSGSRSV1Type = interface;
  IXMLCCSTMTTRNRSType = interface;
  IXMLCCSTMTTRNRSTypeList = interface;
  IXMLCCSTMTRSType = interface;
  IXMLCCSTMTENDTRNRSType = interface;
  IXMLCCSTMTENDTRNRSTypeList = interface;
  IXMLCCSTMTENDRSType = interface;
  IXMLCCCLOSINGType = interface;
  IXMLCCCLOSINGTypeList = interface;
  IXMLINTERXFERMSGSRSV1Type = interface;
  IXMLINTERTRNRSType = interface;
  IXMLINTERTRNRSTypeList = interface;
  IXMLINTERRSType = interface;
  IXMLINTERMODRSType = interface;
  IXMLINTERCANRSType = interface;
  IXMLRECINTERTRNRSType = interface;
  IXMLRECINTERTRNRSTypeList = interface;
  IXMLRECINTERRSType = interface;
  IXMLRECINTERMODRSType = interface;
  IXMLRECINTERCANRSType = interface;
  IXMLINTERSYNCRSType = interface;
  IXMLINTERSYNCRSTypeList = interface;
  IXMLRECINTERSYNCRSType = interface;
  IXMLRECINTERSYNCRSTypeList = interface;
  IXMLWIREXFERMSGSRSV1Type = interface;
  IXMLWIRETRNRSType = interface;
  IXMLWIRETRNRSTypeList = interface;
  IXMLWIRERSType = interface;
  IXMLWIRECANRSType = interface;
  IXMLWIRESYNCRSType = interface;
  IXMLWIRESYNCRSTypeList = interface;
  IXMLBANKACCTINFOType = interface;
  IXMLCCACCTINFOType = interface;
  IXMLBILLPAYMSGSRQV1Type = interface;
  IXMLPAYEETRNRQType = interface;
  IXMLPAYEETRNRQTypeList = interface;
  IXMLPAYEERQType = interface;
  IXMLPAYEEMODRQType = interface;
  IXMLPAYEEDELRQType = interface;
  IXMLPAYEESYNCRQType = interface;
  IXMLPAYEESYNCRQTypeList = interface;
  IXMLPMTTRNRQType = interface;
  IXMLPMTTRNRQTypeList = interface;
  IXMLPMTRQType = interface;
  IXMLPMTINFOType = interface;
  IXMLEXTDPMTType = interface;
  IXMLEXTDPMTTypeList = interface;
  IXMLEXTDPMTINVType = interface;
  IXMLINVOICEType = interface;
  IXMLDISCOUNTType = interface;
  IXMLADJUSTMENTType = interface;
  IXMLLINEITEMType = interface;
  IXMLLINEITEMTypeList = interface;
  IXMLPMTMODRQType = interface;
  IXMLPMTCANCRQType = interface;
  IXMLRECPMTTRNRQType = interface;
  IXMLRECPMTTRNRQTypeList = interface;
  IXMLRECPMTRQType = interface;
  IXMLRECPMTMODRQType = interface;
  IXMLRECPMTCANCRQType = interface;
  IXMLPMTINQTRNRQType = interface;
  IXMLPMTINQTRNRQTypeList = interface;
  IXMLPMTINQRQType = interface;
  IXMLPMTMAILTRNRQType = interface;
  IXMLPMTMAILTRNRQTypeList = interface;
  IXMLPMTMAILRQType = interface;
  IXMLPMTSYNCRQType = interface;
  IXMLPMTSYNCRQTypeList = interface;
  IXMLRECPMTSYNCRQType = interface;
  IXMLRECPMTSYNCRQTypeList = interface;
  IXMLPMTMAILSYNCRQType = interface;
  IXMLPMTMAILSYNCRQTypeList = interface;
  IXMLBILLPAYMSGSRSV1Type = interface;
  IXMLPAYEETRNRSType = interface;
  IXMLPAYEETRNRSTypeList = interface;
  IXMLPAYEERSType = interface;
  IXMLEXTDPAYEEType = interface;
  IXMLPAYEEMODRSType = interface;
  IXMLPAYEEDELRSType = interface;
  IXMLPAYEESYNCRSType = interface;
  IXMLPAYEESYNCRSTypeList = interface;
  IXMLPMTTRNRSType = interface;
  IXMLPMTTRNRSTypeList = interface;
  IXMLPMTRSType = interface;
  IXMLPMTPRCSTSType = interface;
  IXMLPMTMODRSType = interface;
  IXMLPMTCANCRSType = interface;
  IXMLRECPMTTRNRSType = interface;
  IXMLRECPMTTRNRSTypeList = interface;
  IXMLRECPMTRSType = interface;
  IXMLRECPMTMODRSType = interface;
  IXMLRECPMTCANCRSType = interface;
  IXMLPMTINQTRNRSType = interface;
  IXMLPMTINQTRNRSTypeList = interface;
  IXMLPMTINQRSType = interface;
  IXMLPMTMAILTRNRSType = interface;
  IXMLPMTMAILTRNRSTypeList = interface;
  IXMLPMTMAILRSType = interface;
  IXMLPMTSYNCRSType = interface;
  IXMLPMTSYNCRSTypeList = interface;
  IXMLRECPMTSYNCRSType = interface;
  IXMLRECPMTSYNCRSTypeList = interface;
  IXMLPMTMAILSYNCRSType = interface;
  IXMLPMTMAILSYNCRSTypeList = interface;
  IXMLBILLPAYMSGSETType = interface;
  IXMLBILLPAYMSGSETV1Type = interface;
  IXMLBPACCTINFOType = interface;
  IXMLSIGNUPMSGSRQV1Type = interface;
  IXMLENROLLTRNRQType = interface;
  IXMLENROLLTRNRQTypeList = interface;
  IXMLENROLLRQType = interface;
  IXMLACCTINFOTRNRQType = interface;
  IXMLACCTINFOTRNRQTypeList = interface;
  IXMLACCTINFORQType = interface;
  IXMLCHGUSERINFOTRNRQType = interface;
  IXMLCHGUSERINFOTRNRQTypeList = interface;
  IXMLCHGUSERINFORQType = interface;
  IXMLCHGUSERINFOSYNCRQType = interface;
  IXMLCHGUSERINFOSYNCRQTypeList = interface;
  IXMLACCTTRNRQType = interface;
  IXMLACCTTRNRQTypeList = interface;
  IXMLACCTRQType = interface;
  IXMLSVCADDType = interface;
  IXMLSVCCHGType = interface;
  IXMLSVCDELType = interface;
  IXMLACCTSYNCRQType = interface;
  IXMLACCTSYNCRQTypeList = interface;
  IXMLSIGNUPMSGSRSV1Type = interface;
  IXMLENROLLTRNRSType = interface;
  IXMLENROLLTRNRSTypeList = interface;
  IXMLENROLLRSType = interface;
  IXMLACCTINFOTRNRSType = interface;
  IXMLACCTINFOTRNRSTypeList = interface;
  IXMLACCTINFORSType = interface;
  IXMLACCTINFOType = interface;
  IXMLACCTINFOTypeList = interface;
  IXMLCHGUSERINFOTRNRSType = interface;
  IXMLCHGUSERINFOTRNRSTypeList = interface;
  IXMLCHGUSERINFORSType = interface;
  IXMLCHGUSERINFOSYNCRSType = interface;
  IXMLCHGUSERINFOSYNCRSTypeList = interface;
  IXMLACCTTRNRSType = interface;
  IXMLACCTTRNRSTypeList = interface;
  IXMLACCTRSType = interface;
  IXMLACCTSYNCRSType = interface;
  IXMLACCTSYNCRSTypeList = interface;
  IXMLSIGNUPMSGSETType = interface;
  IXMLSIGNUPMSGSETV1Type = interface;
  IXMLCLIENTENROLLType = interface;
  IXMLWEBENROLLType = interface;
  IXMLOTHERENROLLType = interface;
  IXMLINVSTMTMSGSRQV1Type = interface;
  IXMLINVSTMTTRNRQType = interface;
  IXMLINVSTMTRQType = interface;
  IXMLINVACCTFROMType = interface;
  IXMLINCPOSType = interface;
  IXMLINVMAILTRNRQType = interface;
  IXMLINVMAILTRNRQTypeList = interface;
  IXMLINVMAILRQType = interface;
  IXMLINVMAILSYNCRQType = interface;
  IXMLINVMAILSYNCRQTypeList = interface;
  IXMLINVSTMTMSGSRSV1Type = interface;
  IXMLINVSTMTTRNRSType = interface;
  IXMLINVSTMTTRNRSTypeList = interface;
  IXMLINVSTMTRSType = interface;
  IXMLINVTRANLISTType = interface;
  IXMLBUYDEBTType = interface;
  IXMLBUYDEBTTypeList = interface;
  IXMLINVBUYType = interface;
  IXMLINVTRANType = interface;
  IXMLSECIDType = interface;
  IXMLSUBACCTFUNDType = interface;
  IXMLBUYMFType = interface;
  IXMLBUYMFTypeList = interface;
  IXMLBUYOPTType = interface;
  IXMLBUYOPTTypeList = interface;
  IXMLBUYOTHERType = interface;
  IXMLBUYOTHERTypeList = interface;
  IXMLBUYSTOCKType = interface;
  IXMLBUYSTOCKTypeList = interface;
  IXMLCLOSUREOPTType = interface;
  IXMLCLOSUREOPTTypeList = interface;
  IXMLINCOMEType = interface;
  IXMLINCOMETypeList = interface;
  IXMLINVEXPENSEType = interface;
  IXMLINVEXPENSETypeList = interface;
  IXMLJRNLFUNDType = interface;
  IXMLJRNLFUNDTypeList = interface;
  IXMLJRNLSECType = interface;
  IXMLJRNLSECTypeList = interface;
  IXMLMARGININTERESTType = interface;
  IXMLMARGININTERESTTypeList = interface;
  IXMLREINVESTType = interface;
  IXMLREINVESTTypeList = interface;
  IXMLRETOFCAPType = interface;
  IXMLRETOFCAPTypeList = interface;
  IXMLSELLDEBTType = interface;
  IXMLSELLDEBTTypeList = interface;
  IXMLINVSELLType = interface;
  IXMLSELLMFType = interface;
  IXMLSELLMFTypeList = interface;
  IXMLSELLOPTType = interface;
  IXMLSELLOPTTypeList = interface;
  IXMLSELLOTHERType = interface;
  IXMLSELLOTHERTypeList = interface;
  IXMLSELLSTOCKType = interface;
  IXMLSELLSTOCKTypeList = interface;
  IXMLSPLITType = interface;
  IXMLSPLITTypeList = interface;
  IXMLTRANSFERType = interface;
  IXMLTRANSFERTypeList = interface;
  IXMLINVBANKTRANType = interface;
  IXMLINVBANKTRANTypeList = interface;
  IXMLINVPOSLISTType = interface;
  IXMLPOSMFType = interface;
  IXMLPOSMFTypeList = interface;
  IXMLINVPOSType = interface;
  IXMLPOSSTOCKType = interface;
  IXMLPOSSTOCKTypeList = interface;
  IXMLPOSDEBTType = interface;
  IXMLPOSDEBTTypeList = interface;
  IXMLPOSOPTType = interface;
  IXMLPOSOPTTypeList = interface;
  IXMLPOSOTHERType = interface;
  IXMLPOSOTHERTypeList = interface;
  IXMLINVBALType = interface;
  IXMLBALLISTType = interface;
  IXMLBALType = interface;
  IXMLINVOOLISTType = interface;
  IXMLOOBUYDEBTType = interface;
  IXMLOOBUYDEBTTypeList = interface;
  IXMLOOType = interface;
  IXMLOOBUYMFType = interface;
  IXMLOOBUYMFTypeList = interface;
  IXMLOOBUYOPTType = interface;
  IXMLOOBUYOPTTypeList = interface;
  IXMLOOBUYOTHERType = interface;
  IXMLOOBUYOTHERTypeList = interface;
  IXMLOOBUYSTOCKType = interface;
  IXMLOOBUYSTOCKTypeList = interface;
  IXMLOOSELLDEBTType = interface;
  IXMLOOSELLDEBTTypeList = interface;
  IXMLOOSELLMFType = interface;
  IXMLOOSELLMFTypeList = interface;
  IXMLOOSELLOPTType = interface;
  IXMLOOSELLOPTTypeList = interface;
  IXMLOOSELLOTHERType = interface;
  IXMLOOSELLOTHERTypeList = interface;
  IXMLOOSELLSTOCKType = interface;
  IXMLOOSELLSTOCKTypeList = interface;
  IXMLOOSWITCHMFType = interface;
  IXMLOOSWITCHMFTypeList = interface;
  IXMLINVMAILTRNRSType = interface;
  IXMLINVMAILTRNRSTypeList = interface;
  IXMLINVMAILRSType = interface;
  IXMLINVMAILSYNCRSType = interface;
  IXMLINVMAILSYNCRSTypeList = interface;
  IXMLSECLISTMSGSRQV1Type = interface;
  IXMLSECLISTTRNRQType = interface;
  IXMLSECLISTRQType = interface;
  IXMLSECRQType = interface;
  IXMLSECLISTMSGSRSV1Type = interface;
  IXMLSECLISTTRNRSType = interface;
  IXMLSECLISTTRNRSTypeList = interface;
  IXMLSECLISTType = interface;
  IXMLMFINFOType = interface;
  IXMLMFINFOTypeList = interface;
  IXMLSECINFOType = interface;
  IXMLMFASSETCLASSType = interface;
  IXMLPORTIONType = interface;
  IXMLFIMFASSETCLASSType = interface;
  IXMLFIPORTIONType = interface;
  IXMLSTOCKINFOType = interface;
  IXMLSTOCKINFOTypeList = interface;
  IXMLOPTINFOType = interface;
  IXMLOPTINFOTypeList = interface;
  IXMLDEBTINFOType = interface;
  IXMLDEBTINFOTypeList = interface;
  IXMLOTHERINFOType = interface;
  IXMLOTHERINFOTypeList = interface;
  IXMLINVACCTTOType = interface;
  IXMLINVACCTINFOType = interface;
  IXMLINVSTMTMSGSETType = interface;
  IXMLINVSTMTMSGSETV1Type = interface;
  IXMLSECLISTMSGSETType = interface;
  IXMLSECLISTMSGSETV1Type = interface;
  IXMLEMAILMSGSRQV1Type = interface;
  IXMLMAILTRNRQType = interface;
  IXMLMAILTRNRQTypeList = interface;
  IXMLMAILRQType = interface;
  IXMLMAILSYNCRQType = interface;
  IXMLMAILSYNCRQTypeList = interface;
  IXMLGETMIMETRNRQType = interface;
  IXMLGETMIMETRNRQTypeList = interface;
  IXMLGETMIMERQType = interface;
  IXMLEMAILMSGSRSV1Type = interface;
  IXMLMAILTRNRSType = interface;
  IXMLMAILTRNRSTypeList = interface;
  IXMLMAILRSType = interface;
  IXMLMAILSYNCRSType = interface;
  IXMLMAILSYNCRSTypeList = interface;
  IXMLGETMIMETRNRSType = interface;
  IXMLGETMIMETRNRSTypeList = interface;
  IXMLGETMIMERSType = interface;
  IXMLEMAILMSGSETType = interface;
  IXMLEMAILMSGSETV1Type = interface;
  IXMLPROFMSGSRQV1Type = interface;
  IXMLPROFTRNRQType = interface;
  IXMLPROFRQType = interface;
  IXMLPROFMSGSRSV1Type = interface;
  IXMLPROFTRNRSType = interface;
  IXMLPROFRSType = interface;
  IXMLMSGSETLISTType = interface;
  IXMLSIGNONINFOLISTType = interface;
  IXMLSIGNONINFOType = interface;
  IXMLPROFMSGSETType = interface;
  IXMLPROFMSGSETV1Type = interface;
  IXMLOFXType = interface;
  IXMLString_List = interface;

{ IXMLSIGNONMSGSRQV1Type }

  IXMLSIGNONMSGSRQV1Type = interface(IXMLNode)
    ['{C8EFC399-E521-4B21-A3E8-DD0C80F6B7A1}']
    { Property Accessors }
    function GetSONRQ: IXMLSONRQType;
    function GetPINCHTRNRQ: IXMLPINCHTRNRQType;
    function GetCHALLENGETRNRQ: IXMLCHALLENGETRNRQType;
    { Methods & Properties }
    property SONRQ: IXMLSONRQType read GetSONRQ;
    property PINCHTRNRQ: IXMLPINCHTRNRQType read GetPINCHTRNRQ;
    property CHALLENGETRNRQ: IXMLCHALLENGETRNRQType read GetCHALLENGETRNRQ;
  end;

{ IXMLSONRQType }

  IXMLSONRQType = interface(IXMLNode)
    ['{1F2462F0-9B59-4301-87F7-D468B66A74E2}']
    { Property Accessors }
    function GetDTCLIENT: UnicodeString;
    function GetUSERID: UnicodeString;
    function GetUSERPASS: UnicodeString;
    function GetUSERKEY: UnicodeString;
    function GetGENUSERKEY: UnicodeString;
    function GetLANGUAGE: UnicodeString;
    function GetFI: IXMLFIType;
    function GetSESSCOOKIE: UnicodeString;
    function GetAPPID: UnicodeString;
    function GetAPPVER: UnicodeString;
    procedure SetDTCLIENT(Value: UnicodeString);
    procedure SetUSERID(Value: UnicodeString);
    procedure SetUSERPASS(Value: UnicodeString);
    procedure SetUSERKEY(Value: UnicodeString);
    procedure SetGENUSERKEY(Value: UnicodeString);
    procedure SetLANGUAGE(Value: UnicodeString);
    procedure SetSESSCOOKIE(Value: UnicodeString);
    procedure SetAPPID(Value: UnicodeString);
    procedure SetAPPVER(Value: UnicodeString);
    { Methods & Properties }
    property DTCLIENT: UnicodeString read GetDTCLIENT write SetDTCLIENT;
    property USERID: UnicodeString read GetUSERID write SetUSERID;
    property USERPASS: UnicodeString read GetUSERPASS write SetUSERPASS;
    property USERKEY: UnicodeString read GetUSERKEY write SetUSERKEY;
    property GENUSERKEY: UnicodeString read GetGENUSERKEY write SetGENUSERKEY;
    property LANGUAGE: UnicodeString read GetLANGUAGE write SetLANGUAGE;
    property FI: IXMLFIType read GetFI;
    property SESSCOOKIE: UnicodeString read GetSESSCOOKIE write SetSESSCOOKIE;
    property APPID: UnicodeString read GetAPPID write SetAPPID;
    property APPVER: UnicodeString read GetAPPVER write SetAPPVER;
  end;

{ IXMLFIType }

  IXMLFIType = interface(IXMLNode)
    ['{5309F765-AE34-421F-A1FC-ECC131E1B178}']
    { Property Accessors }
    function GetORG: UnicodeString;
    function GetFID: UnicodeString;
    procedure SetORG(Value: UnicodeString);
    procedure SetFID(Value: UnicodeString);
    { Methods & Properties }
    property ORG: UnicodeString read GetORG write SetORG;
    property FID: UnicodeString read GetFID write SetFID;
  end;

{ IXMLPINCHTRNRQType }

  IXMLPINCHTRNRQType = interface(IXMLNode)
    ['{62FC6B78-0882-432C-BA25-AD940F4A7FB7}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetPINCHRQ: IXMLPINCHRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property PINCHRQ: IXMLPINCHRQType read GetPINCHRQ;
  end;

{ IXMLPINCHRQType }

  IXMLPINCHRQType = interface(IXMLNode)
    ['{43157456-1C83-4E33-B3A0-A204DBD0A46A}']
    { Property Accessors }
    function GetUSERID: UnicodeString;
    function GetNEWUSERPASS: UnicodeString;
    procedure SetUSERID(Value: UnicodeString);
    procedure SetNEWUSERPASS(Value: UnicodeString);
    { Methods & Properties }
    property USERID: UnicodeString read GetUSERID write SetUSERID;
    property NEWUSERPASS: UnicodeString read GetNEWUSERPASS write SetNEWUSERPASS;
  end;

{ IXMLCHALLENGETRNRQType }

  IXMLCHALLENGETRNRQType = interface(IXMLNode)
    ['{22FACA73-FA8C-4EF7-81C4-672E80486D0C}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetCHALLENGERQ: IXMLCHALLENGERQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property CHALLENGERQ: IXMLCHALLENGERQType read GetCHALLENGERQ;
  end;

{ IXMLCHALLENGERQType }

  IXMLCHALLENGERQType = interface(IXMLNode)
    ['{2561913F-6C6C-422E-9514-52F581FDA096}']
    { Property Accessors }
    function GetUSERID: UnicodeString;
    function GetFICERTID: UnicodeString;
    procedure SetUSERID(Value: UnicodeString);
    procedure SetFICERTID(Value: UnicodeString);
    { Methods & Properties }
    property USERID: UnicodeString read GetUSERID write SetUSERID;
    property FICERTID: UnicodeString read GetFICERTID write SetFICERTID;
  end;

{ IXMLSIGNONMSGSRSV1Type }

  IXMLSIGNONMSGSRSV1Type = interface(IXMLNode)
    ['{72A95FDC-9A45-4208-96D1-6A5BD0DFDB4F}']
    { Property Accessors }
    function GetSONRS: IXMLSONRSType;
    function GetPINCHTRNRS: IXMLPINCHTRNRSType;
    function GetCHALLENGETRNRS: IXMLCHALLENGETRNRSType;
    { Methods & Properties }
    property SONRS: IXMLSONRSType read GetSONRS;
    property PINCHTRNRS: IXMLPINCHTRNRSType read GetPINCHTRNRS;
    property CHALLENGETRNRS: IXMLCHALLENGETRNRSType read GetCHALLENGETRNRS;
  end;

{ IXMLSONRSType }

  IXMLSONRSType = interface(IXMLNode)
    ['{B36FEDD2-2C68-49E7-99A5-8E5929135742}']
    { Property Accessors }
    function GetSTATUS: IXMLSTATUSType;
    function GetDTSERVER: UnicodeString;
    function GetUSERKEY: UnicodeString;
    function GetTSKEYEXPIRE: UnicodeString;
    function GetLANGUAGE: UnicodeString;
    function GetDTPROFUP: UnicodeString;
    function GetDTACCTUP: UnicodeString;
    function GetFI: IXMLFIType;
    function GetSESSCOOKIE: UnicodeString;
    procedure SetDTSERVER(Value: UnicodeString);
    procedure SetUSERKEY(Value: UnicodeString);
    procedure SetTSKEYEXPIRE(Value: UnicodeString);
    procedure SetLANGUAGE(Value: UnicodeString);
    procedure SetDTPROFUP(Value: UnicodeString);
    procedure SetDTACCTUP(Value: UnicodeString);
    procedure SetSESSCOOKIE(Value: UnicodeString);
    { Methods & Properties }
    property STATUS: IXMLSTATUSType read GetSTATUS;
    property DTSERVER: UnicodeString read GetDTSERVER write SetDTSERVER;
    property USERKEY: UnicodeString read GetUSERKEY write SetUSERKEY;
    property TSKEYEXPIRE: UnicodeString read GetTSKEYEXPIRE write SetTSKEYEXPIRE;
    property LANGUAGE: UnicodeString read GetLANGUAGE write SetLANGUAGE;
    property DTPROFUP: UnicodeString read GetDTPROFUP write SetDTPROFUP;
    property DTACCTUP: UnicodeString read GetDTACCTUP write SetDTACCTUP;
    property FI: IXMLFIType read GetFI;
    property SESSCOOKIE: UnicodeString read GetSESSCOOKIE write SetSESSCOOKIE;
  end;

{ IXMLSTATUSType }

  IXMLSTATUSType = interface(IXMLNode)
    ['{EC105628-B112-49E6-99F8-DCC3B181B62A}']
    { Property Accessors }
    function GetCODE: UnicodeString;
    function GetSEVERITY: UnicodeString;
    function GetMESSAGE: UnicodeString;
    procedure SetCODE(Value: UnicodeString);
    procedure SetSEVERITY(Value: UnicodeString);
    procedure SetMESSAGE(Value: UnicodeString);
    { Methods & Properties }
    property CODE: UnicodeString read GetCODE write SetCODE;
    property SEVERITY: UnicodeString read GetSEVERITY write SetSEVERITY;
    property MESSAGE: UnicodeString read GetMESSAGE write SetMESSAGE;
  end;

{ IXMLPINCHTRNRSType }

  IXMLPINCHTRNRSType = interface(IXMLNode)
    ['{326BBD1D-BA2C-4CE5-8D36-A4FDDA078136}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetPINCHRS: IXMLPINCHRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property PINCHRS: IXMLPINCHRSType read GetPINCHRS;
  end;

{ IXMLPINCHRSType }

  IXMLPINCHRSType = interface(IXMLNode)
    ['{C9AE43B0-95BB-4B9C-872F-17494B14AAE7}']
    { Property Accessors }
    function GetUSERID: UnicodeString;
    function GetDTCHANGED: UnicodeString;
    procedure SetUSERID(Value: UnicodeString);
    procedure SetDTCHANGED(Value: UnicodeString);
    { Methods & Properties }
    property USERID: UnicodeString read GetUSERID write SetUSERID;
    property DTCHANGED: UnicodeString read GetDTCHANGED write SetDTCHANGED;
  end;

{ IXMLCHALLENGETRNRSType }

  IXMLCHALLENGETRNRSType = interface(IXMLNode)
    ['{BF4FEBB5-6FD5-4E33-A191-0A399F9960E2}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetCHALLENGERS: IXMLCHALLENGERSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property CHALLENGERS: IXMLCHALLENGERSType read GetCHALLENGERS;
  end;

{ IXMLCHALLENGERSType }

  IXMLCHALLENGERSType = interface(IXMLNode)
    ['{50FF236C-7A0D-44BF-9C03-6E9FFDBE121F}']
    { Property Accessors }
    function GetUSERID: UnicodeString;
    function GetNONCE: UnicodeString;
    function GetFICERTID: UnicodeString;
    procedure SetUSERID(Value: UnicodeString);
    procedure SetNONCE(Value: UnicodeString);
    procedure SetFICERTID(Value: UnicodeString);
    { Methods & Properties }
    property USERID: UnicodeString read GetUSERID write SetUSERID;
    property NONCE: UnicodeString read GetNONCE write SetNONCE;
    property FICERTID: UnicodeString read GetFICERTID write SetFICERTID;
  end;

{ IXMLSIGNONMSGSETType }

  IXMLSIGNONMSGSETType = interface(IXMLNode)
    ['{22435D1C-BD2F-4B90-BC07-375E22C6AA65}']
    { Property Accessors }
    function GetSIGNONMSGSETV1: IXMLSIGNONMSGSETV1Type;
    { Methods & Properties }
    property SIGNONMSGSETV1: IXMLSIGNONMSGSETV1Type read GetSIGNONMSGSETV1;
  end;

{ IXMLSIGNONMSGSETV1Type }

  IXMLSIGNONMSGSETV1Type = interface(IXMLNode)
    ['{B222662B-23A8-4090-BCE8-C0071FF43BBF}']
    { Property Accessors }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    { Methods & Properties }
    property MSGSETCORE: IXMLMSGSETCOREType read GetMSGSETCORE;
  end;

{ IXMLMSGSETCOREType }

  IXMLMSGSETCOREType = interface(IXMLNode)
    ['{DA494EE8-0B40-432B-AB8E-58C2E496D1B4}']
    { Property Accessors }
    function GetVER: UnicodeString;
    function GetURL: UnicodeString;
    function GetOFXSEC: UnicodeString;
    function GetTRANSPSEC: UnicodeString;
    function GetSIGNONREALM: UnicodeString;
    function GetLANGUAGE: IXMLString_List;
    function GetSYNCMODE: UnicodeString;
    function GetRESPFILEER: UnicodeString;
    function GetSPNAME: UnicodeString;
    procedure SetVER(Value: UnicodeString);
    procedure SetURL(Value: UnicodeString);
    procedure SetOFXSEC(Value: UnicodeString);
    procedure SetTRANSPSEC(Value: UnicodeString);
    procedure SetSIGNONREALM(Value: UnicodeString);
    procedure SetSYNCMODE(Value: UnicodeString);
    procedure SetRESPFILEER(Value: UnicodeString);
    procedure SetSPNAME(Value: UnicodeString);
    { Methods & Properties }
    property VER: UnicodeString read GetVER write SetVER;
    property URL: UnicodeString read GetURL write SetURL;
    property OFXSEC: UnicodeString read GetOFXSEC write SetOFXSEC;
    property TRANSPSEC: UnicodeString read GetTRANSPSEC write SetTRANSPSEC;
    property SIGNONREALM: UnicodeString read GetSIGNONREALM write SetSIGNONREALM;
    property LANGUAGE: IXMLString_List read GetLANGUAGE;
    property SYNCMODE: UnicodeString read GetSYNCMODE write SetSYNCMODE;
    property RESPFILEER: UnicodeString read GetRESPFILEER write SetRESPFILEER;
    property SPNAME: UnicodeString read GetSPNAME write SetSPNAME;
  end;

{ IXMLBANKMSGSETType }

  IXMLBANKMSGSETType = interface(IXMLNode)
    ['{C8C08B64-66C2-4C7A-8413-BB82C409732B}']
    { Property Accessors }
    function GetBANKMSGSETV1: IXMLBANKMSGSETV1Type;
    { Methods & Properties }
    property BANKMSGSETV1: IXMLBANKMSGSETV1Type read GetBANKMSGSETV1;
  end;

{ IXMLBANKMSGSETV1Type }

  IXMLBANKMSGSETV1Type = interface(IXMLNode)
    ['{A1F13B0F-DC28-4FA7-BC70-FD947F7D8E84}']
    { Property Accessors }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetINVALIDACCTTYPE: IXMLString_List;
    function GetCLOSINGAVAIL: UnicodeString;
    function GetXFERPROF: IXMLXFERPROFType;
    function GetSTPCHKPROF: IXMLSTPCHKPROFType;
    function GetEMAILPROF: IXMLEMAILPROFType;
    procedure SetCLOSINGAVAIL(Value: UnicodeString);
    { Methods & Properties }
    property MSGSETCORE: IXMLMSGSETCOREType read GetMSGSETCORE;
    property INVALIDACCTTYPE: IXMLString_List read GetINVALIDACCTTYPE;
    property CLOSINGAVAIL: UnicodeString read GetCLOSINGAVAIL write SetCLOSINGAVAIL;
    property XFERPROF: IXMLXFERPROFType read GetXFERPROF;
    property STPCHKPROF: IXMLSTPCHKPROFType read GetSTPCHKPROF;
    property EMAILPROF: IXMLEMAILPROFType read GetEMAILPROF;
  end;

{ IXMLXFERPROFType }

  IXMLXFERPROFType = interface(IXMLNode)
    ['{BFA50269-1766-4B2F-9B5B-87A0975DF21E}']
    { Property Accessors }
    function GetPROCDAYSOFF: IXMLString_List;
    function GetPROCENDTM: UnicodeString;
    function GetCANSCHED: UnicodeString;
    function GetCANRECUR: UnicodeString;
    function GetCANMODXFERS: UnicodeString;
    function GetCANMODMDLS: UnicodeString;
    function GetMODELWND: UnicodeString;
    function GetDAYSWITH: UnicodeString;
    function GetDFLTDAYSTOPAY: UnicodeString;
    procedure SetPROCENDTM(Value: UnicodeString);
    procedure SetCANSCHED(Value: UnicodeString);
    procedure SetCANRECUR(Value: UnicodeString);
    procedure SetCANMODXFERS(Value: UnicodeString);
    procedure SetCANMODMDLS(Value: UnicodeString);
    procedure SetMODELWND(Value: UnicodeString);
    procedure SetDAYSWITH(Value: UnicodeString);
    procedure SetDFLTDAYSTOPAY(Value: UnicodeString);
    { Methods & Properties }
    property PROCDAYSOFF: IXMLString_List read GetPROCDAYSOFF;
    property PROCENDTM: UnicodeString read GetPROCENDTM write SetPROCENDTM;
    property CANSCHED: UnicodeString read GetCANSCHED write SetCANSCHED;
    property CANRECUR: UnicodeString read GetCANRECUR write SetCANRECUR;
    property CANMODXFERS: UnicodeString read GetCANMODXFERS write SetCANMODXFERS;
    property CANMODMDLS: UnicodeString read GetCANMODMDLS write SetCANMODMDLS;
    property MODELWND: UnicodeString read GetMODELWND write SetMODELWND;
    property DAYSWITH: UnicodeString read GetDAYSWITH write SetDAYSWITH;
    property DFLTDAYSTOPAY: UnicodeString read GetDFLTDAYSTOPAY write SetDFLTDAYSTOPAY;
  end;

{ IXMLSTPCHKPROFType }

  IXMLSTPCHKPROFType = interface(IXMLNode)
    ['{57B740A0-3134-4122-9846-3D99F3BB2A19}']
    { Property Accessors }
    function GetPROCDAYSOFF: IXMLString_List;
    function GetPROCENDTM: UnicodeString;
    function GetCANUSERANGE: UnicodeString;
    function GetCANUSEDESC: UnicodeString;
    function GetSTPCHKFEE: UnicodeString;
    procedure SetPROCENDTM(Value: UnicodeString);
    procedure SetCANUSERANGE(Value: UnicodeString);
    procedure SetCANUSEDESC(Value: UnicodeString);
    procedure SetSTPCHKFEE(Value: UnicodeString);
    { Methods & Properties }
    property PROCDAYSOFF: IXMLString_List read GetPROCDAYSOFF;
    property PROCENDTM: UnicodeString read GetPROCENDTM write SetPROCENDTM;
    property CANUSERANGE: UnicodeString read GetCANUSERANGE write SetCANUSERANGE;
    property CANUSEDESC: UnicodeString read GetCANUSEDESC write SetCANUSEDESC;
    property STPCHKFEE: UnicodeString read GetSTPCHKFEE write SetSTPCHKFEE;
  end;

{ IXMLEMAILPROFType }

  IXMLEMAILPROFType = interface(IXMLNode)
    ['{8A389B7F-5A38-4F93-9A3B-02E382A1898A}']
    { Property Accessors }
    function GetCANEMAIL: UnicodeString;
    function GetCANNOTIFY: UnicodeString;
    procedure SetCANEMAIL(Value: UnicodeString);
    procedure SetCANNOTIFY(Value: UnicodeString);
    { Methods & Properties }
    property CANEMAIL: UnicodeString read GetCANEMAIL write SetCANEMAIL;
    property CANNOTIFY: UnicodeString read GetCANNOTIFY write SetCANNOTIFY;
  end;

{ IXMLCREDITCARDMSGSETType }

  IXMLCREDITCARDMSGSETType = interface(IXMLNode)
    ['{E0DAF238-3FFC-44C2-A41F-9A47832C303A}']
    { Property Accessors }
    function GetCREDITCARDMSGSETV1: IXMLCREDITCARDMSGSETV1Type;
    { Methods & Properties }
    property CREDITCARDMSGSETV1: IXMLCREDITCARDMSGSETV1Type read GetCREDITCARDMSGSETV1;
  end;

{ IXMLCREDITCARDMSGSETV1Type }

  IXMLCREDITCARDMSGSETV1Type = interface(IXMLNode)
    ['{9207182A-AC37-440F-BE8E-829F6E6E0E21}']
    { Property Accessors }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetCLOSINGAVAIL: UnicodeString;
    procedure SetCLOSINGAVAIL(Value: UnicodeString);
    { Methods & Properties }
    property MSGSETCORE: IXMLMSGSETCOREType read GetMSGSETCORE;
    property CLOSINGAVAIL: UnicodeString read GetCLOSINGAVAIL write SetCLOSINGAVAIL;
  end;

{ IXMLINTERXFERMSGSETType }

  IXMLINTERXFERMSGSETType = interface(IXMLNode)
    ['{54844E09-7ED5-40B1-AD0C-68A3F538304F}']
    { Property Accessors }
    function GetINTERXFERMSGSETV1: IXMLINTERXFERMSGSETV1Type;
    { Methods & Properties }
    property INTERXFERMSGSETV1: IXMLINTERXFERMSGSETV1Type read GetINTERXFERMSGSETV1;
  end;

{ IXMLINTERXFERMSGSETV1Type }

  IXMLINTERXFERMSGSETV1Type = interface(IXMLNode)
    ['{78AFFA3E-C38A-446E-9ECF-C8FE68B00CC9}']
    { Property Accessors }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetXFERPROF: IXMLXFERPROFType;
    function GetCANBILLPAY: UnicodeString;
    function GetCANCELWND: UnicodeString;
    function GetDOMXFERFEE: UnicodeString;
    function GetINTLXFERFEE: UnicodeString;
    procedure SetCANBILLPAY(Value: UnicodeString);
    procedure SetCANCELWND(Value: UnicodeString);
    procedure SetDOMXFERFEE(Value: UnicodeString);
    procedure SetINTLXFERFEE(Value: UnicodeString);
    { Methods & Properties }
    property MSGSETCORE: IXMLMSGSETCOREType read GetMSGSETCORE;
    property XFERPROF: IXMLXFERPROFType read GetXFERPROF;
    property CANBILLPAY: UnicodeString read GetCANBILLPAY write SetCANBILLPAY;
    property CANCELWND: UnicodeString read GetCANCELWND write SetCANCELWND;
    property DOMXFERFEE: UnicodeString read GetDOMXFERFEE write SetDOMXFERFEE;
    property INTLXFERFEE: UnicodeString read GetINTLXFERFEE write SetINTLXFERFEE;
  end;

{ IXMLWIREXFERMSGSETType }

  IXMLWIREXFERMSGSETType = interface(IXMLNode)
    ['{A1D4BFD4-1632-464A-8B7F-DC7793A173B2}']
    { Property Accessors }
    function GetWIREXFERMSGSETV1: IXMLWIREXFERMSGSETV1Type;
    { Methods & Properties }
    property WIREXFERMSGSETV1: IXMLWIREXFERMSGSETV1Type read GetWIREXFERMSGSETV1;
  end;

{ IXMLWIREXFERMSGSETV1Type }

  IXMLWIREXFERMSGSETV1Type = interface(IXMLNode)
    ['{338DF99D-FD47-42EB-A171-20A5DBB5531C}']
    { Property Accessors }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetPROCDAYSOFF: IXMLString_List;
    function GetPROCENDTM: UnicodeString;
    function GetCANSCHED: UnicodeString;
    function GetDOMXFERFEE: UnicodeString;
    function GetINTLXFERFEE: UnicodeString;
    procedure SetPROCENDTM(Value: UnicodeString);
    procedure SetCANSCHED(Value: UnicodeString);
    procedure SetDOMXFERFEE(Value: UnicodeString);
    procedure SetINTLXFERFEE(Value: UnicodeString);
    { Methods & Properties }
    property MSGSETCORE: IXMLMSGSETCOREType read GetMSGSETCORE;
    property PROCDAYSOFF: IXMLString_List read GetPROCDAYSOFF;
    property PROCENDTM: UnicodeString read GetPROCENDTM write SetPROCENDTM;
    property CANSCHED: UnicodeString read GetCANSCHED write SetCANSCHED;
    property DOMXFERFEE: UnicodeString read GetDOMXFERFEE write SetDOMXFERFEE;
    property INTLXFERFEE: UnicodeString read GetINTLXFERFEE write SetINTLXFERFEE;
  end;

{ IXMLBANKMSGSRQV1Type }

  IXMLBANKMSGSRQV1Type = interface(IXMLNode)
    ['{C50E40BD-E1A3-445F-BCDD-419D4FB50195}']
    { Property Accessors }
    function GetSTMTTRNRQ: IXMLSTMTTRNRQTypeList;
    function GetSTMTENDTRNRQ: IXMLSTMTENDTRNRQTypeList;
    function GetINTRATRNRQ: IXMLINTRATRNRQTypeList;
    function GetRECINTRATRNRQ: IXMLRECINTRATRNRQTypeList;
    function GetSTPCHKTRNRQ: IXMLSTPCHKTRNRQTypeList;
    function GetBANKMAILTRNRQ: IXMLBANKMAILTRNRQTypeList;
    function GetBANKMAILSYNCRQ: IXMLBANKMAILSYNCRQTypeList;
    function GetSTPCHKSYNCRQ: IXMLSTPCHKSYNCRQTypeList;
    function GetINTRASYNCRQ: IXMLINTRASYNCRQTypeList;
    function GetRECINTRASYNCRQ: IXMLRECINTRASYNCRQTypeList;
    { Methods & Properties }
    property STMTTRNRQ: IXMLSTMTTRNRQTypeList read GetSTMTTRNRQ;
    property STMTENDTRNRQ: IXMLSTMTENDTRNRQTypeList read GetSTMTENDTRNRQ;
    property INTRATRNRQ: IXMLINTRATRNRQTypeList read GetINTRATRNRQ;
    property RECINTRATRNRQ: IXMLRECINTRATRNRQTypeList read GetRECINTRATRNRQ;
    property STPCHKTRNRQ: IXMLSTPCHKTRNRQTypeList read GetSTPCHKTRNRQ;
    property BANKMAILTRNRQ: IXMLBANKMAILTRNRQTypeList read GetBANKMAILTRNRQ;
    property BANKMAILSYNCRQ: IXMLBANKMAILSYNCRQTypeList read GetBANKMAILSYNCRQ;
    property STPCHKSYNCRQ: IXMLSTPCHKSYNCRQTypeList read GetSTPCHKSYNCRQ;
    property INTRASYNCRQ: IXMLINTRASYNCRQTypeList read GetINTRASYNCRQ;
    property RECINTRASYNCRQ: IXMLRECINTRASYNCRQTypeList read GetRECINTRASYNCRQ;
  end;

{ IXMLSTMTTRNRQType }

  IXMLSTMTTRNRQType = interface(IXMLNode)
    ['{9171EF6B-B0A7-44A0-9DB7-6DEC7AEDF25E}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetSTMTRQ: IXMLSTMTRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property STMTRQ: IXMLSTMTRQType read GetSTMTRQ;
  end;

{ IXMLSTMTTRNRQTypeList }

  IXMLSTMTTRNRQTypeList = interface(IXMLNodeCollection)
    ['{972A2EAF-65FD-45B5-8328-9DA47379076E}']
    { Methods & Properties }
    function Add: IXMLSTMTTRNRQType;
    function Insert(const Index: Integer): IXMLSTMTTRNRQType;

    function GetItem(Index: Integer): IXMLSTMTTRNRQType;
    property Items[Index: Integer]: IXMLSTMTTRNRQType read GetItem; default;
  end;

{ IXMLSTMTRQType }

  IXMLSTMTRQType = interface(IXMLNode)
    ['{79FDD2EC-37EC-4BE1-A5D6-5DBD1E24F5F4}']
    { Property Accessors }
    function GetBANKACCTFROM: UnicodeString;
    function GetINCTRAN: IXMLINCTRANType;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property INCTRAN: IXMLINCTRANType read GetINCTRAN;
  end;

{ IXMLINCTRANType }

  IXMLINCTRANType = interface(IXMLNode)
    ['{7486E611-2BCF-4A6D-A1D4-8F32485D29EB}']
    { Property Accessors }
    function GetDTSTART: UnicodeString;
    function GetDTEND: UnicodeString;
    function GetINCLUDE: UnicodeString;
    procedure SetDTSTART(Value: UnicodeString);
    procedure SetDTEND(Value: UnicodeString);
    procedure SetINCLUDE(Value: UnicodeString);
    { Methods & Properties }
    property DTSTART: UnicodeString read GetDTSTART write SetDTSTART;
    property DTEND: UnicodeString read GetDTEND write SetDTEND;
    property INCLUDE: UnicodeString read GetINCLUDE write SetINCLUDE;
  end;

{ IXMLSTMTENDTRNRQType }

  IXMLSTMTENDTRNRQType = interface(IXMLNode)
    ['{703EB4BF-7955-4F36-9B58-4542E6566A1C}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetSTMTENDRQ: IXMLSTMTENDRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property STMTENDRQ: IXMLSTMTENDRQType read GetSTMTENDRQ;
  end;

{ IXMLSTMTENDTRNRQTypeList }

  IXMLSTMTENDTRNRQTypeList = interface(IXMLNodeCollection)
    ['{1389DE8E-614A-44B7-BF41-D0BADA92975B}']
    { Methods & Properties }
    function Add: IXMLSTMTENDTRNRQType;
    function Insert(const Index: Integer): IXMLSTMTENDTRNRQType;

    function GetItem(Index: Integer): IXMLSTMTENDTRNRQType;
    property Items[Index: Integer]: IXMLSTMTENDTRNRQType read GetItem; default;
  end;

{ IXMLSTMTENDRQType }

  IXMLSTMTENDRQType = interface(IXMLNode)
    ['{3D330795-C7A1-4DB1-8BD3-78AD0D0420FA}']
    { Property Accessors }
    function GetBANKACCTFROM: UnicodeString;
    function GetDTSTART: UnicodeString;
    function GetDTEND: UnicodeString;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetDTSTART(Value: UnicodeString);
    procedure SetDTEND(Value: UnicodeString);
    { Methods & Properties }
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property DTSTART: UnicodeString read GetDTSTART write SetDTSTART;
    property DTEND: UnicodeString read GetDTEND write SetDTEND;
  end;

{ IXMLINTRATRNRQType }

  IXMLINTRATRNRQType = interface(IXMLNode)
    ['{9ABB9030-44B1-4B8D-BC22-47067BBF26F6}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetINTRARQ: IXMLINTRARQType;
    function GetINTRAMODRQ: IXMLINTRAMODRQType;
    function GetINTRACANRQ: IXMLINTRACANRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property INTRARQ: IXMLINTRARQType read GetINTRARQ;
    property INTRAMODRQ: IXMLINTRAMODRQType read GetINTRAMODRQ;
    property INTRACANRQ: IXMLINTRACANRQType read GetINTRACANRQ;
  end;

{ IXMLINTRATRNRQTypeList }

  IXMLINTRATRNRQTypeList = interface(IXMLNodeCollection)
    ['{ED2E7EA5-6E1D-4A43-AE64-5EED70AB4ACC}']
    { Methods & Properties }
    function Add: IXMLINTRATRNRQType;
    function Insert(const Index: Integer): IXMLINTRATRNRQType;

    function GetItem(Index: Integer): IXMLINTRATRNRQType;
    property Items[Index: Integer]: IXMLINTRATRNRQType read GetItem; default;
  end;

{ IXMLINTRARQType }

  IXMLINTRARQType = interface(IXMLNode)
    ['{F60D6A6F-9280-49CA-ADD9-B4BE74DA480A}']
    { Property Accessors }
    function GetXFERINFO: IXMLXFERINFOType;
    { Methods & Properties }
    property XFERINFO: IXMLXFERINFOType read GetXFERINFO;
  end;

{ IXMLXFERINFOType }

  IXMLXFERINFOType = interface(IXMLNode)
    ['{53F3F8BA-821F-473C-95D5-0DDB6892AE97}']
    { Property Accessors }
    function GetBANKACCTFROM: UnicodeString;
    function GetCCACCTFROM: UnicodeString;
    function GetBANKACCTTO: UnicodeString;
    function GetCCACCTTO: UnicodeString;
    function GetTRNAMT: UnicodeString;
    function GetDTDUE: UnicodeString;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetCCACCTFROM(Value: UnicodeString);
    procedure SetBANKACCTTO(Value: UnicodeString);
    procedure SetCCACCTTO(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
    procedure SetDTDUE(Value: UnicodeString);
    { Methods & Properties }
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property CCACCTFROM: UnicodeString read GetCCACCTFROM write SetCCACCTFROM;
    property BANKACCTTO: UnicodeString read GetBANKACCTTO write SetBANKACCTTO;
    property CCACCTTO: UnicodeString read GetCCACCTTO write SetCCACCTTO;
    property TRNAMT: UnicodeString read GetTRNAMT write SetTRNAMT;
    property DTDUE: UnicodeString read GetDTDUE write SetDTDUE;
  end;

{ IXMLINTRAMODRQType }

  IXMLINTRAMODRQType = interface(IXMLNode)
    ['{0F35EF1C-B123-4F8A-B9B6-3A35C01FC0A1}']
    { Property Accessors }
    function GetSRVRTID: UnicodeString;
    function GetXFERINFO: IXMLXFERINFOType;
    procedure SetSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
    property XFERINFO: IXMLXFERINFOType read GetXFERINFO;
  end;

{ IXMLINTRACANRQType }

  IXMLINTRACANRQType = interface(IXMLNode)
    ['{DC03268A-4C9F-4A65-B7A2-C683EB6B3207}']
    { Property Accessors }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
  end;

{ IXMLRECINTRATRNRQType }

  IXMLRECINTRATRNRQType = interface(IXMLNode)
    ['{D0739723-DBFF-4B17-B941-9DD2712916F1}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetRECINTRARQ: IXMLRECINTRARQType;
    function GetRECINTRAMODRQ: IXMLRECINTRAMODRQType;
    function GetRECINTRACANRQ: IXMLRECINTRACANRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property RECINTRARQ: IXMLRECINTRARQType read GetRECINTRARQ;
    property RECINTRAMODRQ: IXMLRECINTRAMODRQType read GetRECINTRAMODRQ;
    property RECINTRACANRQ: IXMLRECINTRACANRQType read GetRECINTRACANRQ;
  end;

{ IXMLRECINTRATRNRQTypeList }

  IXMLRECINTRATRNRQTypeList = interface(IXMLNodeCollection)
    ['{051909D4-32B0-4873-BC44-16BEA48990BC}']
    { Methods & Properties }
    function Add: IXMLRECINTRATRNRQType;
    function Insert(const Index: Integer): IXMLRECINTRATRNRQType;

    function GetItem(Index: Integer): IXMLRECINTRATRNRQType;
    property Items[Index: Integer]: IXMLRECINTRATRNRQType read GetItem; default;
  end;

{ IXMLRECINTRARQType }

  IXMLRECINTRARQType = interface(IXMLNode)
    ['{D61E20D7-B34E-4D66-9412-CCBC42E41E0D}']
    { Property Accessors }
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetINTRARQ: IXMLINTRARQType;
    { Methods & Properties }
    property RECURRINST: IXMLRECURRINSTType read GetRECURRINST;
    property INTRARQ: IXMLINTRARQType read GetINTRARQ;
  end;

{ IXMLRECURRINSTType }

  IXMLRECURRINSTType = interface(IXMLNode)
    ['{26EAFF50-68D7-41F1-813E-D2373A9402C1}']
    { Property Accessors }
    function GetNINSTS: UnicodeString;
    function GetFREQ: UnicodeString;
    procedure SetNINSTS(Value: UnicodeString);
    procedure SetFREQ(Value: UnicodeString);
    { Methods & Properties }
    property NINSTS: UnicodeString read GetNINSTS write SetNINSTS;
    property FREQ: UnicodeString read GetFREQ write SetFREQ;
  end;

{ IXMLRECINTRAMODRQType }

  IXMLRECINTRAMODRQType = interface(IXMLNode)
    ['{FFCAE602-4FBA-4F18-A1AB-57850FCAF15C}']
    { Property Accessors }
    function GetRECSRVRTID: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetINTRARQ: IXMLINTRARQType;
    function GetMODPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetMODPENDING(Value: UnicodeString);
    { Methods & Properties }
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
    property RECURRINST: IXMLRECURRINSTType read GetRECURRINST;
    property INTRARQ: IXMLINTRARQType read GetINTRARQ;
    property MODPENDING: UnicodeString read GetMODPENDING write SetMODPENDING;
  end;

{ IXMLRECINTRACANRQType }

  IXMLRECINTRACANRQType = interface(IXMLNode)
    ['{8797CEAA-CCA8-4040-9C98-9751E761DBEF}']
    { Property Accessors }
    function GetRECSRVRTID: UnicodeString;
    function GetCANPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetCANPENDING(Value: UnicodeString);
    { Methods & Properties }
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
    property CANPENDING: UnicodeString read GetCANPENDING write SetCANPENDING;
  end;

{ IXMLSTPCHKTRNRQType }

  IXMLSTPCHKTRNRQType = interface(IXMLNode)
    ['{B3B571EB-7579-4486-A534-036BB6A2AACD}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetSTPCHKRQ: IXMLSTPCHKRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property STPCHKRQ: IXMLSTPCHKRQType read GetSTPCHKRQ;
  end;

{ IXMLSTPCHKTRNRQTypeList }

  IXMLSTPCHKTRNRQTypeList = interface(IXMLNodeCollection)
    ['{C2128960-42B0-45F2-AB6E-3912A3FF34B2}']
    { Methods & Properties }
    function Add: IXMLSTPCHKTRNRQType;
    function Insert(const Index: Integer): IXMLSTPCHKTRNRQType;

    function GetItem(Index: Integer): IXMLSTPCHKTRNRQType;
    property Items[Index: Integer]: IXMLSTPCHKTRNRQType read GetItem; default;
  end;

{ IXMLSTPCHKRQType }

  IXMLSTPCHKRQType = interface(IXMLNode)
    ['{3891C010-42AA-4C6F-8E51-4D1E9CE87362}']
    { Property Accessors }
    function GetBANKACCTFROM: UnicodeString;
    function GetCHKRANGE: IXMLCHKRANGEType;
    function GetCHKDESC: IXMLCHKDESCType;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property CHKRANGE: IXMLCHKRANGEType read GetCHKRANGE;
    property CHKDESC: IXMLCHKDESCType read GetCHKDESC;
  end;

{ IXMLCHKRANGEType }

  IXMLCHKRANGEType = interface(IXMLNode)
    ['{897FB40E-1457-40F4-8DE8-684D6E8E2670}']
    { Property Accessors }
    function GetCHKNUMSTART: UnicodeString;
    function GetCHKNUMEND: UnicodeString;
    procedure SetCHKNUMSTART(Value: UnicodeString);
    procedure SetCHKNUMEND(Value: UnicodeString);
    { Methods & Properties }
    property CHKNUMSTART: UnicodeString read GetCHKNUMSTART write SetCHKNUMSTART;
    property CHKNUMEND: UnicodeString read GetCHKNUMEND write SetCHKNUMEND;
  end;

{ IXMLCHKDESCType }

  IXMLCHKDESCType = interface(IXMLNode)
    ['{E1A0F4FF-D831-4F96-A9BB-6173E65653C8}']
    { Property Accessors }
    function GetNAME: UnicodeString;
    function GetCHECKNUM: UnicodeString;
    function GetDTUSER: UnicodeString;
    function GetTRNAMT: UnicodeString;
    procedure SetNAME(Value: UnicodeString);
    procedure SetCHECKNUM(Value: UnicodeString);
    procedure SetDTUSER(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
    { Methods & Properties }
    property NAME: UnicodeString read GetNAME write SetNAME;
    property CHECKNUM: UnicodeString read GetCHECKNUM write SetCHECKNUM;
    property DTUSER: UnicodeString read GetDTUSER write SetDTUSER;
    property TRNAMT: UnicodeString read GetTRNAMT write SetTRNAMT;
  end;

{ IXMLBANKMAILTRNRQType }

  IXMLBANKMAILTRNRQType = interface(IXMLNode)
    ['{925F8EAC-1056-4C80-8A2F-36E8A3FAC8D4}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetBANKMAILRQ: IXMLBANKMAILRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property BANKMAILRQ: IXMLBANKMAILRQType read GetBANKMAILRQ;
  end;

{ IXMLBANKMAILTRNRQTypeList }

  IXMLBANKMAILTRNRQTypeList = interface(IXMLNodeCollection)
    ['{C78968C5-E328-4F1B-A56C-302949BA1E72}']
    { Methods & Properties }
    function Add: IXMLBANKMAILTRNRQType;
    function Insert(const Index: Integer): IXMLBANKMAILTRNRQType;

    function GetItem(Index: Integer): IXMLBANKMAILTRNRQType;
    property Items[Index: Integer]: IXMLBANKMAILTRNRQType read GetItem; default;
  end;

{ IXMLBANKMAILRQType }

  IXMLBANKMAILRQType = interface(IXMLNode)
    ['{3C4F17F6-71A3-4724-8811-B155556D6B81}']
    { Property Accessors }
    function GetBANKACCTFROM: UnicodeString;
    function GetCCACCTFROM: UnicodeString;
    function GetMAIL: IXMLMAILType;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetCCACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property CCACCTFROM: UnicodeString read GetCCACCTFROM write SetCCACCTFROM;
    property MAIL: IXMLMAILType read GetMAIL;
  end;

{ IXMLMAILType }

  IXMLMAILType = interface(IXMLNode)
    ['{2D649AD1-1EE9-4398-95B6-8C26C18097D5}']
    { Property Accessors }
    function GetUSERID: UnicodeString;
    function GetDTCREATED: UnicodeString;
    function GetFROM: UnicodeString;
    function GetTO_: UnicodeString;
    function GetSUBJECT: UnicodeString;
    function GetMSGBODY: UnicodeString;
    function GetINCIMAGES: UnicodeString;
    function GetUSEHTML: UnicodeString;
    procedure SetUSERID(Value: UnicodeString);
    procedure SetDTCREATED(Value: UnicodeString);
    procedure SetFROM(Value: UnicodeString);
    procedure SetTO_(Value: UnicodeString);
    procedure SetSUBJECT(Value: UnicodeString);
    procedure SetMSGBODY(Value: UnicodeString);
    procedure SetINCIMAGES(Value: UnicodeString);
    procedure SetUSEHTML(Value: UnicodeString);
    { Methods & Properties }
    property USERID: UnicodeString read GetUSERID write SetUSERID;
    property DTCREATED: UnicodeString read GetDTCREATED write SetDTCREATED;
    property FROM: UnicodeString read GetFROM write SetFROM;
    property TO_: UnicodeString read GetTO_ write SetTO_;
    property SUBJECT: UnicodeString read GetSUBJECT write SetSUBJECT;
    property MSGBODY: UnicodeString read GetMSGBODY write SetMSGBODY;
    property INCIMAGES: UnicodeString read GetINCIMAGES write SetINCIMAGES;
    property USEHTML: UnicodeString read GetUSEHTML write SetUSEHTML;
  end;

{ IXMLBANKMAILSYNCRQType }

  IXMLBANKMAILSYNCRQType = interface(IXMLNode)
    ['{1B1C9491-77BA-49FD-A866-0A71F9BA9573}']
    { Property Accessors }
    function GetSYNCRQMACRO: UnicodeString;
    function GetINCIMAGES: UnicodeString;
    function GetUSEHTML: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetCCACCTFROM: UnicodeString;
    function GetBANKMAILTRNRQ: IXMLBANKMAILTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetINCIMAGES(Value: UnicodeString);
    procedure SetUSEHTML(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetCCACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRQMACRO: UnicodeString read GetSYNCRQMACRO write SetSYNCRQMACRO;
    property INCIMAGES: UnicodeString read GetINCIMAGES write SetINCIMAGES;
    property USEHTML: UnicodeString read GetUSEHTML write SetUSEHTML;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property CCACCTFROM: UnicodeString read GetCCACCTFROM write SetCCACCTFROM;
    property BANKMAILTRNRQ: IXMLBANKMAILTRNRQTypeList read GetBANKMAILTRNRQ;
  end;

{ IXMLBANKMAILSYNCRQTypeList }

  IXMLBANKMAILSYNCRQTypeList = interface(IXMLNodeCollection)
    ['{51224F88-ED3F-4BF3-AF54-6478A0B77C56}']
    { Methods & Properties }
    function Add: IXMLBANKMAILSYNCRQType;
    function Insert(const Index: Integer): IXMLBANKMAILSYNCRQType;

    function GetItem(Index: Integer): IXMLBANKMAILSYNCRQType;
    property Items[Index: Integer]: IXMLBANKMAILSYNCRQType read GetItem; default;
  end;

{ IXMLSTPCHKSYNCRQType }

  IXMLSTPCHKSYNCRQType = interface(IXMLNode)
    ['{3B15F3E3-2F22-4F45-B01B-9EE7C873D08E}']
    { Property Accessors }
    function GetSYNCRQMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetSTPCHKTRNRQ: IXMLSTPCHKTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRQMACRO: UnicodeString read GetSYNCRQMACRO write SetSYNCRQMACRO;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property STPCHKTRNRQ: IXMLSTPCHKTRNRQTypeList read GetSTPCHKTRNRQ;
  end;

{ IXMLSTPCHKSYNCRQTypeList }

  IXMLSTPCHKSYNCRQTypeList = interface(IXMLNodeCollection)
    ['{9C0C1028-8847-49D1-8295-59165206082C}']
    { Methods & Properties }
    function Add: IXMLSTPCHKSYNCRQType;
    function Insert(const Index: Integer): IXMLSTPCHKSYNCRQType;

    function GetItem(Index: Integer): IXMLSTPCHKSYNCRQType;
    property Items[Index: Integer]: IXMLSTPCHKSYNCRQType read GetItem; default;
  end;

{ IXMLINTRASYNCRQType }

  IXMLINTRASYNCRQType = interface(IXMLNode)
    ['{8DA9B80C-55FA-42C6-BEB3-192B5C4F7543}']
    { Property Accessors }
    function GetSYNCRQMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetINTRATRNRQ: IXMLINTRATRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRQMACRO: UnicodeString read GetSYNCRQMACRO write SetSYNCRQMACRO;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property INTRATRNRQ: IXMLINTRATRNRQTypeList read GetINTRATRNRQ;
  end;

{ IXMLINTRASYNCRQTypeList }

  IXMLINTRASYNCRQTypeList = interface(IXMLNodeCollection)
    ['{0BC3DE68-66E0-4284-87A9-DED447F33966}']
    { Methods & Properties }
    function Add: IXMLINTRASYNCRQType;
    function Insert(const Index: Integer): IXMLINTRASYNCRQType;

    function GetItem(Index: Integer): IXMLINTRASYNCRQType;
    property Items[Index: Integer]: IXMLINTRASYNCRQType read GetItem; default;
  end;

{ IXMLRECINTRASYNCRQType }

  IXMLRECINTRASYNCRQType = interface(IXMLNode)
    ['{FF7B04EB-FEE3-47D6-89C6-9E672B117C14}']
    { Property Accessors }
    function GetSYNCRQMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetRECINTRATRNRQ: IXMLRECINTRATRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRQMACRO: UnicodeString read GetSYNCRQMACRO write SetSYNCRQMACRO;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property RECINTRATRNRQ: IXMLRECINTRATRNRQTypeList read GetRECINTRATRNRQ;
  end;

{ IXMLRECINTRASYNCRQTypeList }

  IXMLRECINTRASYNCRQTypeList = interface(IXMLNodeCollection)
    ['{B1D13BAF-93B2-4E24-AD39-6668B6831A09}']
    { Methods & Properties }
    function Add: IXMLRECINTRASYNCRQType;
    function Insert(const Index: Integer): IXMLRECINTRASYNCRQType;

    function GetItem(Index: Integer): IXMLRECINTRASYNCRQType;
    property Items[Index: Integer]: IXMLRECINTRASYNCRQType read GetItem; default;
  end;

{ IXMLCREDITCARDMSGSRQV1Type }

  IXMLCREDITCARDMSGSRQV1Type = interface(IXMLNode)
    ['{80292E50-F80C-45E5-8999-9AD7E71B264F}']
    { Property Accessors }
    function GetCCSTMTTRNRQ: IXMLCCSTMTTRNRQTypeList;
    function GetCCSTMTENDTRNRQ: IXMLCCSTMTENDTRNRQTypeList;
    { Methods & Properties }
    property CCSTMTTRNRQ: IXMLCCSTMTTRNRQTypeList read GetCCSTMTTRNRQ;
    property CCSTMTENDTRNRQ: IXMLCCSTMTENDTRNRQTypeList read GetCCSTMTENDTRNRQ;
  end;

{ IXMLCCSTMTTRNRQType }

  IXMLCCSTMTTRNRQType = interface(IXMLNode)
    ['{7B85363A-DB49-4C64-A912-299AA9C7EB5B}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetCCSTMTRQ: IXMLCCSTMTRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property CCSTMTRQ: IXMLCCSTMTRQType read GetCCSTMTRQ;
  end;

{ IXMLCCSTMTTRNRQTypeList }

  IXMLCCSTMTTRNRQTypeList = interface(IXMLNodeCollection)
    ['{95D48343-889F-42C8-9815-0E8DB798018B}']
    { Methods & Properties }
    function Add: IXMLCCSTMTTRNRQType;
    function Insert(const Index: Integer): IXMLCCSTMTTRNRQType;

    function GetItem(Index: Integer): IXMLCCSTMTTRNRQType;
    property Items[Index: Integer]: IXMLCCSTMTTRNRQType read GetItem; default;
  end;

{ IXMLCCSTMTRQType }

  IXMLCCSTMTRQType = interface(IXMLNode)
    ['{268EFFF6-078B-41AA-95ED-E5E176F6DE4A}']
    { Property Accessors }
    function GetCCACCTFROM: UnicodeString;
    function GetINCTRAN: IXMLINCTRANType;
    procedure SetCCACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property CCACCTFROM: UnicodeString read GetCCACCTFROM write SetCCACCTFROM;
    property INCTRAN: IXMLINCTRANType read GetINCTRAN;
  end;

{ IXMLCCSTMTENDTRNRQType }

  IXMLCCSTMTENDTRNRQType = interface(IXMLNode)
    ['{A8E8E57E-D571-4E86-898C-AD25DC0755D4}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetCCSTMTENDRQ: IXMLCCSTMTENDRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property CCSTMTENDRQ: IXMLCCSTMTENDRQType read GetCCSTMTENDRQ;
  end;

{ IXMLCCSTMTENDTRNRQTypeList }

  IXMLCCSTMTENDTRNRQTypeList = interface(IXMLNodeCollection)
    ['{A3A52AB4-6E3D-49EE-B902-15CB026E0416}']
    { Methods & Properties }
    function Add: IXMLCCSTMTENDTRNRQType;
    function Insert(const Index: Integer): IXMLCCSTMTENDTRNRQType;

    function GetItem(Index: Integer): IXMLCCSTMTENDTRNRQType;
    property Items[Index: Integer]: IXMLCCSTMTENDTRNRQType read GetItem; default;
  end;

{ IXMLCCSTMTENDRQType }

  IXMLCCSTMTENDRQType = interface(IXMLNode)
    ['{F258ACB0-8B53-4777-BD13-0021978CD8C5}']
    { Property Accessors }
    function GetCCACCTFROM: UnicodeString;
    function GetDTSTART: UnicodeString;
    function GetDTEND: UnicodeString;
    procedure SetCCACCTFROM(Value: UnicodeString);
    procedure SetDTSTART(Value: UnicodeString);
    procedure SetDTEND(Value: UnicodeString);
    { Methods & Properties }
    property CCACCTFROM: UnicodeString read GetCCACCTFROM write SetCCACCTFROM;
    property DTSTART: UnicodeString read GetDTSTART write SetDTSTART;
    property DTEND: UnicodeString read GetDTEND write SetDTEND;
  end;

{ IXMLINTERXFERMSGSRQV1Type }

  IXMLINTERXFERMSGSRQV1Type = interface(IXMLNode)
    ['{22855742-8529-4D96-A57C-0C49E4D865D3}']
    { Property Accessors }
    function GetINTERTRNRQ: IXMLINTERTRNRQTypeList;
    function GetRECINTERTRNRQ: IXMLRECINTERTRNRQTypeList;
    function GetINTERSYNCRQ: IXMLINTERSYNCRQTypeList;
    function GetRECINTERSYNCRQ: IXMLRECINTERSYNCRQTypeList;
    { Methods & Properties }
    property INTERTRNRQ: IXMLINTERTRNRQTypeList read GetINTERTRNRQ;
    property RECINTERTRNRQ: IXMLRECINTERTRNRQTypeList read GetRECINTERTRNRQ;
    property INTERSYNCRQ: IXMLINTERSYNCRQTypeList read GetINTERSYNCRQ;
    property RECINTERSYNCRQ: IXMLRECINTERSYNCRQTypeList read GetRECINTERSYNCRQ;
  end;

{ IXMLINTERTRNRQType }

  IXMLINTERTRNRQType = interface(IXMLNode)
    ['{B2F6706C-B28B-4377-AC61-3CFDC0C49523}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetINTERRQ: IXMLINTERRQType;
    function GetINTERMODRQ: IXMLINTERMODRQType;
    function GetINTERCANRQ: IXMLINTERCANRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property INTERRQ: IXMLINTERRQType read GetINTERRQ;
    property INTERMODRQ: IXMLINTERMODRQType read GetINTERMODRQ;
    property INTERCANRQ: IXMLINTERCANRQType read GetINTERCANRQ;
  end;

{ IXMLINTERTRNRQTypeList }

  IXMLINTERTRNRQTypeList = interface(IXMLNodeCollection)
    ['{C927CFF9-B134-48F1-8CE7-A6539A8D8C30}']
    { Methods & Properties }
    function Add: IXMLINTERTRNRQType;
    function Insert(const Index: Integer): IXMLINTERTRNRQType;

    function GetItem(Index: Integer): IXMLINTERTRNRQType;
    property Items[Index: Integer]: IXMLINTERTRNRQType read GetItem; default;
  end;

{ IXMLINTERRQType }

  IXMLINTERRQType = interface(IXMLNode)
    ['{32198055-6078-4C7E-BD2F-13C181909536}']
    { Property Accessors }
    function GetXFERINFO: IXMLXFERINFOType;
    { Methods & Properties }
    property XFERINFO: IXMLXFERINFOType read GetXFERINFO;
  end;

{ IXMLINTERMODRQType }

  IXMLINTERMODRQType = interface(IXMLNode)
    ['{1A2EC955-80F0-41B4-B8D7-ABF5D3B7398F}']
    { Property Accessors }
    function GetSRVRTID: UnicodeString;
    function GetXFERINFO: IXMLXFERINFOType;
    procedure SetSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
    property XFERINFO: IXMLXFERINFOType read GetXFERINFO;
  end;

{ IXMLINTERCANRQType }

  IXMLINTERCANRQType = interface(IXMLNode)
    ['{EC6C8522-146B-4D72-BB5D-2CCAC3C69144}']
    { Property Accessors }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
  end;

{ IXMLRECINTERTRNRQType }

  IXMLRECINTERTRNRQType = interface(IXMLNode)
    ['{C8F4CAD7-29CE-42BF-AD53-FBD63CA3707D}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetRECINTERRQ: IXMLRECINTERRQType;
    function GetRECINTERMODRQ: IXMLRECINTERMODRQType;
    function GetRECINTERCANRQ: IXMLRECINTERCANRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property RECINTERRQ: IXMLRECINTERRQType read GetRECINTERRQ;
    property RECINTERMODRQ: IXMLRECINTERMODRQType read GetRECINTERMODRQ;
    property RECINTERCANRQ: IXMLRECINTERCANRQType read GetRECINTERCANRQ;
  end;

{ IXMLRECINTERTRNRQTypeList }

  IXMLRECINTERTRNRQTypeList = interface(IXMLNodeCollection)
    ['{E8F70C09-24E4-46EE-8A63-0663B79EF31A}']
    { Methods & Properties }
    function Add: IXMLRECINTERTRNRQType;
    function Insert(const Index: Integer): IXMLRECINTERTRNRQType;

    function GetItem(Index: Integer): IXMLRECINTERTRNRQType;
    property Items[Index: Integer]: IXMLRECINTERTRNRQType read GetItem; default;
  end;

{ IXMLRECINTERRQType }

  IXMLRECINTERRQType = interface(IXMLNode)
    ['{AD41B4C7-690A-4A2A-A550-33A92CCF68D2}']
    { Property Accessors }
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetINTERRQ: IXMLINTERRQType;
    { Methods & Properties }
    property RECURRINST: IXMLRECURRINSTType read GetRECURRINST;
    property INTERRQ: IXMLINTERRQType read GetINTERRQ;
  end;

{ IXMLRECINTERMODRQType }

  IXMLRECINTERMODRQType = interface(IXMLNode)
    ['{61E6BC21-46AF-45F5-A5C1-DDA086BE9B71}']
    { Property Accessors }
    function GetRECSRVRTID: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetINTERRQ: IXMLINTERRQType;
    function GetMODPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetMODPENDING(Value: UnicodeString);
    { Methods & Properties }
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
    property RECURRINST: IXMLRECURRINSTType read GetRECURRINST;
    property INTERRQ: IXMLINTERRQType read GetINTERRQ;
    property MODPENDING: UnicodeString read GetMODPENDING write SetMODPENDING;
  end;

{ IXMLRECINTERCANRQType }

  IXMLRECINTERCANRQType = interface(IXMLNode)
    ['{12280304-94D0-448F-AB05-7AED4D9986C9}']
    { Property Accessors }
    function GetRECSRVRTID: UnicodeString;
    function GetCANPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetCANPENDING(Value: UnicodeString);
    { Methods & Properties }
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
    property CANPENDING: UnicodeString read GetCANPENDING write SetCANPENDING;
  end;

{ IXMLINTERSYNCRQType }

  IXMLINTERSYNCRQType = interface(IXMLNode)
    ['{6AE25555-DCCB-4647-8B1F-F9833004B900}']
    { Property Accessors }
    function GetSYNCRQMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetINTERTRNRQ: IXMLINTERTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRQMACRO: UnicodeString read GetSYNCRQMACRO write SetSYNCRQMACRO;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property INTERTRNRQ: IXMLINTERTRNRQTypeList read GetINTERTRNRQ;
  end;

{ IXMLINTERSYNCRQTypeList }

  IXMLINTERSYNCRQTypeList = interface(IXMLNodeCollection)
    ['{7AAADB0D-A153-4BAB-8787-ABFE94617CA0}']
    { Methods & Properties }
    function Add: IXMLINTERSYNCRQType;
    function Insert(const Index: Integer): IXMLINTERSYNCRQType;

    function GetItem(Index: Integer): IXMLINTERSYNCRQType;
    property Items[Index: Integer]: IXMLINTERSYNCRQType read GetItem; default;
  end;

{ IXMLRECINTERSYNCRQType }

  IXMLRECINTERSYNCRQType = interface(IXMLNode)
    ['{0A335EF8-3160-4A8C-8497-BA009B5AE13A}']
    { Property Accessors }
    function GetSYNCRQMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetRECINTERTRNRQ: IXMLRECINTERTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRQMACRO: UnicodeString read GetSYNCRQMACRO write SetSYNCRQMACRO;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property RECINTERTRNRQ: IXMLRECINTERTRNRQTypeList read GetRECINTERTRNRQ;
  end;

{ IXMLRECINTERSYNCRQTypeList }

  IXMLRECINTERSYNCRQTypeList = interface(IXMLNodeCollection)
    ['{6CEF1715-E93B-42DC-88E3-B2AD9DA8F40B}']
    { Methods & Properties }
    function Add: IXMLRECINTERSYNCRQType;
    function Insert(const Index: Integer): IXMLRECINTERSYNCRQType;

    function GetItem(Index: Integer): IXMLRECINTERSYNCRQType;
    property Items[Index: Integer]: IXMLRECINTERSYNCRQType read GetItem; default;
  end;

{ IXMLWIREXFERMSGSRQV1Type }

  IXMLWIREXFERMSGSRQV1Type = interface(IXMLNode)
    ['{0C9B7130-32D8-4F93-AB9B-D75615FF4607}']
    { Property Accessors }
    function GetWIRETRNRQ: IXMLWIRETRNRQTypeList;
    function GetWIRESYNCRQ: IXMLWIRESYNCRQTypeList;
    { Methods & Properties }
    property WIRETRNRQ: IXMLWIRETRNRQTypeList read GetWIRETRNRQ;
    property WIRESYNCRQ: IXMLWIRESYNCRQTypeList read GetWIRESYNCRQ;
  end;

{ IXMLWIRETRNRQType }

  IXMLWIRETRNRQType = interface(IXMLNode)
    ['{2631A42C-E97A-4984-A6CB-514AC3CB9C7D}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetWIRERQ: IXMLWIRERQType;
    function GetWIRECANRQ: IXMLWIRECANRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property WIRERQ: IXMLWIRERQType read GetWIRERQ;
    property WIRECANRQ: IXMLWIRECANRQType read GetWIRECANRQ;
  end;

{ IXMLWIRETRNRQTypeList }

  IXMLWIRETRNRQTypeList = interface(IXMLNodeCollection)
    ['{043A8596-F876-4D28-872D-BD09A9D38DB4}']
    { Methods & Properties }
    function Add: IXMLWIRETRNRQType;
    function Insert(const Index: Integer): IXMLWIRETRNRQType;

    function GetItem(Index: Integer): IXMLWIRETRNRQType;
    property Items[Index: Integer]: IXMLWIRETRNRQType read GetItem; default;
  end;

{ IXMLWIRERQType }

  IXMLWIRERQType = interface(IXMLNode)
    ['{135F1970-2D0B-4DE8-A28F-80C88FA4A0FB}']
    { Property Accessors }
    function GetBANKACCTFROM: UnicodeString;
    function GetWIREBENEFICIARY: IXMLWIREBENEFICIARYType;
    function GetWIREDESTBANK: IXMLWIREDESTBANKType;
    function GetTRNAMT: UnicodeString;
    function GetDTDUE: UnicodeString;
    function GetPAYINSTRUCT: UnicodeString;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
    procedure SetDTDUE(Value: UnicodeString);
    procedure SetPAYINSTRUCT(Value: UnicodeString);
    { Methods & Properties }
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property WIREBENEFICIARY: IXMLWIREBENEFICIARYType read GetWIREBENEFICIARY;
    property WIREDESTBANK: IXMLWIREDESTBANKType read GetWIREDESTBANK;
    property TRNAMT: UnicodeString read GetTRNAMT write SetTRNAMT;
    property DTDUE: UnicodeString read GetDTDUE write SetDTDUE;
    property PAYINSTRUCT: UnicodeString read GetPAYINSTRUCT write SetPAYINSTRUCT;
  end;

{ IXMLWIREBENEFICIARYType }

  IXMLWIREBENEFICIARYType = interface(IXMLNode)
    ['{2D277A26-1BF8-4704-8E7A-97FC3C0D1A16}']
    { Property Accessors }
    function GetNAME: UnicodeString;
    function GetBANKACCTTO: UnicodeString;
    function GetMEMO: UnicodeString;
    procedure SetNAME(Value: UnicodeString);
    procedure SetBANKACCTTO(Value: UnicodeString);
    procedure SetMEMO(Value: UnicodeString);
    { Methods & Properties }
    property NAME: UnicodeString read GetNAME write SetNAME;
    property BANKACCTTO: UnicodeString read GetBANKACCTTO write SetBANKACCTTO;
    property MEMO: UnicodeString read GetMEMO write SetMEMO;
  end;

{ IXMLWIREDESTBANKType }

  IXMLWIREDESTBANKType = interface(IXMLNode)
    ['{330BB3F9-32EE-4608-BAB6-CA374A1A0846}']
    { Property Accessors }
    function GetEXTBANKDESC: IXMLEXTBANKDESCType;
    { Methods & Properties }
    property EXTBANKDESC: IXMLEXTBANKDESCType read GetEXTBANKDESC;
  end;

{ IXMLEXTBANKDESCType }

  IXMLEXTBANKDESCType = interface(IXMLNode)
    ['{9CE342DF-1158-42B3-91AF-6421CBB25BC7}']
    { Property Accessors }
    function GetNAME: UnicodeString;
    function GetBANKID: UnicodeString;
    function GetADDR1: UnicodeString;
    function GetADDR2: UnicodeString;
    function GetADDR3: UnicodeString;
    function GetCITY: UnicodeString;
    function GetSTATE: UnicodeString;
    function GetPOSTALCODE: UnicodeString;
    function GetCOUNTRY: UnicodeString;
    function GetPHONE: UnicodeString;
    procedure SetNAME(Value: UnicodeString);
    procedure SetBANKID(Value: UnicodeString);
    procedure SetADDR1(Value: UnicodeString);
    procedure SetADDR2(Value: UnicodeString);
    procedure SetADDR3(Value: UnicodeString);
    procedure SetCITY(Value: UnicodeString);
    procedure SetSTATE(Value: UnicodeString);
    procedure SetPOSTALCODE(Value: UnicodeString);
    procedure SetCOUNTRY(Value: UnicodeString);
    procedure SetPHONE(Value: UnicodeString);
    { Methods & Properties }
    property NAME: UnicodeString read GetNAME write SetNAME;
    property BANKID: UnicodeString read GetBANKID write SetBANKID;
    property ADDR1: UnicodeString read GetADDR1 write SetADDR1;
    property ADDR2: UnicodeString read GetADDR2 write SetADDR2;
    property ADDR3: UnicodeString read GetADDR3 write SetADDR3;
    property CITY: UnicodeString read GetCITY write SetCITY;
    property STATE: UnicodeString read GetSTATE write SetSTATE;
    property POSTALCODE: UnicodeString read GetPOSTALCODE write SetPOSTALCODE;
    property COUNTRY: UnicodeString read GetCOUNTRY write SetCOUNTRY;
    property PHONE: UnicodeString read GetPHONE write SetPHONE;
  end;

{ IXMLWIRECANRQType }

  IXMLWIRECANRQType = interface(IXMLNode)
    ['{16A0AC87-F887-48CB-B2E7-7C94FE4AB9B4}']
    { Property Accessors }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
  end;

{ IXMLWIRESYNCRQType }

  IXMLWIRESYNCRQType = interface(IXMLNode)
    ['{4F815E78-EC20-44F8-8AE8-B78BB492A5A4}']
    { Property Accessors }
    function GetSYNCRQMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetWIRETRNRQ: IXMLWIRETRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRQMACRO: UnicodeString read GetSYNCRQMACRO write SetSYNCRQMACRO;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property WIRETRNRQ: IXMLWIRETRNRQTypeList read GetWIRETRNRQ;
  end;

{ IXMLWIRESYNCRQTypeList }

  IXMLWIRESYNCRQTypeList = interface(IXMLNodeCollection)
    ['{6B59290B-D5D8-4EF6-9A48-FC05A809D609}']
    { Methods & Properties }
    function Add: IXMLWIRESYNCRQType;
    function Insert(const Index: Integer): IXMLWIRESYNCRQType;

    function GetItem(Index: Integer): IXMLWIRESYNCRQType;
    property Items[Index: Integer]: IXMLWIRESYNCRQType read GetItem; default;
  end;

{ IXMLBANKMSGSRSV1Type }

  IXMLBANKMSGSRSV1Type = interface(IXMLNode)
    ['{C69CB9AD-04AE-47AA-99FC-7BA0E57C6160}']
    { Property Accessors }
    function GetSTMTTRNRS: IXMLSTMTTRNRSTypeList;
    function GetSTMTENDTRNRS: IXMLSTMTENDTRNRSTypeList;
    function GetINTRATRNRS: IXMLINTRATRNRSTypeList;
    function GetRECINTRATRNRS: IXMLRECINTRATRNRSTypeList;
    function GetSTPCHKTRNRS: IXMLSTPCHKTRNRSTypeList;
    function GetBANKMAILTRNRS: IXMLBANKMAILTRNRSTypeList;
    function GetBANKMAILSYNCRS: IXMLBANKMAILSYNCRSTypeList;
    function GetSTPCHKSYNCRS: IXMLSTPCHKSYNCRSTypeList;
    function GetINTRASYNCRS: IXMLINTRASYNCRSTypeList;
    function GetRECINTRASYNCRS: IXMLRECINTRASYNCRSTypeList;
    { Methods & Properties }
    property STMTTRNRS: IXMLSTMTTRNRSTypeList read GetSTMTTRNRS;
    property STMTENDTRNRS: IXMLSTMTENDTRNRSTypeList read GetSTMTENDTRNRS;
    property INTRATRNRS: IXMLINTRATRNRSTypeList read GetINTRATRNRS;
    property RECINTRATRNRS: IXMLRECINTRATRNRSTypeList read GetRECINTRATRNRS;
    property STPCHKTRNRS: IXMLSTPCHKTRNRSTypeList read GetSTPCHKTRNRS;
    property BANKMAILTRNRS: IXMLBANKMAILTRNRSTypeList read GetBANKMAILTRNRS;
    property BANKMAILSYNCRS: IXMLBANKMAILSYNCRSTypeList read GetBANKMAILSYNCRS;
    property STPCHKSYNCRS: IXMLSTPCHKSYNCRSTypeList read GetSTPCHKSYNCRS;
    property INTRASYNCRS: IXMLINTRASYNCRSTypeList read GetINTRASYNCRS;
    property RECINTRASYNCRS: IXMLRECINTRASYNCRSTypeList read GetRECINTRASYNCRS;
  end;

{ IXMLSTMTTRNRSType }

  IXMLSTMTTRNRSType = interface(IXMLNode)
    ['{9C672F2E-EDAE-4E10-8406-47D3D8B30F27}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetSTMTRS: IXMLSTMTRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property STMTRS: IXMLSTMTRSType read GetSTMTRS;
  end;

{ IXMLSTMTTRNRSTypeList }

  IXMLSTMTTRNRSTypeList = interface(IXMLNodeCollection)
    ['{0D923469-8D06-4A65-8DBD-5CA3165F6451}']
    { Methods & Properties }
    function Add: IXMLSTMTTRNRSType;
    function Insert(const Index: Integer): IXMLSTMTTRNRSType;

    function GetItem(Index: Integer): IXMLSTMTTRNRSType;
    property Items[Index: Integer]: IXMLSTMTTRNRSType read GetItem; default;
  end;

{ IXMLSTMTRSType }

  IXMLSTMTRSType = interface(IXMLNode)
    ['{492CA68E-D0A0-4776-BBAA-1DFF8F70A3AC}']
    { Property Accessors }
    function GetCURDEF: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetBANKTRANLIST: IXMLBANKTRANLISTType;
    function GetLEDGERBAL: IXMLLEDGERBALType;
    function GetAVAILBAL: IXMLAVAILBALType;
    function GetMKTGINFO: UnicodeString;
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetMKTGINFO(Value: UnicodeString);
    { Methods & Properties }
    property CURDEF: UnicodeString read GetCURDEF write SetCURDEF;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property BANKTRANLIST: IXMLBANKTRANLISTType read GetBANKTRANLIST;
    property LEDGERBAL: IXMLLEDGERBALType read GetLEDGERBAL;
    property AVAILBAL: IXMLAVAILBALType read GetAVAILBAL;
    property MKTGINFO: UnicodeString read GetMKTGINFO write SetMKTGINFO;
  end;

{ IXMLBANKTRANLISTType }

  IXMLBANKTRANLISTType = interface(IXMLNode)
    ['{4EE136A1-CF12-4F77-823B-E6D6A6755B14}']
    { Property Accessors }
    function GetDTSTART: UnicodeString;
    function GetDTEND: UnicodeString;
    function GetSTMTTRN: IXMLSTMTTRNTypeList;
    procedure SetDTSTART(Value: UnicodeString);
    procedure SetDTEND(Value: UnicodeString);
    { Methods & Properties }
    property DTSTART: UnicodeString read GetDTSTART write SetDTSTART;
    property DTEND: UnicodeString read GetDTEND write SetDTEND;
    property STMTTRN: IXMLSTMTTRNTypeList read GetSTMTTRN;
  end;

{ IXMLSTMTTRNType }

  IXMLSTMTTRNType = interface(IXMLNode)
    ['{38568D9D-0017-4539-B936-E1DA8F898C45}']
    { Property Accessors }
    function GetTRNTYPE: UnicodeString;
    function GetDTPOSTED: UnicodeString;
    function GetDTUSER: UnicodeString;
    function GetDTAVAIL: UnicodeString;
    function GetTRNAMT: UnicodeString;
    function GetFITID: UnicodeString;
    function GetCORRECTFITID: UnicodeString;
    function GetCORRECTACTION: UnicodeString;
    function GetSRVRTID: UnicodeString;
    function GetCHECKNUM: UnicodeString;
    function GetREFNUM: UnicodeString;
    function GetSIC: UnicodeString;
    function GetPAYEEID: UnicodeString;
    function GetNAME: UnicodeString;
    function GetPAYEE: IXMLPAYEEType;
    function GetBANKACCTTO: UnicodeString;
    function GetCCACCTTO: UnicodeString;
    function GetMEMO: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetTRNTYPE(Value: UnicodeString);
    procedure SetDTPOSTED(Value: UnicodeString);
    procedure SetDTUSER(Value: UnicodeString);
    procedure SetDTAVAIL(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
    procedure SetFITID(Value: UnicodeString);
    procedure SetCORRECTFITID(Value: UnicodeString);
    procedure SetCORRECTACTION(Value: UnicodeString);
    procedure SetSRVRTID(Value: UnicodeString);
    procedure SetCHECKNUM(Value: UnicodeString);
    procedure SetREFNUM(Value: UnicodeString);
    procedure SetSIC(Value: UnicodeString);
    procedure SetPAYEEID(Value: UnicodeString);
    procedure SetNAME(Value: UnicodeString);
    procedure SetBANKACCTTO(Value: UnicodeString);
    procedure SetCCACCTTO(Value: UnicodeString);
    procedure SetMEMO(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
    { Methods & Properties }
    property TRNTYPE: UnicodeString read GetTRNTYPE write SetTRNTYPE;
    property DTPOSTED: UnicodeString read GetDTPOSTED write SetDTPOSTED;
    property DTUSER: UnicodeString read GetDTUSER write SetDTUSER;
    property DTAVAIL: UnicodeString read GetDTAVAIL write SetDTAVAIL;
    property TRNAMT: UnicodeString read GetTRNAMT write SetTRNAMT;
    property FITID: UnicodeString read GetFITID write SetFITID;
    property CORRECTFITID: UnicodeString read GetCORRECTFITID write SetCORRECTFITID;
    property CORRECTACTION: UnicodeString read GetCORRECTACTION write SetCORRECTACTION;
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
    property CHECKNUM: UnicodeString read GetCHECKNUM write SetCHECKNUM;
    property REFNUM: UnicodeString read GetREFNUM write SetREFNUM;
    property SIC: UnicodeString read GetSIC write SetSIC;
    property PAYEEID: UnicodeString read GetPAYEEID write SetPAYEEID;
    property NAME: UnicodeString read GetNAME write SetNAME;
    property PAYEE: IXMLPAYEEType read GetPAYEE;
    property BANKACCTTO: UnicodeString read GetBANKACCTTO write SetBANKACCTTO;
    property CCACCTTO: UnicodeString read GetCCACCTTO write SetCCACCTTO;
    property MEMO: UnicodeString read GetMEMO write SetMEMO;
    property CURRENCY: UnicodeString read GetCURRENCY write SetCURRENCY;
    property ORIGCURRENCY: UnicodeString read GetORIGCURRENCY write SetORIGCURRENCY;
  end;

{ IXMLSTMTTRNTypeList }

  IXMLSTMTTRNTypeList = interface(IXMLNodeCollection)
    ['{18C84D5B-0DF8-48F6-8150-63337E17B1FA}']
    { Methods & Properties }
    function Add: IXMLSTMTTRNType;
    function Insert(const Index: Integer): IXMLSTMTTRNType;

    function GetItem(Index: Integer): IXMLSTMTTRNType;
    property Items[Index: Integer]: IXMLSTMTTRNType read GetItem; default;
  end;

{ IXMLPAYEEType }

  IXMLPAYEEType = interface(IXMLNode)
    ['{B8D67760-61A0-48F2-A152-EF1D105FEF4D}']
    { Property Accessors }
    function GetNAME: UnicodeString;
    function GetADDR1: UnicodeString;
    function GetADDR2: UnicodeString;
    function GetADDR3: UnicodeString;
    function GetCITY: UnicodeString;
    function GetSTATE: UnicodeString;
    function GetPOSTALCODE: UnicodeString;
    function GetCOUNTRY: UnicodeString;
    function GetPHONE: UnicodeString;
    procedure SetNAME(Value: UnicodeString);
    procedure SetADDR1(Value: UnicodeString);
    procedure SetADDR2(Value: UnicodeString);
    procedure SetADDR3(Value: UnicodeString);
    procedure SetCITY(Value: UnicodeString);
    procedure SetSTATE(Value: UnicodeString);
    procedure SetPOSTALCODE(Value: UnicodeString);
    procedure SetCOUNTRY(Value: UnicodeString);
    procedure SetPHONE(Value: UnicodeString);
    { Methods & Properties }
    property NAME: UnicodeString read GetNAME write SetNAME;
    property ADDR1: UnicodeString read GetADDR1 write SetADDR1;
    property ADDR2: UnicodeString read GetADDR2 write SetADDR2;
    property ADDR3: UnicodeString read GetADDR3 write SetADDR3;
    property CITY: UnicodeString read GetCITY write SetCITY;
    property STATE: UnicodeString read GetSTATE write SetSTATE;
    property POSTALCODE: UnicodeString read GetPOSTALCODE write SetPOSTALCODE;
    property COUNTRY: UnicodeString read GetCOUNTRY write SetCOUNTRY;
    property PHONE: UnicodeString read GetPHONE write SetPHONE;
  end;

{ IXMLLEDGERBALType }

  IXMLLEDGERBALType = interface(IXMLNode)
    ['{1B23AAB6-69C7-493D-B628-12C192E24CCB}']
    { Property Accessors }
    function GetBALAMT: UnicodeString;
    function GetDTASOF: UnicodeString;
    procedure SetBALAMT(Value: UnicodeString);
    procedure SetDTASOF(Value: UnicodeString);
    { Methods & Properties }
    property BALAMT: UnicodeString read GetBALAMT write SetBALAMT;
    property DTASOF: UnicodeString read GetDTASOF write SetDTASOF;
  end;

{ IXMLAVAILBALType }

  IXMLAVAILBALType = interface(IXMLNode)
    ['{418BD219-7544-450E-9878-D261FB7473EB}']
    { Property Accessors }
    function GetBALAMT: UnicodeString;
    function GetDTASOF: UnicodeString;
    procedure SetBALAMT(Value: UnicodeString);
    procedure SetDTASOF(Value: UnicodeString);
    { Methods & Properties }
    property BALAMT: UnicodeString read GetBALAMT write SetBALAMT;
    property DTASOF: UnicodeString read GetDTASOF write SetDTASOF;
  end;

{ IXMLSTMTENDTRNRSType }

  IXMLSTMTENDTRNRSType = interface(IXMLNode)
    ['{6735F19F-91AE-4A45-A5F8-D6691BAA3654}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetSTMTENDRS: IXMLSTMTENDRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property STMTENDRS: IXMLSTMTENDRSType read GetSTMTENDRS;
  end;

{ IXMLSTMTENDTRNRSTypeList }

  IXMLSTMTENDTRNRSTypeList = interface(IXMLNodeCollection)
    ['{EC4AC188-4BF4-4401-BB16-0418BC5007F9}']
    { Methods & Properties }
    function Add: IXMLSTMTENDTRNRSType;
    function Insert(const Index: Integer): IXMLSTMTENDTRNRSType;

    function GetItem(Index: Integer): IXMLSTMTENDTRNRSType;
    property Items[Index: Integer]: IXMLSTMTENDTRNRSType read GetItem; default;
  end;

{ IXMLSTMTENDRSType }

  IXMLSTMTENDRSType = interface(IXMLNode)
    ['{B40062C5-B0BC-40A6-B7DC-F05EE6B8D000}']
    { Property Accessors }
    function GetCURDEF: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetCLOSING: IXMLCLOSINGTypeList;
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property CURDEF: UnicodeString read GetCURDEF write SetCURDEF;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property CLOSING: IXMLCLOSINGTypeList read GetCLOSING;
  end;

{ IXMLCLOSINGType }

  IXMLCLOSINGType = interface(IXMLNode)
    ['{03FA47B0-2F98-4009-820B-88A74E2A32C5}']
    { Property Accessors }
    function GetFITID: UnicodeString;
    function GetDTOPEN: UnicodeString;
    function GetDTCLOSE: UnicodeString;
    function GetDTNEXT: UnicodeString;
    function GetBALOPEN: UnicodeString;
    function GetBALCLOSE: UnicodeString;
    function GetBALMIN: UnicodeString;
    function GetDEPANDCREDIT: UnicodeString;
    function GetCHKANDDEB: UnicodeString;
    function GetTOTALFEES: UnicodeString;
    function GetTOTALINT: UnicodeString;
    function GetDTPOSTSTART: UnicodeString;
    function GetDTPOSTEND: UnicodeString;
    function GetMKTGINFO: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetFITID(Value: UnicodeString);
    procedure SetDTOPEN(Value: UnicodeString);
    procedure SetDTCLOSE(Value: UnicodeString);
    procedure SetDTNEXT(Value: UnicodeString);
    procedure SetBALOPEN(Value: UnicodeString);
    procedure SetBALCLOSE(Value: UnicodeString);
    procedure SetBALMIN(Value: UnicodeString);
    procedure SetDEPANDCREDIT(Value: UnicodeString);
    procedure SetCHKANDDEB(Value: UnicodeString);
    procedure SetTOTALFEES(Value: UnicodeString);
    procedure SetTOTALINT(Value: UnicodeString);
    procedure SetDTPOSTSTART(Value: UnicodeString);
    procedure SetDTPOSTEND(Value: UnicodeString);
    procedure SetMKTGINFO(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
    { Methods & Properties }
    property FITID: UnicodeString read GetFITID write SetFITID;
    property DTOPEN: UnicodeString read GetDTOPEN write SetDTOPEN;
    property DTCLOSE: UnicodeString read GetDTCLOSE write SetDTCLOSE;
    property DTNEXT: UnicodeString read GetDTNEXT write SetDTNEXT;
    property BALOPEN: UnicodeString read GetBALOPEN write SetBALOPEN;
    property BALCLOSE: UnicodeString read GetBALCLOSE write SetBALCLOSE;
    property BALMIN: UnicodeString read GetBALMIN write SetBALMIN;
    property DEPANDCREDIT: UnicodeString read GetDEPANDCREDIT write SetDEPANDCREDIT;
    property CHKANDDEB: UnicodeString read GetCHKANDDEB write SetCHKANDDEB;
    property TOTALFEES: UnicodeString read GetTOTALFEES write SetTOTALFEES;
    property TOTALINT: UnicodeString read GetTOTALINT write SetTOTALINT;
    property DTPOSTSTART: UnicodeString read GetDTPOSTSTART write SetDTPOSTSTART;
    property DTPOSTEND: UnicodeString read GetDTPOSTEND write SetDTPOSTEND;
    property MKTGINFO: UnicodeString read GetMKTGINFO write SetMKTGINFO;
    property CURRENCY: UnicodeString read GetCURRENCY write SetCURRENCY;
    property ORIGCURRENCY: UnicodeString read GetORIGCURRENCY write SetORIGCURRENCY;
  end;

{ IXMLCLOSINGTypeList }

  IXMLCLOSINGTypeList = interface(IXMLNodeCollection)
    ['{7CE742C0-8C8E-4B92-B285-071189CFCFFD}']
    { Methods & Properties }
    function Add: IXMLCLOSINGType;
    function Insert(const Index: Integer): IXMLCLOSINGType;

    function GetItem(Index: Integer): IXMLCLOSINGType;
    property Items[Index: Integer]: IXMLCLOSINGType read GetItem; default;
  end;

{ IXMLINTRATRNRSType }

  IXMLINTRATRNRSType = interface(IXMLNode)
    ['{D35A445B-27A6-4FC6-B6CA-E9F1950B1952}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetINTRARS: IXMLINTRARSType;
    function GetINTRAMODRS: IXMLINTRAMODRSType;
    function GetINTRACANRS: IXMLINTRACANRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property INTRARS: IXMLINTRARSType read GetINTRARS;
    property INTRAMODRS: IXMLINTRAMODRSType read GetINTRAMODRS;
    property INTRACANRS: IXMLINTRACANRSType read GetINTRACANRS;
  end;

{ IXMLINTRATRNRSTypeList }

  IXMLINTRATRNRSTypeList = interface(IXMLNodeCollection)
    ['{8293CF82-7CE0-40F8-8538-1C9C5537D7FF}']
    { Methods & Properties }
    function Add: IXMLINTRATRNRSType;
    function Insert(const Index: Integer): IXMLINTRATRNRSType;

    function GetItem(Index: Integer): IXMLINTRATRNRSType;
    property Items[Index: Integer]: IXMLINTRATRNRSType read GetItem; default;
  end;

{ IXMLINTRARSType }

  IXMLINTRARSType = interface(IXMLNode)
    ['{0761BC65-1946-4A73-B7D7-6DB388FD3148}']
    { Property Accessors }
    function GetCURDEF: UnicodeString;
    function GetSRVRTID: UnicodeString;
    function GetXFERINFO: IXMLXFERINFOType;
    function GetDTXFERPRJ: UnicodeString;
    function GetDTPOSTED: UnicodeString;
    function GetRECSRVRTID: UnicodeString;
    function GetXFERPRCSTS: IXMLXFERPRCSTSType;
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetSRVRTID(Value: UnicodeString);
    procedure SetDTXFERPRJ(Value: UnicodeString);
    procedure SetDTPOSTED(Value: UnicodeString);
    procedure SetRECSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property CURDEF: UnicodeString read GetCURDEF write SetCURDEF;
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
    property XFERINFO: IXMLXFERINFOType read GetXFERINFO;
    property DTXFERPRJ: UnicodeString read GetDTXFERPRJ write SetDTXFERPRJ;
    property DTPOSTED: UnicodeString read GetDTPOSTED write SetDTPOSTED;
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
    property XFERPRCSTS: IXMLXFERPRCSTSType read GetXFERPRCSTS;
  end;

{ IXMLXFERPRCSTSType }

  IXMLXFERPRCSTSType = interface(IXMLNode)
    ['{56297D99-087A-4B88-BBD9-F66E6A0C04A2}']
    { Property Accessors }
    function GetXFERPRCCODE: UnicodeString;
    function GetDTXFERPRC: UnicodeString;
    procedure SetXFERPRCCODE(Value: UnicodeString);
    procedure SetDTXFERPRC(Value: UnicodeString);
    { Methods & Properties }
    property XFERPRCCODE: UnicodeString read GetXFERPRCCODE write SetXFERPRCCODE;
    property DTXFERPRC: UnicodeString read GetDTXFERPRC write SetDTXFERPRC;
  end;

{ IXMLINTRAMODRSType }

  IXMLINTRAMODRSType = interface(IXMLNode)
    ['{0F3C0BE3-7E3E-4AB7-9785-DED386E88164}']
    { Property Accessors }
    function GetSRVRTID: UnicodeString;
    function GetXFERINFO: IXMLXFERINFOType;
    function GetXFERPRCSTS: IXMLXFERPRCSTSType;
    procedure SetSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
    property XFERINFO: IXMLXFERINFOType read GetXFERINFO;
    property XFERPRCSTS: IXMLXFERPRCSTSType read GetXFERPRCSTS;
  end;

{ IXMLINTRACANRSType }

  IXMLINTRACANRSType = interface(IXMLNode)
    ['{F934AD4C-1836-4C3E-8726-555E973591EE}']
    { Property Accessors }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
  end;

{ IXMLRECINTRATRNRSType }

  IXMLRECINTRATRNRSType = interface(IXMLNode)
    ['{6C5DFAD3-5297-4EB2-913B-88C8C416217E}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetRECINTRARS: IXMLRECINTRARSType;
    function GetRECINTRAMODRS: IXMLRECINTRAMODRSType;
    function GetRECINTRACANRS: IXMLRECINTRACANRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property RECINTRARS: IXMLRECINTRARSType read GetRECINTRARS;
    property RECINTRAMODRS: IXMLRECINTRAMODRSType read GetRECINTRAMODRS;
    property RECINTRACANRS: IXMLRECINTRACANRSType read GetRECINTRACANRS;
  end;

{ IXMLRECINTRATRNRSTypeList }

  IXMLRECINTRATRNRSTypeList = interface(IXMLNodeCollection)
    ['{58519530-16AC-46D8-9BDC-8F8E3A1DE5D5}']
    { Methods & Properties }
    function Add: IXMLRECINTRATRNRSType;
    function Insert(const Index: Integer): IXMLRECINTRATRNRSType;

    function GetItem(Index: Integer): IXMLRECINTRATRNRSType;
    property Items[Index: Integer]: IXMLRECINTRATRNRSType read GetItem; default;
  end;

{ IXMLRECINTRARSType }

  IXMLRECINTRARSType = interface(IXMLNode)
    ['{49E887C8-6897-4AAD-AE35-876216C7E097}']
    { Property Accessors }
    function GetRECSRVRTID: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetINTRARS: IXMLINTRARSType;
    procedure SetRECSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
    property RECURRINST: IXMLRECURRINSTType read GetRECURRINST;
    property INTRARS: IXMLINTRARSType read GetINTRARS;
  end;

{ IXMLRECINTRAMODRSType }

  IXMLRECINTRAMODRSType = interface(IXMLNode)
    ['{5A0526B6-886B-4780-8DA7-0D1B2B350CCC}']
    { Property Accessors }
    function GetRECSRVRTID: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetINTRARS: IXMLINTRARSType;
    function GetMODPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetMODPENDING(Value: UnicodeString);
    { Methods & Properties }
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
    property RECURRINST: IXMLRECURRINSTType read GetRECURRINST;
    property INTRARS: IXMLINTRARSType read GetINTRARS;
    property MODPENDING: UnicodeString read GetMODPENDING write SetMODPENDING;
  end;

{ IXMLRECINTRACANRSType }

  IXMLRECINTRACANRSType = interface(IXMLNode)
    ['{03742989-C7A8-4A07-A632-99756E8B3ED8}']
    { Property Accessors }
    function GetRECSRVRTID: UnicodeString;
    function GetCANPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetCANPENDING(Value: UnicodeString);
    { Methods & Properties }
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
    property CANPENDING: UnicodeString read GetCANPENDING write SetCANPENDING;
  end;

{ IXMLSTPCHKTRNRSType }

  IXMLSTPCHKTRNRSType = interface(IXMLNode)
    ['{99AD2D58-A842-4D8C-9901-6F083DD82052}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetSTPCHKRS: IXMLSTPCHKRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property STPCHKRS: IXMLSTPCHKRSType read GetSTPCHKRS;
  end;

{ IXMLSTPCHKTRNRSTypeList }

  IXMLSTPCHKTRNRSTypeList = interface(IXMLNodeCollection)
    ['{3521F213-D72F-42D0-9476-2B07CDF3BA87}']
    { Methods & Properties }
    function Add: IXMLSTPCHKTRNRSType;
    function Insert(const Index: Integer): IXMLSTPCHKTRNRSType;

    function GetItem(Index: Integer): IXMLSTPCHKTRNRSType;
    property Items[Index: Integer]: IXMLSTPCHKTRNRSType read GetItem; default;
  end;

{ IXMLSTPCHKRSType }

  IXMLSTPCHKRSType = interface(IXMLNode)
    ['{E8798CB7-56BD-4BB3-9618-EC131B2389ED}']
    { Property Accessors }
    function GetCURDEF: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetSTPCHKNUM: IXMLSTPCHKNUMTypeList;
    function GetFEE: UnicodeString;
    function GetFEEMSG: UnicodeString;
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetFEE(Value: UnicodeString);
    procedure SetFEEMSG(Value: UnicodeString);
    { Methods & Properties }
    property CURDEF: UnicodeString read GetCURDEF write SetCURDEF;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property STPCHKNUM: IXMLSTPCHKNUMTypeList read GetSTPCHKNUM;
    property FEE: UnicodeString read GetFEE write SetFEE;
    property FEEMSG: UnicodeString read GetFEEMSG write SetFEEMSG;
  end;

{ IXMLSTPCHKNUMType }

  IXMLSTPCHKNUMType = interface(IXMLNode)
    ['{F22BD113-3F0E-4426-B5A0-55B20BE3F29F}']
    { Property Accessors }
    function GetCHECKNUM: UnicodeString;
    function GetNAME: UnicodeString;
    function GetDTUSER: UnicodeString;
    function GetTRNAMT: UnicodeString;
    function GetCHKSTATUS: UnicodeString;
    function GetCHKERROR: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetCHECKNUM(Value: UnicodeString);
    procedure SetNAME(Value: UnicodeString);
    procedure SetDTUSER(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
    procedure SetCHKSTATUS(Value: UnicodeString);
    procedure SetCHKERROR(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
    { Methods & Properties }
    property CHECKNUM: UnicodeString read GetCHECKNUM write SetCHECKNUM;
    property NAME: UnicodeString read GetNAME write SetNAME;
    property DTUSER: UnicodeString read GetDTUSER write SetDTUSER;
    property TRNAMT: UnicodeString read GetTRNAMT write SetTRNAMT;
    property CHKSTATUS: UnicodeString read GetCHKSTATUS write SetCHKSTATUS;
    property CHKERROR: UnicodeString read GetCHKERROR write SetCHKERROR;
    property CURRENCY: UnicodeString read GetCURRENCY write SetCURRENCY;
    property ORIGCURRENCY: UnicodeString read GetORIGCURRENCY write SetORIGCURRENCY;
  end;

{ IXMLSTPCHKNUMTypeList }

  IXMLSTPCHKNUMTypeList = interface(IXMLNodeCollection)
    ['{509D78E6-7792-42E9-9038-6F2BC9A91023}']
    { Methods & Properties }
    function Add: IXMLSTPCHKNUMType;
    function Insert(const Index: Integer): IXMLSTPCHKNUMType;

    function GetItem(Index: Integer): IXMLSTPCHKNUMType;
    property Items[Index: Integer]: IXMLSTPCHKNUMType read GetItem; default;
  end;

{ IXMLBANKMAILTRNRSType }

  IXMLBANKMAILTRNRSType = interface(IXMLNode)
    ['{A6DFE779-0120-4908-8087-2D6ACDB5C4E2}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetBANKMAILRS: IXMLBANKMAILRSType;
    function GetCHKMAILRS: IXMLCHKMAILRSType;
    function GetDEPMAILRS: IXMLDEPMAILRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property BANKMAILRS: IXMLBANKMAILRSType read GetBANKMAILRS;
    property CHKMAILRS: IXMLCHKMAILRSType read GetCHKMAILRS;
    property DEPMAILRS: IXMLDEPMAILRSType read GetDEPMAILRS;
  end;

{ IXMLBANKMAILTRNRSTypeList }

  IXMLBANKMAILTRNRSTypeList = interface(IXMLNodeCollection)
    ['{21CA3392-3F50-4A8F-9C07-A98F6B90B91E}']
    { Methods & Properties }
    function Add: IXMLBANKMAILTRNRSType;
    function Insert(const Index: Integer): IXMLBANKMAILTRNRSType;

    function GetItem(Index: Integer): IXMLBANKMAILTRNRSType;
    property Items[Index: Integer]: IXMLBANKMAILTRNRSType read GetItem; default;
  end;

{ IXMLBANKMAILRSType }

  IXMLBANKMAILRSType = interface(IXMLNode)
    ['{C19EFD90-BF6A-4E89-A56E-74357AF818D4}']
    { Property Accessors }
    function GetBANKACCTFROM: UnicodeString;
    function GetCCACCTFROM: UnicodeString;
    function GetMAIL: IXMLMAILType;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetCCACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property CCACCTFROM: UnicodeString read GetCCACCTFROM write SetCCACCTFROM;
    property MAIL: IXMLMAILType read GetMAIL;
  end;

{ IXMLCHKMAILRSType }

  IXMLCHKMAILRSType = interface(IXMLNode)
    ['{4B3492EB-47A5-494E-B1F9-0C16FEC3FB5C}']
    { Property Accessors }
    function GetBANKACCTFROM: UnicodeString;
    function GetMAIL: IXMLMAILType;
    function GetCHECKNUM: UnicodeString;
    function GetTRNAMT: UnicodeString;
    function GetDTUSER: UnicodeString;
    function GetFEE: UnicodeString;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetCHECKNUM(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
    procedure SetDTUSER(Value: UnicodeString);
    procedure SetFEE(Value: UnicodeString);
    { Methods & Properties }
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property MAIL: IXMLMAILType read GetMAIL;
    property CHECKNUM: UnicodeString read GetCHECKNUM write SetCHECKNUM;
    property TRNAMT: UnicodeString read GetTRNAMT write SetTRNAMT;
    property DTUSER: UnicodeString read GetDTUSER write SetDTUSER;
    property FEE: UnicodeString read GetFEE write SetFEE;
  end;

{ IXMLDEPMAILRSType }

  IXMLDEPMAILRSType = interface(IXMLNode)
    ['{6D70B1B0-EB98-4B2D-A93A-859AB94302AB}']
    { Property Accessors }
    function GetBANKACCTFROM: UnicodeString;
    function GetMAIL: IXMLMAILType;
    function GetTRNAMT: UnicodeString;
    function GetDTUSER: UnicodeString;
    function GetFEE: UnicodeString;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
    procedure SetDTUSER(Value: UnicodeString);
    procedure SetFEE(Value: UnicodeString);
    { Methods & Properties }
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property MAIL: IXMLMAILType read GetMAIL;
    property TRNAMT: UnicodeString read GetTRNAMT write SetTRNAMT;
    property DTUSER: UnicodeString read GetDTUSER write SetDTUSER;
    property FEE: UnicodeString read GetFEE write SetFEE;
  end;

{ IXMLBANKMAILSYNCRSType }

  IXMLBANKMAILSYNCRSType = interface(IXMLNode)
    ['{167BF274-DA06-4605-9284-FAFBA464D01C}']
    { Property Accessors }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetCCACCTFROM: UnicodeString;
    function GetBANKMAILTRNRS: IXMLBANKMAILTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetCCACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRSMACRO: UnicodeString read GetSYNCRSMACRO write SetSYNCRSMACRO;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property CCACCTFROM: UnicodeString read GetCCACCTFROM write SetCCACCTFROM;
    property BANKMAILTRNRS: IXMLBANKMAILTRNRSTypeList read GetBANKMAILTRNRS;
  end;

{ IXMLBANKMAILSYNCRSTypeList }

  IXMLBANKMAILSYNCRSTypeList = interface(IXMLNodeCollection)
    ['{1D691CD8-0129-436B-99E0-2500865C9958}']
    { Methods & Properties }
    function Add: IXMLBANKMAILSYNCRSType;
    function Insert(const Index: Integer): IXMLBANKMAILSYNCRSType;

    function GetItem(Index: Integer): IXMLBANKMAILSYNCRSType;
    property Items[Index: Integer]: IXMLBANKMAILSYNCRSType read GetItem; default;
  end;

{ IXMLSTPCHKSYNCRSType }

  IXMLSTPCHKSYNCRSType = interface(IXMLNode)
    ['{6F2882E0-DA05-4360-A911-F76BD984C843}']
    { Property Accessors }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetSTPCHKTRNRS: IXMLSTPCHKTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRSMACRO: UnicodeString read GetSYNCRSMACRO write SetSYNCRSMACRO;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property STPCHKTRNRS: IXMLSTPCHKTRNRSTypeList read GetSTPCHKTRNRS;
  end;

{ IXMLSTPCHKSYNCRSTypeList }

  IXMLSTPCHKSYNCRSTypeList = interface(IXMLNodeCollection)
    ['{30F0F7D3-2BD4-4349-AEC6-90EB5D620AE2}']
    { Methods & Properties }
    function Add: IXMLSTPCHKSYNCRSType;
    function Insert(const Index: Integer): IXMLSTPCHKSYNCRSType;

    function GetItem(Index: Integer): IXMLSTPCHKSYNCRSType;
    property Items[Index: Integer]: IXMLSTPCHKSYNCRSType read GetItem; default;
  end;

{ IXMLINTRASYNCRSType }

  IXMLINTRASYNCRSType = interface(IXMLNode)
    ['{C035D25D-832D-4865-9B05-EC0DECAA4A8D}']
    { Property Accessors }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetINTRATRNRS: IXMLINTRATRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRSMACRO: UnicodeString read GetSYNCRSMACRO write SetSYNCRSMACRO;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property INTRATRNRS: IXMLINTRATRNRSTypeList read GetINTRATRNRS;
  end;

{ IXMLINTRASYNCRSTypeList }

  IXMLINTRASYNCRSTypeList = interface(IXMLNodeCollection)
    ['{62A4B002-C29A-45E3-9DD9-8F71E715DA94}']
    { Methods & Properties }
    function Add: IXMLINTRASYNCRSType;
    function Insert(const Index: Integer): IXMLINTRASYNCRSType;

    function GetItem(Index: Integer): IXMLINTRASYNCRSType;
    property Items[Index: Integer]: IXMLINTRASYNCRSType read GetItem; default;
  end;

{ IXMLRECINTRASYNCRSType }

  IXMLRECINTRASYNCRSType = interface(IXMLNode)
    ['{FF3E77CC-B682-4A17-A019-B54191FAF1BE}']
    { Property Accessors }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetRECINTRATRNRS: IXMLRECINTRATRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRSMACRO: UnicodeString read GetSYNCRSMACRO write SetSYNCRSMACRO;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property RECINTRATRNRS: IXMLRECINTRATRNRSTypeList read GetRECINTRATRNRS;
  end;

{ IXMLRECINTRASYNCRSTypeList }

  IXMLRECINTRASYNCRSTypeList = interface(IXMLNodeCollection)
    ['{AA942AA3-86CD-4E7C-8602-914DB6099157}']
    { Methods & Properties }
    function Add: IXMLRECINTRASYNCRSType;
    function Insert(const Index: Integer): IXMLRECINTRASYNCRSType;

    function GetItem(Index: Integer): IXMLRECINTRASYNCRSType;
    property Items[Index: Integer]: IXMLRECINTRASYNCRSType read GetItem; default;
  end;

{ IXMLCREDITCARDMSGSRSV1Type }

  IXMLCREDITCARDMSGSRSV1Type = interface(IXMLNode)
    ['{7F61B41D-5587-4F67-BBBD-BB3382834B25}']
    { Property Accessors }
    function GetCCSTMTTRNRS: IXMLCCSTMTTRNRSTypeList;
    function GetCCSTMTENDTRNRS: IXMLCCSTMTENDTRNRSTypeList;
    { Methods & Properties }
    property CCSTMTTRNRS: IXMLCCSTMTTRNRSTypeList read GetCCSTMTTRNRS;
    property CCSTMTENDTRNRS: IXMLCCSTMTENDTRNRSTypeList read GetCCSTMTENDTRNRS;
  end;

{ IXMLCCSTMTTRNRSType }

  IXMLCCSTMTTRNRSType = interface(IXMLNode)
    ['{7A2303F5-2C3F-46DA-AD63-492089540541}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetCCSTMTRS: IXMLCCSTMTRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property CCSTMTRS: IXMLCCSTMTRSType read GetCCSTMTRS;
  end;

{ IXMLCCSTMTTRNRSTypeList }

  IXMLCCSTMTTRNRSTypeList = interface(IXMLNodeCollection)
    ['{6B7E3EEF-6C68-4005-BFA6-CC73C91645C9}']
    { Methods & Properties }
    function Add: IXMLCCSTMTTRNRSType;
    function Insert(const Index: Integer): IXMLCCSTMTTRNRSType;

    function GetItem(Index: Integer): IXMLCCSTMTTRNRSType;
    property Items[Index: Integer]: IXMLCCSTMTTRNRSType read GetItem; default;
  end;

{ IXMLCCSTMTRSType }

  IXMLCCSTMTRSType = interface(IXMLNode)
    ['{3666D8A8-FC23-4B29-9CA0-CD45A7469C1A}']
    { Property Accessors }
    function GetCURDEF: UnicodeString;
    function GetCCACCTFROM: UnicodeString;
    function GetBANKTRANLIST: IXMLBANKTRANLISTType;
    function GetLEDGERBAL: IXMLLEDGERBALType;
    function GetAVAILBAL: IXMLAVAILBALType;
    function GetMKTGINFO: UnicodeString;
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetCCACCTFROM(Value: UnicodeString);
    procedure SetMKTGINFO(Value: UnicodeString);
    { Methods & Properties }
    property CURDEF: UnicodeString read GetCURDEF write SetCURDEF;
    property CCACCTFROM: UnicodeString read GetCCACCTFROM write SetCCACCTFROM;
    property BANKTRANLIST: IXMLBANKTRANLISTType read GetBANKTRANLIST;
    property LEDGERBAL: IXMLLEDGERBALType read GetLEDGERBAL;
    property AVAILBAL: IXMLAVAILBALType read GetAVAILBAL;
    property MKTGINFO: UnicodeString read GetMKTGINFO write SetMKTGINFO;
  end;

{ IXMLCCSTMTENDTRNRSType }

  IXMLCCSTMTENDTRNRSType = interface(IXMLNode)
    ['{3C1E2073-1B2C-4129-83B5-3EDD5F723B04}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetCCSTMTENDRS: IXMLCCSTMTENDRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property CCSTMTENDRS: IXMLCCSTMTENDRSType read GetCCSTMTENDRS;
  end;

{ IXMLCCSTMTENDTRNRSTypeList }

  IXMLCCSTMTENDTRNRSTypeList = interface(IXMLNodeCollection)
    ['{A867B660-794A-4E4E-BA16-6D73AA4B39D5}']
    { Methods & Properties }
    function Add: IXMLCCSTMTENDTRNRSType;
    function Insert(const Index: Integer): IXMLCCSTMTENDTRNRSType;

    function GetItem(Index: Integer): IXMLCCSTMTENDTRNRSType;
    property Items[Index: Integer]: IXMLCCSTMTENDTRNRSType read GetItem; default;
  end;

{ IXMLCCSTMTENDRSType }

  IXMLCCSTMTENDRSType = interface(IXMLNode)
    ['{AD25F9FA-D561-43C6-A312-58852089DAA5}']
    { Property Accessors }
    function GetCURDEF: UnicodeString;
    function GetCCACCTFROM: UnicodeString;
    function GetCCCLOSING: IXMLCCCLOSINGTypeList;
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetCCACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property CURDEF: UnicodeString read GetCURDEF write SetCURDEF;
    property CCACCTFROM: UnicodeString read GetCCACCTFROM write SetCCACCTFROM;
    property CCCLOSING: IXMLCCCLOSINGTypeList read GetCCCLOSING;
  end;

{ IXMLCCCLOSINGType }

  IXMLCCCLOSINGType = interface(IXMLNode)
    ['{3675A901-CF6F-45B5-935C-23D4DB40159F}']
    { Property Accessors }
    function GetFITID: UnicodeString;
    function GetDTOPEN: UnicodeString;
    function GetDTCLOSE: UnicodeString;
    function GetDTNEXT: UnicodeString;
    function GetBALOPEN: UnicodeString;
    function GetBALCLOSE: UnicodeString;
    function GetDTPMTDUE: UnicodeString;
    function GetMINPMTDUE: UnicodeString;
    function GetFINCHG: UnicodeString;
    function GetPAYANDCREDIT: UnicodeString;
    function GetPURANDADV: UnicodeString;
    function GetDEBADJ: UnicodeString;
    function GetCREDITLIMIT: UnicodeString;
    function GetDTPOSTSTART: UnicodeString;
    function GetDTPOSTEND: UnicodeString;
    function GetMKTGINFO: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetFITID(Value: UnicodeString);
    procedure SetDTOPEN(Value: UnicodeString);
    procedure SetDTCLOSE(Value: UnicodeString);
    procedure SetDTNEXT(Value: UnicodeString);
    procedure SetBALOPEN(Value: UnicodeString);
    procedure SetBALCLOSE(Value: UnicodeString);
    procedure SetDTPMTDUE(Value: UnicodeString);
    procedure SetMINPMTDUE(Value: UnicodeString);
    procedure SetFINCHG(Value: UnicodeString);
    procedure SetPAYANDCREDIT(Value: UnicodeString);
    procedure SetPURANDADV(Value: UnicodeString);
    procedure SetDEBADJ(Value: UnicodeString);
    procedure SetCREDITLIMIT(Value: UnicodeString);
    procedure SetDTPOSTSTART(Value: UnicodeString);
    procedure SetDTPOSTEND(Value: UnicodeString);
    procedure SetMKTGINFO(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
    { Methods & Properties }
    property FITID: UnicodeString read GetFITID write SetFITID;
    property DTOPEN: UnicodeString read GetDTOPEN write SetDTOPEN;
    property DTCLOSE: UnicodeString read GetDTCLOSE write SetDTCLOSE;
    property DTNEXT: UnicodeString read GetDTNEXT write SetDTNEXT;
    property BALOPEN: UnicodeString read GetBALOPEN write SetBALOPEN;
    property BALCLOSE: UnicodeString read GetBALCLOSE write SetBALCLOSE;
    property DTPMTDUE: UnicodeString read GetDTPMTDUE write SetDTPMTDUE;
    property MINPMTDUE: UnicodeString read GetMINPMTDUE write SetMINPMTDUE;
    property FINCHG: UnicodeString read GetFINCHG write SetFINCHG;
    property PAYANDCREDIT: UnicodeString read GetPAYANDCREDIT write SetPAYANDCREDIT;
    property PURANDADV: UnicodeString read GetPURANDADV write SetPURANDADV;
    property DEBADJ: UnicodeString read GetDEBADJ write SetDEBADJ;
    property CREDITLIMIT: UnicodeString read GetCREDITLIMIT write SetCREDITLIMIT;
    property DTPOSTSTART: UnicodeString read GetDTPOSTSTART write SetDTPOSTSTART;
    property DTPOSTEND: UnicodeString read GetDTPOSTEND write SetDTPOSTEND;
    property MKTGINFO: UnicodeString read GetMKTGINFO write SetMKTGINFO;
    property CURRENCY: UnicodeString read GetCURRENCY write SetCURRENCY;
    property ORIGCURRENCY: UnicodeString read GetORIGCURRENCY write SetORIGCURRENCY;
  end;

{ IXMLCCCLOSINGTypeList }

  IXMLCCCLOSINGTypeList = interface(IXMLNodeCollection)
    ['{9F487ADC-953A-4621-AD65-EA9C2782B191}']
    { Methods & Properties }
    function Add: IXMLCCCLOSINGType;
    function Insert(const Index: Integer): IXMLCCCLOSINGType;

    function GetItem(Index: Integer): IXMLCCCLOSINGType;
    property Items[Index: Integer]: IXMLCCCLOSINGType read GetItem; default;
  end;

{ IXMLINTERXFERMSGSRSV1Type }

  IXMLINTERXFERMSGSRSV1Type = interface(IXMLNode)
    ['{012095DE-D7BB-44F1-AE80-35DD9491BA89}']
    { Property Accessors }
    function GetINTERTRNRS: IXMLINTERTRNRSTypeList;
    function GetRECINTERTRNRS: IXMLRECINTERTRNRSTypeList;
    function GetINTERSYNCRS: IXMLINTERSYNCRSTypeList;
    function GetRECINTERSYNCRS: IXMLRECINTERSYNCRSTypeList;
    { Methods & Properties }
    property INTERTRNRS: IXMLINTERTRNRSTypeList read GetINTERTRNRS;
    property RECINTERTRNRS: IXMLRECINTERTRNRSTypeList read GetRECINTERTRNRS;
    property INTERSYNCRS: IXMLINTERSYNCRSTypeList read GetINTERSYNCRS;
    property RECINTERSYNCRS: IXMLRECINTERSYNCRSTypeList read GetRECINTERSYNCRS;
  end;

{ IXMLINTERTRNRSType }

  IXMLINTERTRNRSType = interface(IXMLNode)
    ['{5BF15410-EA1A-49AA-9FBE-8ACECE512B73}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetINTERRS: IXMLINTERRSType;
    function GetINTERMODRS: IXMLINTERMODRSType;
    function GetINTERCANRS: IXMLINTERCANRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property INTERRS: IXMLINTERRSType read GetINTERRS;
    property INTERMODRS: IXMLINTERMODRSType read GetINTERMODRS;
    property INTERCANRS: IXMLINTERCANRSType read GetINTERCANRS;
  end;

{ IXMLINTERTRNRSTypeList }

  IXMLINTERTRNRSTypeList = interface(IXMLNodeCollection)
    ['{99BAFF9E-F700-4AEF-9C26-86D92D0BC7EC}']
    { Methods & Properties }
    function Add: IXMLINTERTRNRSType;
    function Insert(const Index: Integer): IXMLINTERTRNRSType;

    function GetItem(Index: Integer): IXMLINTERTRNRSType;
    property Items[Index: Integer]: IXMLINTERTRNRSType read GetItem; default;
  end;

{ IXMLINTERRSType }

  IXMLINTERRSType = interface(IXMLNode)
    ['{5F0014A8-CA24-43A5-AC3A-CC689656CBA9}']
    { Property Accessors }
    function GetCURDEF: UnicodeString;
    function GetSRVRTID: UnicodeString;
    function GetXFERINFO: IXMLXFERINFOType;
    function GetDTXFERPRJ: UnicodeString;
    function GetDTPOSTED: UnicodeString;
    function GetREFNUM: UnicodeString;
    function GetRECSRVRTID: UnicodeString;
    function GetXFERPRCSTS: IXMLXFERPRCSTSType;
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetSRVRTID(Value: UnicodeString);
    procedure SetDTXFERPRJ(Value: UnicodeString);
    procedure SetDTPOSTED(Value: UnicodeString);
    procedure SetREFNUM(Value: UnicodeString);
    procedure SetRECSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property CURDEF: UnicodeString read GetCURDEF write SetCURDEF;
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
    property XFERINFO: IXMLXFERINFOType read GetXFERINFO;
    property DTXFERPRJ: UnicodeString read GetDTXFERPRJ write SetDTXFERPRJ;
    property DTPOSTED: UnicodeString read GetDTPOSTED write SetDTPOSTED;
    property REFNUM: UnicodeString read GetREFNUM write SetREFNUM;
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
    property XFERPRCSTS: IXMLXFERPRCSTSType read GetXFERPRCSTS;
  end;

{ IXMLINTERMODRSType }

  IXMLINTERMODRSType = interface(IXMLNode)
    ['{EF95D006-917C-464C-8713-21800CE15F08}']
    { Property Accessors }
    function GetSRVRTID: UnicodeString;
    function GetXFERINFO: IXMLXFERINFOType;
    function GetXFERPRCSTS: IXMLXFERPRCSTSType;
    procedure SetSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
    property XFERINFO: IXMLXFERINFOType read GetXFERINFO;
    property XFERPRCSTS: IXMLXFERPRCSTSType read GetXFERPRCSTS;
  end;

{ IXMLINTERCANRSType }

  IXMLINTERCANRSType = interface(IXMLNode)
    ['{13469127-FB4C-473F-96E6-90F4A514A9BE}']
    { Property Accessors }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
  end;

{ IXMLRECINTERTRNRSType }

  IXMLRECINTERTRNRSType = interface(IXMLNode)
    ['{08E147B8-12DE-4249-B68E-723646998EFA}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetRECINTERRS: IXMLRECINTERRSType;
    function GetRECINTERMODRS: IXMLRECINTERMODRSType;
    function GetRECINTERCANRS: IXMLRECINTERCANRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property RECINTERRS: IXMLRECINTERRSType read GetRECINTERRS;
    property RECINTERMODRS: IXMLRECINTERMODRSType read GetRECINTERMODRS;
    property RECINTERCANRS: IXMLRECINTERCANRSType read GetRECINTERCANRS;
  end;

{ IXMLRECINTERTRNRSTypeList }

  IXMLRECINTERTRNRSTypeList = interface(IXMLNodeCollection)
    ['{B67E9528-6728-4D08-8BF0-FDDBF8A02DBD}']
    { Methods & Properties }
    function Add: IXMLRECINTERTRNRSType;
    function Insert(const Index: Integer): IXMLRECINTERTRNRSType;

    function GetItem(Index: Integer): IXMLRECINTERTRNRSType;
    property Items[Index: Integer]: IXMLRECINTERTRNRSType read GetItem; default;
  end;

{ IXMLRECINTERRSType }

  IXMLRECINTERRSType = interface(IXMLNode)
    ['{7B55A431-17AA-4D2B-A927-5A9BEC1AD750}']
    { Property Accessors }
    function GetRECSRVRTID: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetINTERRS: IXMLINTERRSType;
    procedure SetRECSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
    property RECURRINST: IXMLRECURRINSTType read GetRECURRINST;
    property INTERRS: IXMLINTERRSType read GetINTERRS;
  end;

{ IXMLRECINTERMODRSType }

  IXMLRECINTERMODRSType = interface(IXMLNode)
    ['{E8085189-D2D7-4678-A748-40E612A1139B}']
    { Property Accessors }
    function GetRECSRVRTID: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetINTERRS: IXMLINTERRSType;
    function GetMODPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetMODPENDING(Value: UnicodeString);
    { Methods & Properties }
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
    property RECURRINST: IXMLRECURRINSTType read GetRECURRINST;
    property INTERRS: IXMLINTERRSType read GetINTERRS;
    property MODPENDING: UnicodeString read GetMODPENDING write SetMODPENDING;
  end;

{ IXMLRECINTERCANRSType }

  IXMLRECINTERCANRSType = interface(IXMLNode)
    ['{02A0E2AD-0859-434F-A34F-0E547D51F2E3}']
    { Property Accessors }
    function GetRECSRVRTID: UnicodeString;
    function GetCANPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetCANPENDING(Value: UnicodeString);
    { Methods & Properties }
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
    property CANPENDING: UnicodeString read GetCANPENDING write SetCANPENDING;
  end;

{ IXMLINTERSYNCRSType }

  IXMLINTERSYNCRSType = interface(IXMLNode)
    ['{84C56002-C22E-41F3-B98F-AED96470F8D8}']
    { Property Accessors }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetINTERTRNRS: IXMLINTERTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRSMACRO: UnicodeString read GetSYNCRSMACRO write SetSYNCRSMACRO;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property INTERTRNRS: IXMLINTERTRNRSTypeList read GetINTERTRNRS;
  end;

{ IXMLINTERSYNCRSTypeList }

  IXMLINTERSYNCRSTypeList = interface(IXMLNodeCollection)
    ['{A6C5A5A0-62CF-4F0F-BBBA-848EBB3328A6}']
    { Methods & Properties }
    function Add: IXMLINTERSYNCRSType;
    function Insert(const Index: Integer): IXMLINTERSYNCRSType;

    function GetItem(Index: Integer): IXMLINTERSYNCRSType;
    property Items[Index: Integer]: IXMLINTERSYNCRSType read GetItem; default;
  end;

{ IXMLRECINTERSYNCRSType }

  IXMLRECINTERSYNCRSType = interface(IXMLNode)
    ['{338C997D-8E5B-476A-9E01-632DD5159CAF}']
    { Property Accessors }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetRECINTERTRNRS: IXMLRECINTERTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRSMACRO: UnicodeString read GetSYNCRSMACRO write SetSYNCRSMACRO;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property RECINTERTRNRS: IXMLRECINTERTRNRSTypeList read GetRECINTERTRNRS;
  end;

{ IXMLRECINTERSYNCRSTypeList }

  IXMLRECINTERSYNCRSTypeList = interface(IXMLNodeCollection)
    ['{79B24707-C7AD-414A-9E0B-7E13ED5168CC}']
    { Methods & Properties }
    function Add: IXMLRECINTERSYNCRSType;
    function Insert(const Index: Integer): IXMLRECINTERSYNCRSType;

    function GetItem(Index: Integer): IXMLRECINTERSYNCRSType;
    property Items[Index: Integer]: IXMLRECINTERSYNCRSType read GetItem; default;
  end;

{ IXMLWIREXFERMSGSRSV1Type }

  IXMLWIREXFERMSGSRSV1Type = interface(IXMLNode)
    ['{A57EB8D1-7A40-41EB-80D1-C4653506DC7A}']
    { Property Accessors }
    function GetWIRETRNRS: IXMLWIRETRNRSTypeList;
    function GetWIRESYNCRS: IXMLWIRESYNCRSTypeList;
    { Methods & Properties }
    property WIRETRNRS: IXMLWIRETRNRSTypeList read GetWIRETRNRS;
    property WIRESYNCRS: IXMLWIRESYNCRSTypeList read GetWIRESYNCRS;
  end;

{ IXMLWIRETRNRSType }

  IXMLWIRETRNRSType = interface(IXMLNode)
    ['{938099FC-FC66-4F12-A05B-B97584550694}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetWIRERS: IXMLWIRERSType;
    function GetWIRECANRS: IXMLWIRECANRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property WIRERS: IXMLWIRERSType read GetWIRERS;
    property WIRECANRS: IXMLWIRECANRSType read GetWIRECANRS;
  end;

{ IXMLWIRETRNRSTypeList }

  IXMLWIRETRNRSTypeList = interface(IXMLNodeCollection)
    ['{45C0A19B-4C78-4B38-A3D4-4C3C8F903F5D}']
    { Methods & Properties }
    function Add: IXMLWIRETRNRSType;
    function Insert(const Index: Integer): IXMLWIRETRNRSType;

    function GetItem(Index: Integer): IXMLWIRETRNRSType;
    property Items[Index: Integer]: IXMLWIRETRNRSType read GetItem; default;
  end;

{ IXMLWIRERSType }

  IXMLWIRERSType = interface(IXMLNode)
    ['{0CDFFDF5-9D7D-44C7-8FBC-AD2F87EEFCDA}']
    { Property Accessors }
    function GetCURDEF: UnicodeString;
    function GetSRVRTID: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetWIREBENEFICIARY: IXMLWIREBENEFICIARYType;
    function GetWIREDESTBANK: IXMLWIREDESTBANKType;
    function GetTRNAMT: UnicodeString;
    function GetDTDUE: UnicodeString;
    function GetPAYINSTRUCT: UnicodeString;
    function GetDTXFERPRJ: UnicodeString;
    function GetDTPOSTED: UnicodeString;
    function GetFEE: UnicodeString;
    function GetCONFMSG: UnicodeString;
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetSRVRTID(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
    procedure SetDTDUE(Value: UnicodeString);
    procedure SetPAYINSTRUCT(Value: UnicodeString);
    procedure SetDTXFERPRJ(Value: UnicodeString);
    procedure SetDTPOSTED(Value: UnicodeString);
    procedure SetFEE(Value: UnicodeString);
    procedure SetCONFMSG(Value: UnicodeString);
    { Methods & Properties }
    property CURDEF: UnicodeString read GetCURDEF write SetCURDEF;
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property WIREBENEFICIARY: IXMLWIREBENEFICIARYType read GetWIREBENEFICIARY;
    property WIREDESTBANK: IXMLWIREDESTBANKType read GetWIREDESTBANK;
    property TRNAMT: UnicodeString read GetTRNAMT write SetTRNAMT;
    property DTDUE: UnicodeString read GetDTDUE write SetDTDUE;
    property PAYINSTRUCT: UnicodeString read GetPAYINSTRUCT write SetPAYINSTRUCT;
    property DTXFERPRJ: UnicodeString read GetDTXFERPRJ write SetDTXFERPRJ;
    property DTPOSTED: UnicodeString read GetDTPOSTED write SetDTPOSTED;
    property FEE: UnicodeString read GetFEE write SetFEE;
    property CONFMSG: UnicodeString read GetCONFMSG write SetCONFMSG;
  end;

{ IXMLWIRECANRSType }

  IXMLWIRECANRSType = interface(IXMLNode)
    ['{4F1D3D1B-9C07-4744-89F5-839F9A03CE51}']
    { Property Accessors }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
  end;

{ IXMLWIRESYNCRSType }

  IXMLWIRESYNCRSType = interface(IXMLNode)
    ['{A490565D-9057-4B56-AE58-788FEF3A6448}']
    { Property Accessors }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetWIRETRNRS: IXMLWIRETRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRSMACRO: UnicodeString read GetSYNCRSMACRO write SetSYNCRSMACRO;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property WIRETRNRS: IXMLWIRETRNRSTypeList read GetWIRETRNRS;
  end;

{ IXMLWIRESYNCRSTypeList }

  IXMLWIRESYNCRSTypeList = interface(IXMLNodeCollection)
    ['{4B43E9E2-2C62-49AC-A610-60D24B2AC95D}']
    { Methods & Properties }
    function Add: IXMLWIRESYNCRSType;
    function Insert(const Index: Integer): IXMLWIRESYNCRSType;

    function GetItem(Index: Integer): IXMLWIRESYNCRSType;
    property Items[Index: Integer]: IXMLWIRESYNCRSType read GetItem; default;
  end;

{ IXMLBANKACCTINFOType }

  IXMLBANKACCTINFOType = interface(IXMLNode)
    ['{2DE36C08-3546-4362-A827-FA4830CC3B60}']
    { Property Accessors }
    function GetBANKACCTFROM: UnicodeString;
    function GetSUPTXDL: UnicodeString;
    function GetXFERSRC: UnicodeString;
    function GetXFERDEST: UnicodeString;
    function GetSVCSTATUS: UnicodeString;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetSUPTXDL(Value: UnicodeString);
    procedure SetXFERSRC(Value: UnicodeString);
    procedure SetXFERDEST(Value: UnicodeString);
    procedure SetSVCSTATUS(Value: UnicodeString);
    { Methods & Properties }
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property SUPTXDL: UnicodeString read GetSUPTXDL write SetSUPTXDL;
    property XFERSRC: UnicodeString read GetXFERSRC write SetXFERSRC;
    property XFERDEST: UnicodeString read GetXFERDEST write SetXFERDEST;
    property SVCSTATUS: UnicodeString read GetSVCSTATUS write SetSVCSTATUS;
  end;

{ IXMLCCACCTINFOType }

  IXMLCCACCTINFOType = interface(IXMLNode)
    ['{64E98D74-620E-40F2-974F-6F2688BB8907}']
    { Property Accessors }
    function GetCCACCTFROM: UnicodeString;
    function GetSUPTXDL: UnicodeString;
    function GetXFERSRC: UnicodeString;
    function GetXFERDEST: UnicodeString;
    function GetSVCSTATUS: UnicodeString;
    procedure SetCCACCTFROM(Value: UnicodeString);
    procedure SetSUPTXDL(Value: UnicodeString);
    procedure SetXFERSRC(Value: UnicodeString);
    procedure SetXFERDEST(Value: UnicodeString);
    procedure SetSVCSTATUS(Value: UnicodeString);
    { Methods & Properties }
    property CCACCTFROM: UnicodeString read GetCCACCTFROM write SetCCACCTFROM;
    property SUPTXDL: UnicodeString read GetSUPTXDL write SetSUPTXDL;
    property XFERSRC: UnicodeString read GetXFERSRC write SetXFERSRC;
    property XFERDEST: UnicodeString read GetXFERDEST write SetXFERDEST;
    property SVCSTATUS: UnicodeString read GetSVCSTATUS write SetSVCSTATUS;
  end;

{ IXMLBILLPAYMSGSRQV1Type }

  IXMLBILLPAYMSGSRQV1Type = interface(IXMLNode)
    ['{9253FFC6-AB3A-4030-8729-A59B0B415627}']
    { Property Accessors }
    function GetPAYEETRNRQ: IXMLPAYEETRNRQTypeList;
    function GetPAYEESYNCRQ: IXMLPAYEESYNCRQTypeList;
    function GetPMTTRNRQ: IXMLPMTTRNRQTypeList;
    function GetRECPMTTRNRQ: IXMLRECPMTTRNRQTypeList;
    function GetPMTINQTRNRQ: IXMLPMTINQTRNRQTypeList;
    function GetPMTMAILTRNRQ: IXMLPMTMAILTRNRQTypeList;
    function GetPMTSYNCRQ: IXMLPMTSYNCRQTypeList;
    function GetRECPMTSYNCRQ: IXMLRECPMTSYNCRQTypeList;
    function GetPMTMAILSYNCRQ: IXMLPMTMAILSYNCRQTypeList;
    { Methods & Properties }
    property PAYEETRNRQ: IXMLPAYEETRNRQTypeList read GetPAYEETRNRQ;
    property PAYEESYNCRQ: IXMLPAYEESYNCRQTypeList read GetPAYEESYNCRQ;
    property PMTTRNRQ: IXMLPMTTRNRQTypeList read GetPMTTRNRQ;
    property RECPMTTRNRQ: IXMLRECPMTTRNRQTypeList read GetRECPMTTRNRQ;
    property PMTINQTRNRQ: IXMLPMTINQTRNRQTypeList read GetPMTINQTRNRQ;
    property PMTMAILTRNRQ: IXMLPMTMAILTRNRQTypeList read GetPMTMAILTRNRQ;
    property PMTSYNCRQ: IXMLPMTSYNCRQTypeList read GetPMTSYNCRQ;
    property RECPMTSYNCRQ: IXMLRECPMTSYNCRQTypeList read GetRECPMTSYNCRQ;
    property PMTMAILSYNCRQ: IXMLPMTMAILSYNCRQTypeList read GetPMTMAILSYNCRQ;
  end;

{ IXMLPAYEETRNRQType }

  IXMLPAYEETRNRQType = interface(IXMLNode)
    ['{C6C06623-C8E3-4BD3-A46F-BA440C078E81}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetPAYEERQ: IXMLPAYEERQType;
    function GetPAYEEMODRQ: IXMLPAYEEMODRQType;
    function GetPAYEEDELRQ: IXMLPAYEEDELRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property PAYEERQ: IXMLPAYEERQType read GetPAYEERQ;
    property PAYEEMODRQ: IXMLPAYEEMODRQType read GetPAYEEMODRQ;
    property PAYEEDELRQ: IXMLPAYEEDELRQType read GetPAYEEDELRQ;
  end;

{ IXMLPAYEETRNRQTypeList }

  IXMLPAYEETRNRQTypeList = interface(IXMLNodeCollection)
    ['{F9275A53-9FB8-4B06-9539-A9EEA91B2327}']
    { Methods & Properties }
    function Add: IXMLPAYEETRNRQType;
    function Insert(const Index: Integer): IXMLPAYEETRNRQType;

    function GetItem(Index: Integer): IXMLPAYEETRNRQType;
    property Items[Index: Integer]: IXMLPAYEETRNRQType read GetItem; default;
  end;

{ IXMLPAYEERQType }

  IXMLPAYEERQType = interface(IXMLNode)
    ['{BE99FAFB-ECC2-46ED-A201-55A15E0CD315}']
    { Property Accessors }
    function GetPAYEEID: UnicodeString;
    function GetPAYEE: IXMLPAYEEType;
    function GetBANKACCTTO: UnicodeString;
    function GetPAYACCT: IXMLString_List;
    procedure SetPAYEEID(Value: UnicodeString);
    procedure SetBANKACCTTO(Value: UnicodeString);
    { Methods & Properties }
    property PAYEEID: UnicodeString read GetPAYEEID write SetPAYEEID;
    property PAYEE: IXMLPAYEEType read GetPAYEE;
    property BANKACCTTO: UnicodeString read GetBANKACCTTO write SetBANKACCTTO;
    property PAYACCT: IXMLString_List read GetPAYACCT;
  end;

{ IXMLPAYEEMODRQType }

  IXMLPAYEEMODRQType = interface(IXMLNode)
    ['{4D1A1203-4545-4620-898E-8F095705F44A}']
    { Property Accessors }
    function GetPAYEELSTID: UnicodeString;
    function GetPAYEE: IXMLPAYEEType;
    function GetBANKACCTTO: UnicodeString;
    function GetPAYACCT: IXMLString_List;
    procedure SetPAYEELSTID(Value: UnicodeString);
    procedure SetBANKACCTTO(Value: UnicodeString);
    { Methods & Properties }
    property PAYEELSTID: UnicodeString read GetPAYEELSTID write SetPAYEELSTID;
    property PAYEE: IXMLPAYEEType read GetPAYEE;
    property BANKACCTTO: UnicodeString read GetBANKACCTTO write SetBANKACCTTO;
    property PAYACCT: IXMLString_List read GetPAYACCT;
  end;

{ IXMLPAYEEDELRQType }

  IXMLPAYEEDELRQType = interface(IXMLNode)
    ['{70DE59D3-65F3-4A49-B2AB-0DF7363FA818}']
    { Property Accessors }
    function GetPAYEELSTID: UnicodeString;
    procedure SetPAYEELSTID(Value: UnicodeString);
    { Methods & Properties }
    property PAYEELSTID: UnicodeString read GetPAYEELSTID write SetPAYEELSTID;
  end;

{ IXMLPAYEESYNCRQType }

  IXMLPAYEESYNCRQType = interface(IXMLNode)
    ['{C839F7B6-68BF-49A9-9CB8-BA232991803A}']
    { Property Accessors }
    function GetSYNCRQMACRO: UnicodeString;
    function GetPAYEETRNRQ: IXMLPAYEETRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRQMACRO: UnicodeString read GetSYNCRQMACRO write SetSYNCRQMACRO;
    property PAYEETRNRQ: IXMLPAYEETRNRQTypeList read GetPAYEETRNRQ;
  end;

{ IXMLPAYEESYNCRQTypeList }

  IXMLPAYEESYNCRQTypeList = interface(IXMLNodeCollection)
    ['{294845DB-BB6C-4462-9754-CF328421848F}']
    { Methods & Properties }
    function Add: IXMLPAYEESYNCRQType;
    function Insert(const Index: Integer): IXMLPAYEESYNCRQType;

    function GetItem(Index: Integer): IXMLPAYEESYNCRQType;
    property Items[Index: Integer]: IXMLPAYEESYNCRQType read GetItem; default;
  end;

{ IXMLPMTTRNRQType }

  IXMLPMTTRNRQType = interface(IXMLNode)
    ['{7A0AAF80-E87E-40F3-8F6A-C5211D952F58}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetPMTRQ: IXMLPMTRQType;
    function GetPMTMODRQ: IXMLPMTMODRQType;
    function GetPMTCANCRQ: IXMLPMTCANCRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property PMTRQ: IXMLPMTRQType read GetPMTRQ;
    property PMTMODRQ: IXMLPMTMODRQType read GetPMTMODRQ;
    property PMTCANCRQ: IXMLPMTCANCRQType read GetPMTCANCRQ;
  end;

{ IXMLPMTTRNRQTypeList }

  IXMLPMTTRNRQTypeList = interface(IXMLNodeCollection)
    ['{ACA6639C-114A-40D6-9D7D-AFA09245E917}']
    { Methods & Properties }
    function Add: IXMLPMTTRNRQType;
    function Insert(const Index: Integer): IXMLPMTTRNRQType;

    function GetItem(Index: Integer): IXMLPMTTRNRQType;
    property Items[Index: Integer]: IXMLPMTTRNRQType read GetItem; default;
  end;

{ IXMLPMTRQType }

  IXMLPMTRQType = interface(IXMLNode)
    ['{E4D07675-30FF-436E-8252-28B40F3C6653}']
    { Property Accessors }
    function GetPMTINFO: IXMLPMTINFOType;
    { Methods & Properties }
    property PMTINFO: IXMLPMTINFOType read GetPMTINFO;
  end;

{ IXMLPMTINFOType }

  IXMLPMTINFOType = interface(IXMLNode)
    ['{A2350303-082E-4A07-A239-5A19FDCD6C16}']
    { Property Accessors }
    function GetBANKACCTFROM: UnicodeString;
    function GetTRNAMT: UnicodeString;
    function GetPAYEEID: UnicodeString;
    function GetPAYEE: IXMLPAYEEType;
    function GetPAYEELSTID: UnicodeString;
    function GetBANKACCTTO: UnicodeString;
    function GetEXTDPMT: IXMLEXTDPMTTypeList;
    function GetPAYACCT: UnicodeString;
    function GetDTDUE: UnicodeString;
    function GetMEMO: UnicodeString;
    function GetBILLREFINFO: UnicodeString;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
    procedure SetPAYEEID(Value: UnicodeString);
    procedure SetPAYEELSTID(Value: UnicodeString);
    procedure SetBANKACCTTO(Value: UnicodeString);
    procedure SetPAYACCT(Value: UnicodeString);
    procedure SetDTDUE(Value: UnicodeString);
    procedure SetMEMO(Value: UnicodeString);
    procedure SetBILLREFINFO(Value: UnicodeString);
    { Methods & Properties }
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property TRNAMT: UnicodeString read GetTRNAMT write SetTRNAMT;
    property PAYEEID: UnicodeString read GetPAYEEID write SetPAYEEID;
    property PAYEE: IXMLPAYEEType read GetPAYEE;
    property PAYEELSTID: UnicodeString read GetPAYEELSTID write SetPAYEELSTID;
    property BANKACCTTO: UnicodeString read GetBANKACCTTO write SetBANKACCTTO;
    property EXTDPMT: IXMLEXTDPMTTypeList read GetEXTDPMT;
    property PAYACCT: UnicodeString read GetPAYACCT write SetPAYACCT;
    property DTDUE: UnicodeString read GetDTDUE write SetDTDUE;
    property MEMO: UnicodeString read GetMEMO write SetMEMO;
    property BILLREFINFO: UnicodeString read GetBILLREFINFO write SetBILLREFINFO;
  end;

{ IXMLEXTDPMTType }

  IXMLEXTDPMTType = interface(IXMLNode)
    ['{A1958A96-67FA-4DD2-8D9E-BE3F42E0256A}']
    { Property Accessors }
    function GetEXTDPMTFOR: UnicodeString;
    function GetEXTDPMTCHK: UnicodeString;
    function GetEXTDPMTDSC: UnicodeString;
    function GetEXTDPMTINV: IXMLEXTDPMTINVType;
    procedure SetEXTDPMTFOR(Value: UnicodeString);
    procedure SetEXTDPMTCHK(Value: UnicodeString);
    procedure SetEXTDPMTDSC(Value: UnicodeString);
    { Methods & Properties }
    property EXTDPMTFOR: UnicodeString read GetEXTDPMTFOR write SetEXTDPMTFOR;
    property EXTDPMTCHK: UnicodeString read GetEXTDPMTCHK write SetEXTDPMTCHK;
    property EXTDPMTDSC: UnicodeString read GetEXTDPMTDSC write SetEXTDPMTDSC;
    property EXTDPMTINV: IXMLEXTDPMTINVType read GetEXTDPMTINV;
  end;

{ IXMLEXTDPMTTypeList }

  IXMLEXTDPMTTypeList = interface(IXMLNodeCollection)
    ['{A637CA00-48D3-44B8-B329-40755F2A82FC}']
    { Methods & Properties }
    function Add: IXMLEXTDPMTType;
    function Insert(const Index: Integer): IXMLEXTDPMTType;

    function GetItem(Index: Integer): IXMLEXTDPMTType;
    property Items[Index: Integer]: IXMLEXTDPMTType read GetItem; default;
  end;

{ IXMLEXTDPMTINVType }

  IXMLEXTDPMTINVType = interface(IXMLNodeCollection)
    ['{336F2B53-EADC-4920-A405-65C67366ABAC}']
    { Property Accessors }
    function GetINVOICE(Index: Integer): IXMLINVOICEType;
    { Methods & Properties }
    function Add: IXMLINVOICEType;
    function Insert(const Index: Integer): IXMLINVOICEType;
    property INVOICE[Index: Integer]: IXMLINVOICEType read GetINVOICE; default;
  end;

{ IXMLINVOICEType }

  IXMLINVOICEType = interface(IXMLNode)
    ['{668FEC87-BE23-43F1-9E8B-4720800B6F46}']
    { Property Accessors }
    function GetINVNO: UnicodeString;
    function GetINVTOTALAMT: UnicodeString;
    function GetINVPAIDAMT: UnicodeString;
    function GetINVDATE: UnicodeString;
    function GetINVDESC: UnicodeString;
    function GetDISCOUNT: IXMLDISCOUNTType;
    function GetADJUSTMENT: IXMLADJUSTMENTType;
    function GetLINEITEM: IXMLLINEITEMTypeList;
    procedure SetINVNO(Value: UnicodeString);
    procedure SetINVTOTALAMT(Value: UnicodeString);
    procedure SetINVPAIDAMT(Value: UnicodeString);
    procedure SetINVDATE(Value: UnicodeString);
    procedure SetINVDESC(Value: UnicodeString);
    { Methods & Properties }
    property INVNO: UnicodeString read GetINVNO write SetINVNO;
    property INVTOTALAMT: UnicodeString read GetINVTOTALAMT write SetINVTOTALAMT;
    property INVPAIDAMT: UnicodeString read GetINVPAIDAMT write SetINVPAIDAMT;
    property INVDATE: UnicodeString read GetINVDATE write SetINVDATE;
    property INVDESC: UnicodeString read GetINVDESC write SetINVDESC;
    property DISCOUNT: IXMLDISCOUNTType read GetDISCOUNT;
    property ADJUSTMENT: IXMLADJUSTMENTType read GetADJUSTMENT;
    property LINEITEM: IXMLLINEITEMTypeList read GetLINEITEM;
  end;

{ IXMLDISCOUNTType }

  IXMLDISCOUNTType = interface(IXMLNode)
    ['{765C1A5C-C2AA-4C28-A041-76C904554CD6}']
    { Property Accessors }
    function GetDSCRATE: UnicodeString;
    function GetDSCAMT: UnicodeString;
    function GetDSCDATE: UnicodeString;
    function GetDSCDESC: UnicodeString;
    procedure SetDSCRATE(Value: UnicodeString);
    procedure SetDSCAMT(Value: UnicodeString);
    procedure SetDSCDATE(Value: UnicodeString);
    procedure SetDSCDESC(Value: UnicodeString);
    { Methods & Properties }
    property DSCRATE: UnicodeString read GetDSCRATE write SetDSCRATE;
    property DSCAMT: UnicodeString read GetDSCAMT write SetDSCAMT;
    property DSCDATE: UnicodeString read GetDSCDATE write SetDSCDATE;
    property DSCDESC: UnicodeString read GetDSCDESC write SetDSCDESC;
  end;

{ IXMLADJUSTMENTType }

  IXMLADJUSTMENTType = interface(IXMLNode)
    ['{3B0C11C0-8E94-4A7F-B985-C32B5D76FF8F}']
    { Property Accessors }
    function GetADJNO: UnicodeString;
    function GetADJDESC: UnicodeString;
    function GetADJAMT: UnicodeString;
    function GetADJDATE: UnicodeString;
    procedure SetADJNO(Value: UnicodeString);
    procedure SetADJDESC(Value: UnicodeString);
    procedure SetADJAMT(Value: UnicodeString);
    procedure SetADJDATE(Value: UnicodeString);
    { Methods & Properties }
    property ADJNO: UnicodeString read GetADJNO write SetADJNO;
    property ADJDESC: UnicodeString read GetADJDESC write SetADJDESC;
    property ADJAMT: UnicodeString read GetADJAMT write SetADJAMT;
    property ADJDATE: UnicodeString read GetADJDATE write SetADJDATE;
  end;

{ IXMLLINEITEMType }

  IXMLLINEITEMType = interface(IXMLNode)
    ['{AD5B887B-AADC-4027-BF7C-52AFD27D9A24}']
    { Property Accessors }
    function GetLITMAMT: UnicodeString;
    function GetLITMDESC: UnicodeString;
    procedure SetLITMAMT(Value: UnicodeString);
    procedure SetLITMDESC(Value: UnicodeString);
    { Methods & Properties }
    property LITMAMT: UnicodeString read GetLITMAMT write SetLITMAMT;
    property LITMDESC: UnicodeString read GetLITMDESC write SetLITMDESC;
  end;

{ IXMLLINEITEMTypeList }

  IXMLLINEITEMTypeList = interface(IXMLNodeCollection)
    ['{6552A499-26BB-48A6-9497-422A7842BFFD}']
    { Methods & Properties }
    function Add: IXMLLINEITEMType;
    function Insert(const Index: Integer): IXMLLINEITEMType;

    function GetItem(Index: Integer): IXMLLINEITEMType;
    property Items[Index: Integer]: IXMLLINEITEMType read GetItem; default;
  end;

{ IXMLPMTMODRQType }

  IXMLPMTMODRQType = interface(IXMLNode)
    ['{9CC867D1-2B3A-4503-86BC-97C7623DB1D0}']
    { Property Accessors }
    function GetSRVRTID: UnicodeString;
    function GetPMTINFO: IXMLPMTINFOType;
    procedure SetSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
    property PMTINFO: IXMLPMTINFOType read GetPMTINFO;
  end;

{ IXMLPMTCANCRQType }

  IXMLPMTCANCRQType = interface(IXMLNode)
    ['{3AB61B8E-0ADD-4BE2-A0DA-D2384A176092}']
    { Property Accessors }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
  end;

{ IXMLRECPMTTRNRQType }

  IXMLRECPMTTRNRQType = interface(IXMLNode)
    ['{70D0FC4D-C768-4223-AA2D-83DE66A7E10F}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetRECPMTRQ: IXMLRECPMTRQType;
    function GetRECPMTMODRQ: IXMLRECPMTMODRQType;
    function GetRECPMTCANCRQ: IXMLRECPMTCANCRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property RECPMTRQ: IXMLRECPMTRQType read GetRECPMTRQ;
    property RECPMTMODRQ: IXMLRECPMTMODRQType read GetRECPMTMODRQ;
    property RECPMTCANCRQ: IXMLRECPMTCANCRQType read GetRECPMTCANCRQ;
  end;

{ IXMLRECPMTTRNRQTypeList }

  IXMLRECPMTTRNRQTypeList = interface(IXMLNodeCollection)
    ['{2B8D5EFF-910D-4856-B524-AADED27FD8B9}']
    { Methods & Properties }
    function Add: IXMLRECPMTTRNRQType;
    function Insert(const Index: Integer): IXMLRECPMTTRNRQType;

    function GetItem(Index: Integer): IXMLRECPMTTRNRQType;
    property Items[Index: Integer]: IXMLRECPMTTRNRQType read GetItem; default;
  end;

{ IXMLRECPMTRQType }

  IXMLRECPMTRQType = interface(IXMLNode)
    ['{D149E5ED-3480-46E1-810D-40A3DA4622B1}']
    { Property Accessors }
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetPMTINFO: IXMLPMTINFOType;
    function GetINITIALAMT: UnicodeString;
    function GetFINALAMT: UnicodeString;
    procedure SetINITIALAMT(Value: UnicodeString);
    procedure SetFINALAMT(Value: UnicodeString);
    { Methods & Properties }
    property RECURRINST: IXMLRECURRINSTType read GetRECURRINST;
    property PMTINFO: IXMLPMTINFOType read GetPMTINFO;
    property INITIALAMT: UnicodeString read GetINITIALAMT write SetINITIALAMT;
    property FINALAMT: UnicodeString read GetFINALAMT write SetFINALAMT;
  end;

{ IXMLRECPMTMODRQType }

  IXMLRECPMTMODRQType = interface(IXMLNode)
    ['{2360338E-FF89-4241-A0AF-04A8AB938FD0}']
    { Property Accessors }
    function GetRECSRVRTID: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetPMTINFO: IXMLPMTINFOType;
    function GetINITIALAMT: UnicodeString;
    function GetFINALAMT: UnicodeString;
    function GetMODPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetINITIALAMT(Value: UnicodeString);
    procedure SetFINALAMT(Value: UnicodeString);
    procedure SetMODPENDING(Value: UnicodeString);
    { Methods & Properties }
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
    property RECURRINST: IXMLRECURRINSTType read GetRECURRINST;
    property PMTINFO: IXMLPMTINFOType read GetPMTINFO;
    property INITIALAMT: UnicodeString read GetINITIALAMT write SetINITIALAMT;
    property FINALAMT: UnicodeString read GetFINALAMT write SetFINALAMT;
    property MODPENDING: UnicodeString read GetMODPENDING write SetMODPENDING;
  end;

{ IXMLRECPMTCANCRQType }

  IXMLRECPMTCANCRQType = interface(IXMLNode)
    ['{3DBBDC9E-E3E2-4D08-A825-303BAD461542}']
    { Property Accessors }
    function GetRECSRVRTID: UnicodeString;
    function GetCANPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetCANPENDING(Value: UnicodeString);
    { Methods & Properties }
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
    property CANPENDING: UnicodeString read GetCANPENDING write SetCANPENDING;
  end;

{ IXMLPMTINQTRNRQType }

  IXMLPMTINQTRNRQType = interface(IXMLNode)
    ['{E1A13AB0-EBB7-4711-AC89-B0FB3A3F2759}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetPMTINQRQ: IXMLPMTINQRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property PMTINQRQ: IXMLPMTINQRQType read GetPMTINQRQ;
  end;

{ IXMLPMTINQTRNRQTypeList }

  IXMLPMTINQTRNRQTypeList = interface(IXMLNodeCollection)
    ['{8D9CD795-76BC-499C-A52B-ECD5EB812CE4}']
    { Methods & Properties }
    function Add: IXMLPMTINQTRNRQType;
    function Insert(const Index: Integer): IXMLPMTINQTRNRQType;

    function GetItem(Index: Integer): IXMLPMTINQTRNRQType;
    property Items[Index: Integer]: IXMLPMTINQTRNRQType read GetItem; default;
  end;

{ IXMLPMTINQRQType }

  IXMLPMTINQRQType = interface(IXMLNode)
    ['{B6ACDDEC-5B4D-47C6-B2E4-B21F51D05416}']
    { Property Accessors }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
  end;

{ IXMLPMTMAILTRNRQType }

  IXMLPMTMAILTRNRQType = interface(IXMLNode)
    ['{12257EAD-147A-4058-B13B-332C73170D14}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetPMTMAILRQ: IXMLPMTMAILRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property PMTMAILRQ: IXMLPMTMAILRQType read GetPMTMAILRQ;
  end;

{ IXMLPMTMAILTRNRQTypeList }

  IXMLPMTMAILTRNRQTypeList = interface(IXMLNodeCollection)
    ['{317928B2-BB86-4CAA-890D-271B3CAFC2F9}']
    { Methods & Properties }
    function Add: IXMLPMTMAILTRNRQType;
    function Insert(const Index: Integer): IXMLPMTMAILTRNRQType;

    function GetItem(Index: Integer): IXMLPMTMAILTRNRQType;
    property Items[Index: Integer]: IXMLPMTMAILTRNRQType read GetItem; default;
  end;

{ IXMLPMTMAILRQType }

  IXMLPMTMAILRQType = interface(IXMLNode)
    ['{E08D6347-E59F-4094-9D3F-135D1A50BE38}']
    { Property Accessors }
    function GetMAIL: IXMLMAILType;
    function GetSRVRTID: UnicodeString;
    function GetPMTINFO: IXMLPMTINFOType;
    procedure SetSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property MAIL: IXMLMAILType read GetMAIL;
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
    property PMTINFO: IXMLPMTINFOType read GetPMTINFO;
  end;

{ IXMLPMTSYNCRQType }

  IXMLPMTSYNCRQType = interface(IXMLNode)
    ['{AF7014C6-3E31-4CE7-8D85-CE3E48E703A1}']
    { Property Accessors }
    function GetSYNCRQMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetPMTTRNRQ: IXMLPMTTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRQMACRO: UnicodeString read GetSYNCRQMACRO write SetSYNCRQMACRO;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property PMTTRNRQ: IXMLPMTTRNRQTypeList read GetPMTTRNRQ;
  end;

{ IXMLPMTSYNCRQTypeList }

  IXMLPMTSYNCRQTypeList = interface(IXMLNodeCollection)
    ['{EA98D7B2-328E-4E77-AAA2-3268FEA1FA9A}']
    { Methods & Properties }
    function Add: IXMLPMTSYNCRQType;
    function Insert(const Index: Integer): IXMLPMTSYNCRQType;

    function GetItem(Index: Integer): IXMLPMTSYNCRQType;
    property Items[Index: Integer]: IXMLPMTSYNCRQType read GetItem; default;
  end;

{ IXMLRECPMTSYNCRQType }

  IXMLRECPMTSYNCRQType = interface(IXMLNode)
    ['{80A398B0-5FAB-4462-B301-D62A55698F51}']
    { Property Accessors }
    function GetSYNCRQMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetRECPMTTRNRQ: IXMLRECPMTTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRQMACRO: UnicodeString read GetSYNCRQMACRO write SetSYNCRQMACRO;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property RECPMTTRNRQ: IXMLRECPMTTRNRQTypeList read GetRECPMTTRNRQ;
  end;

{ IXMLRECPMTSYNCRQTypeList }

  IXMLRECPMTSYNCRQTypeList = interface(IXMLNodeCollection)
    ['{260B8873-2AFA-4182-BEC4-6E5D3335A146}']
    { Methods & Properties }
    function Add: IXMLRECPMTSYNCRQType;
    function Insert(const Index: Integer): IXMLRECPMTSYNCRQType;

    function GetItem(Index: Integer): IXMLRECPMTSYNCRQType;
    property Items[Index: Integer]: IXMLRECPMTSYNCRQType read GetItem; default;
  end;

{ IXMLPMTMAILSYNCRQType }

  IXMLPMTMAILSYNCRQType = interface(IXMLNode)
    ['{3357B79A-8C53-403E-863A-96133477F759}']
    { Property Accessors }
    function GetSYNCRQMACRO: UnicodeString;
    function GetINCIMAGES: UnicodeString;
    function GetUSEHTML: UnicodeString;
    function GetPMTMAILTRNRQ: IXMLPMTMAILTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetINCIMAGES(Value: UnicodeString);
    procedure SetUSEHTML(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRQMACRO: UnicodeString read GetSYNCRQMACRO write SetSYNCRQMACRO;
    property INCIMAGES: UnicodeString read GetINCIMAGES write SetINCIMAGES;
    property USEHTML: UnicodeString read GetUSEHTML write SetUSEHTML;
    property PMTMAILTRNRQ: IXMLPMTMAILTRNRQTypeList read GetPMTMAILTRNRQ;
  end;

{ IXMLPMTMAILSYNCRQTypeList }

  IXMLPMTMAILSYNCRQTypeList = interface(IXMLNodeCollection)
    ['{C64D840C-736A-48F8-8410-8A64A4949209}']
    { Methods & Properties }
    function Add: IXMLPMTMAILSYNCRQType;
    function Insert(const Index: Integer): IXMLPMTMAILSYNCRQType;

    function GetItem(Index: Integer): IXMLPMTMAILSYNCRQType;
    property Items[Index: Integer]: IXMLPMTMAILSYNCRQType read GetItem; default;
  end;

{ IXMLBILLPAYMSGSRSV1Type }

  IXMLBILLPAYMSGSRSV1Type = interface(IXMLNode)
    ['{E0E26E9B-7D91-412F-9F5A-4146C29DEAE8}']
    { Property Accessors }
    function GetPAYEETRNRS: IXMLPAYEETRNRSTypeList;
    function GetPAYEESYNCRS: IXMLPAYEESYNCRSTypeList;
    function GetPMTTRNRS: IXMLPMTTRNRSTypeList;
    function GetRECPMTTRNRS: IXMLRECPMTTRNRSTypeList;
    function GetPMTINQTRNRS: IXMLPMTINQTRNRSTypeList;
    function GetPMTMAILTRNRS: IXMLPMTMAILTRNRSTypeList;
    function GetPMTSYNCRS: IXMLPMTSYNCRSTypeList;
    function GetRECPMTSYNCRS: IXMLRECPMTSYNCRSTypeList;
    function GetPMTMAILSYNCRS: IXMLPMTMAILSYNCRSTypeList;
    { Methods & Properties }
    property PAYEETRNRS: IXMLPAYEETRNRSTypeList read GetPAYEETRNRS;
    property PAYEESYNCRS: IXMLPAYEESYNCRSTypeList read GetPAYEESYNCRS;
    property PMTTRNRS: IXMLPMTTRNRSTypeList read GetPMTTRNRS;
    property RECPMTTRNRS: IXMLRECPMTTRNRSTypeList read GetRECPMTTRNRS;
    property PMTINQTRNRS: IXMLPMTINQTRNRSTypeList read GetPMTINQTRNRS;
    property PMTMAILTRNRS: IXMLPMTMAILTRNRSTypeList read GetPMTMAILTRNRS;
    property PMTSYNCRS: IXMLPMTSYNCRSTypeList read GetPMTSYNCRS;
    property RECPMTSYNCRS: IXMLRECPMTSYNCRSTypeList read GetRECPMTSYNCRS;
    property PMTMAILSYNCRS: IXMLPMTMAILSYNCRSTypeList read GetPMTMAILSYNCRS;
  end;

{ IXMLPAYEETRNRSType }

  IXMLPAYEETRNRSType = interface(IXMLNode)
    ['{704D5387-4B00-4A85-9D10-5241D78F4F1C}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetPAYEERS: IXMLPAYEERSType;
    function GetPAYEEMODRS: IXMLPAYEEMODRSType;
    function GetPAYEEDELRS: IXMLPAYEEDELRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property PAYEERS: IXMLPAYEERSType read GetPAYEERS;
    property PAYEEMODRS: IXMLPAYEEMODRSType read GetPAYEEMODRS;
    property PAYEEDELRS: IXMLPAYEEDELRSType read GetPAYEEDELRS;
  end;

{ IXMLPAYEETRNRSTypeList }

  IXMLPAYEETRNRSTypeList = interface(IXMLNodeCollection)
    ['{EB1A8301-0FF0-4ABF-BF5B-793CCD265F4E}']
    { Methods & Properties }
    function Add: IXMLPAYEETRNRSType;
    function Insert(const Index: Integer): IXMLPAYEETRNRSType;

    function GetItem(Index: Integer): IXMLPAYEETRNRSType;
    property Items[Index: Integer]: IXMLPAYEETRNRSType read GetItem; default;
  end;

{ IXMLPAYEERSType }

  IXMLPAYEERSType = interface(IXMLNode)
    ['{EC4E5BEB-425B-425A-B65B-20DAE96FB0F3}']
    { Property Accessors }
    function GetPAYEELSTID: UnicodeString;
    function GetPAYEE: IXMLPAYEEType;
    function GetBANKACCTTO: UnicodeString;
    function GetEXTDPAYEE: IXMLEXTDPAYEEType;
    function GetPAYACCT: IXMLString_List;
    procedure SetPAYEELSTID(Value: UnicodeString);
    procedure SetBANKACCTTO(Value: UnicodeString);
    { Methods & Properties }
    property PAYEELSTID: UnicodeString read GetPAYEELSTID write SetPAYEELSTID;
    property PAYEE: IXMLPAYEEType read GetPAYEE;
    property BANKACCTTO: UnicodeString read GetBANKACCTTO write SetBANKACCTTO;
    property EXTDPAYEE: IXMLEXTDPAYEEType read GetEXTDPAYEE;
    property PAYACCT: IXMLString_List read GetPAYACCT;
  end;

{ IXMLEXTDPAYEEType }

  IXMLEXTDPAYEEType = interface(IXMLNode)
    ['{41E51AE9-8EA4-4FA3-9DE3-B01CB7D9B281}']
    { Property Accessors }
    function GetPAYEEID: UnicodeString;
    function GetIDSCOPE: UnicodeString;
    function GetNAME: UnicodeString;
    function GetDAYSTOPAY: UnicodeString;
    procedure SetPAYEEID(Value: UnicodeString);
    procedure SetIDSCOPE(Value: UnicodeString);
    procedure SetNAME(Value: UnicodeString);
    procedure SetDAYSTOPAY(Value: UnicodeString);
    { Methods & Properties }
    property PAYEEID: UnicodeString read GetPAYEEID write SetPAYEEID;
    property IDSCOPE: UnicodeString read GetIDSCOPE write SetIDSCOPE;
    property NAME: UnicodeString read GetNAME write SetNAME;
    property DAYSTOPAY: UnicodeString read GetDAYSTOPAY write SetDAYSTOPAY;
  end;

{ IXMLPAYEEMODRSType }

  IXMLPAYEEMODRSType = interface(IXMLNode)
    ['{9066B66C-4D86-4F61-ACAC-A14F3ACFDF21}']
    { Property Accessors }
    function GetPAYEELSTID: UnicodeString;
    function GetPAYEE: IXMLPAYEEType;
    function GetBANKACCTTO: UnicodeString;
    function GetPAYACCT: IXMLString_List;
    function GetEXTDPAYEE: IXMLEXTDPAYEEType;
    procedure SetPAYEELSTID(Value: UnicodeString);
    procedure SetBANKACCTTO(Value: UnicodeString);
    { Methods & Properties }
    property PAYEELSTID: UnicodeString read GetPAYEELSTID write SetPAYEELSTID;
    property PAYEE: IXMLPAYEEType read GetPAYEE;
    property BANKACCTTO: UnicodeString read GetBANKACCTTO write SetBANKACCTTO;
    property PAYACCT: IXMLString_List read GetPAYACCT;
    property EXTDPAYEE: IXMLEXTDPAYEEType read GetEXTDPAYEE;
  end;

{ IXMLPAYEEDELRSType }

  IXMLPAYEEDELRSType = interface(IXMLNode)
    ['{4C978AB1-9CF8-415D-A748-715C5073DA8A}']
    { Property Accessors }
    function GetPAYEELSTID: UnicodeString;
    procedure SetPAYEELSTID(Value: UnicodeString);
    { Methods & Properties }
    property PAYEELSTID: UnicodeString read GetPAYEELSTID write SetPAYEELSTID;
  end;

{ IXMLPAYEESYNCRSType }

  IXMLPAYEESYNCRSType = interface(IXMLNode)
    ['{F15BF997-5C86-4068-9F74-AA0E900D8597}']
    { Property Accessors }
    function GetSYNCRSMACRO: UnicodeString;
    function GetPAYEETRNRS: IXMLPAYEETRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRSMACRO: UnicodeString read GetSYNCRSMACRO write SetSYNCRSMACRO;
    property PAYEETRNRS: IXMLPAYEETRNRSTypeList read GetPAYEETRNRS;
  end;

{ IXMLPAYEESYNCRSTypeList }

  IXMLPAYEESYNCRSTypeList = interface(IXMLNodeCollection)
    ['{3E679773-ECCE-4E80-B7DD-537D03F6502F}']
    { Methods & Properties }
    function Add: IXMLPAYEESYNCRSType;
    function Insert(const Index: Integer): IXMLPAYEESYNCRSType;

    function GetItem(Index: Integer): IXMLPAYEESYNCRSType;
    property Items[Index: Integer]: IXMLPAYEESYNCRSType read GetItem; default;
  end;

{ IXMLPMTTRNRSType }

  IXMLPMTTRNRSType = interface(IXMLNode)
    ['{C1C90287-E405-4F00-9D40-8B15EBCFABA4}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetPMTRS: IXMLPMTRSType;
    function GetPMTMODRS: IXMLPMTMODRSType;
    function GetPMTCANCRS: IXMLPMTCANCRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property PMTRS: IXMLPMTRSType read GetPMTRS;
    property PMTMODRS: IXMLPMTMODRSType read GetPMTMODRS;
    property PMTCANCRS: IXMLPMTCANCRSType read GetPMTCANCRS;
  end;

{ IXMLPMTTRNRSTypeList }

  IXMLPMTTRNRSTypeList = interface(IXMLNodeCollection)
    ['{25A54A5F-1DB6-47DB-ACA2-403575F379F2}']
    { Methods & Properties }
    function Add: IXMLPMTTRNRSType;
    function Insert(const Index: Integer): IXMLPMTTRNRSType;

    function GetItem(Index: Integer): IXMLPMTTRNRSType;
    property Items[Index: Integer]: IXMLPMTTRNRSType read GetItem; default;
  end;

{ IXMLPMTRSType }

  IXMLPMTRSType = interface(IXMLNode)
    ['{EEB5BF8E-1845-4B8F-8F9F-0F1E77D43244}']
    { Property Accessors }
    function GetSRVRTID: UnicodeString;
    function GetPAYEELSTID: UnicodeString;
    function GetCURDEF: UnicodeString;
    function GetPMTINFO: IXMLPMTINFOType;
    function GetEXTDPAYEE: IXMLEXTDPAYEEType;
    function GetCHECKNUM: UnicodeString;
    function GetPMTPRCSTS: IXMLPMTPRCSTSType;
    function GetRECSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
    procedure SetPAYEELSTID(Value: UnicodeString);
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetCHECKNUM(Value: UnicodeString);
    procedure SetRECSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
    property PAYEELSTID: UnicodeString read GetPAYEELSTID write SetPAYEELSTID;
    property CURDEF: UnicodeString read GetCURDEF write SetCURDEF;
    property PMTINFO: IXMLPMTINFOType read GetPMTINFO;
    property EXTDPAYEE: IXMLEXTDPAYEEType read GetEXTDPAYEE;
    property CHECKNUM: UnicodeString read GetCHECKNUM write SetCHECKNUM;
    property PMTPRCSTS: IXMLPMTPRCSTSType read GetPMTPRCSTS;
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
  end;

{ IXMLPMTPRCSTSType }

  IXMLPMTPRCSTSType = interface(IXMLNode)
    ['{9E4DEFB1-76B0-4E44-B8EF-45444839B6E6}']
    { Property Accessors }
    function GetPMTPRCCODE: UnicodeString;
    function GetDTPMTPRC: UnicodeString;
    procedure SetPMTPRCCODE(Value: UnicodeString);
    procedure SetDTPMTPRC(Value: UnicodeString);
    { Methods & Properties }
    property PMTPRCCODE: UnicodeString read GetPMTPRCCODE write SetPMTPRCCODE;
    property DTPMTPRC: UnicodeString read GetDTPMTPRC write SetDTPMTPRC;
  end;

{ IXMLPMTMODRSType }

  IXMLPMTMODRSType = interface(IXMLNode)
    ['{1CC1D384-C7CD-481B-B75F-EDD216546DE6}']
    { Property Accessors }
    function GetSRVRTID: UnicodeString;
    function GetPMTINFO: IXMLPMTINFOType;
    function GetPMTPRCSTS: IXMLPMTPRCSTSType;
    procedure SetSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
    property PMTINFO: IXMLPMTINFOType read GetPMTINFO;
    property PMTPRCSTS: IXMLPMTPRCSTSType read GetPMTPRCSTS;
  end;

{ IXMLPMTCANCRSType }

  IXMLPMTCANCRSType = interface(IXMLNode)
    ['{81FA70C3-7660-4935-B760-90B2F6629CA5}']
    { Property Accessors }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
  end;

{ IXMLRECPMTTRNRSType }

  IXMLRECPMTTRNRSType = interface(IXMLNode)
    ['{A1A8169A-7F32-436D-9942-8863136856B1}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetRECPMTRS: IXMLRECPMTRSType;
    function GetRECPMTMODRS: IXMLRECPMTMODRSType;
    function GetRECPMTCANCRS: IXMLRECPMTCANCRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property RECPMTRS: IXMLRECPMTRSType read GetRECPMTRS;
    property RECPMTMODRS: IXMLRECPMTMODRSType read GetRECPMTMODRS;
    property RECPMTCANCRS: IXMLRECPMTCANCRSType read GetRECPMTCANCRS;
  end;

{ IXMLRECPMTTRNRSTypeList }

  IXMLRECPMTTRNRSTypeList = interface(IXMLNodeCollection)
    ['{E547136D-63DC-45DB-9CFE-BBF3FC60BD11}']
    { Methods & Properties }
    function Add: IXMLRECPMTTRNRSType;
    function Insert(const Index: Integer): IXMLRECPMTTRNRSType;

    function GetItem(Index: Integer): IXMLRECPMTTRNRSType;
    property Items[Index: Integer]: IXMLRECPMTTRNRSType read GetItem; default;
  end;

{ IXMLRECPMTRSType }

  IXMLRECPMTRSType = interface(IXMLNode)
    ['{7591635F-CF54-4074-ACED-838B0545FC8B}']
    { Property Accessors }
    function GetRECSRVRTID: UnicodeString;
    function GetPAYEELSTID: UnicodeString;
    function GetCURDEF: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetPMTINFO: IXMLPMTINFOType;
    function GetINITIALAMT: UnicodeString;
    function GetFINALAMT: UnicodeString;
    function GetEXTDPAYEE: IXMLEXTDPAYEEType;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetPAYEELSTID(Value: UnicodeString);
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetINITIALAMT(Value: UnicodeString);
    procedure SetFINALAMT(Value: UnicodeString);
    { Methods & Properties }
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
    property PAYEELSTID: UnicodeString read GetPAYEELSTID write SetPAYEELSTID;
    property CURDEF: UnicodeString read GetCURDEF write SetCURDEF;
    property RECURRINST: IXMLRECURRINSTType read GetRECURRINST;
    property PMTINFO: IXMLPMTINFOType read GetPMTINFO;
    property INITIALAMT: UnicodeString read GetINITIALAMT write SetINITIALAMT;
    property FINALAMT: UnicodeString read GetFINALAMT write SetFINALAMT;
    property EXTDPAYEE: IXMLEXTDPAYEEType read GetEXTDPAYEE;
  end;

{ IXMLRECPMTMODRSType }

  IXMLRECPMTMODRSType = interface(IXMLNode)
    ['{16DB71EB-17EF-4AC6-AEB0-D808C34D67CE}']
    { Property Accessors }
    function GetRECSRVRTID: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetPMTINFO: IXMLPMTINFOType;
    function GetINITIALAMT: UnicodeString;
    function GetFINALAMT: UnicodeString;
    function GetMODPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetINITIALAMT(Value: UnicodeString);
    procedure SetFINALAMT(Value: UnicodeString);
    procedure SetMODPENDING(Value: UnicodeString);
    { Methods & Properties }
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
    property RECURRINST: IXMLRECURRINSTType read GetRECURRINST;
    property PMTINFO: IXMLPMTINFOType read GetPMTINFO;
    property INITIALAMT: UnicodeString read GetINITIALAMT write SetINITIALAMT;
    property FINALAMT: UnicodeString read GetFINALAMT write SetFINALAMT;
    property MODPENDING: UnicodeString read GetMODPENDING write SetMODPENDING;
  end;

{ IXMLRECPMTCANCRSType }

  IXMLRECPMTCANCRSType = interface(IXMLNode)
    ['{FF3F5548-B9C0-4B98-AD65-4CB80F1ACD53}']
    { Property Accessors }
    function GetRECSRVRTID: UnicodeString;
    function GetCANPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetCANPENDING(Value: UnicodeString);
    { Methods & Properties }
    property RECSRVRTID: UnicodeString read GetRECSRVRTID write SetRECSRVRTID;
    property CANPENDING: UnicodeString read GetCANPENDING write SetCANPENDING;
  end;

{ IXMLPMTINQTRNRSType }

  IXMLPMTINQTRNRSType = interface(IXMLNode)
    ['{549469C2-D87B-4744-B10E-EA6B24D10540}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetPMTINQRS: IXMLPMTINQRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property PMTINQRS: IXMLPMTINQRSType read GetPMTINQRS;
  end;

{ IXMLPMTINQTRNRSTypeList }

  IXMLPMTINQTRNRSTypeList = interface(IXMLNodeCollection)
    ['{E84A2FCA-97D4-4336-957D-A74F5E62C67F}']
    { Methods & Properties }
    function Add: IXMLPMTINQTRNRSType;
    function Insert(const Index: Integer): IXMLPMTINQTRNRSType;

    function GetItem(Index: Integer): IXMLPMTINQTRNRSType;
    property Items[Index: Integer]: IXMLPMTINQTRNRSType read GetItem; default;
  end;

{ IXMLPMTINQRSType }

  IXMLPMTINQRSType = interface(IXMLNode)
    ['{A327D64E-FFB9-46FF-A9C9-92C2719F5212}']
    { Property Accessors }
    function GetSRVRTID: UnicodeString;
    function GetPMTPRCSTS: IXMLPMTPRCSTSType;
    function GetCHECKNUM: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
    procedure SetCHECKNUM(Value: UnicodeString);
    { Methods & Properties }
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
    property PMTPRCSTS: IXMLPMTPRCSTSType read GetPMTPRCSTS;
    property CHECKNUM: UnicodeString read GetCHECKNUM write SetCHECKNUM;
  end;

{ IXMLPMTMAILTRNRSType }

  IXMLPMTMAILTRNRSType = interface(IXMLNode)
    ['{A447F883-23DC-4BE4-B284-890F95D423D2}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetPMTMAILRS: IXMLPMTMAILRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property PMTMAILRS: IXMLPMTMAILRSType read GetPMTMAILRS;
  end;

{ IXMLPMTMAILTRNRSTypeList }

  IXMLPMTMAILTRNRSTypeList = interface(IXMLNodeCollection)
    ['{5D9314B3-628C-4CEB-BCC8-434F76DBE955}']
    { Methods & Properties }
    function Add: IXMLPMTMAILTRNRSType;
    function Insert(const Index: Integer): IXMLPMTMAILTRNRSType;

    function GetItem(Index: Integer): IXMLPMTMAILTRNRSType;
    property Items[Index: Integer]: IXMLPMTMAILTRNRSType read GetItem; default;
  end;

{ IXMLPMTMAILRSType }

  IXMLPMTMAILRSType = interface(IXMLNode)
    ['{7547A4AC-6480-4614-917C-997379759982}']
    { Property Accessors }
    function GetMAIL: IXMLMAILType;
    function GetSRVRTID: UnicodeString;
    function GetPMTINFO: IXMLPMTINFOType;
    procedure SetSRVRTID(Value: UnicodeString);
    { Methods & Properties }
    property MAIL: IXMLMAILType read GetMAIL;
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
    property PMTINFO: IXMLPMTINFOType read GetPMTINFO;
  end;

{ IXMLPMTSYNCRSType }

  IXMLPMTSYNCRSType = interface(IXMLNode)
    ['{82771631-9D30-40D4-BCDB-B11F487E68B7}']
    { Property Accessors }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetPMTTRNRS: IXMLPMTTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRSMACRO: UnicodeString read GetSYNCRSMACRO write SetSYNCRSMACRO;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property PMTTRNRS: IXMLPMTTRNRSTypeList read GetPMTTRNRS;
  end;

{ IXMLPMTSYNCRSTypeList }

  IXMLPMTSYNCRSTypeList = interface(IXMLNodeCollection)
    ['{CAC86CF5-239A-4BBA-944E-812E7DEB37E4}']
    { Methods & Properties }
    function Add: IXMLPMTSYNCRSType;
    function Insert(const Index: Integer): IXMLPMTSYNCRSType;

    function GetItem(Index: Integer): IXMLPMTSYNCRSType;
    property Items[Index: Integer]: IXMLPMTSYNCRSType read GetItem; default;
  end;

{ IXMLRECPMTSYNCRSType }

  IXMLRECPMTSYNCRSType = interface(IXMLNode)
    ['{B6EBBAC5-3DC7-4450-B831-7EE3E53D5B29}']
    { Property Accessors }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetRECPMTTRNRS: IXMLRECPMTTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRSMACRO: UnicodeString read GetSYNCRSMACRO write SetSYNCRSMACRO;
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property RECPMTTRNRS: IXMLRECPMTTRNRSTypeList read GetRECPMTTRNRS;
  end;

{ IXMLRECPMTSYNCRSTypeList }

  IXMLRECPMTSYNCRSTypeList = interface(IXMLNodeCollection)
    ['{E0AC1F25-0AAD-49C4-AD40-A11B5649B7DB}']
    { Methods & Properties }
    function Add: IXMLRECPMTSYNCRSType;
    function Insert(const Index: Integer): IXMLRECPMTSYNCRSType;

    function GetItem(Index: Integer): IXMLRECPMTSYNCRSType;
    property Items[Index: Integer]: IXMLRECPMTSYNCRSType read GetItem; default;
  end;

{ IXMLPMTMAILSYNCRSType }

  IXMLPMTMAILSYNCRSType = interface(IXMLNode)
    ['{5EC02939-3FF4-43C4-AA26-F55AA0A00A0B}']
    { Property Accessors }
    function GetSYNCRSMACRO: UnicodeString;
    function GetPMTMAILTRNRS: IXMLPMTMAILTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRSMACRO: UnicodeString read GetSYNCRSMACRO write SetSYNCRSMACRO;
    property PMTMAILTRNRS: IXMLPMTMAILTRNRSTypeList read GetPMTMAILTRNRS;
  end;

{ IXMLPMTMAILSYNCRSTypeList }

  IXMLPMTMAILSYNCRSTypeList = interface(IXMLNodeCollection)
    ['{F9242438-5C15-4B90-9A05-CC80ABC006B7}']
    { Methods & Properties }
    function Add: IXMLPMTMAILSYNCRSType;
    function Insert(const Index: Integer): IXMLPMTMAILSYNCRSType;

    function GetItem(Index: Integer): IXMLPMTMAILSYNCRSType;
    property Items[Index: Integer]: IXMLPMTMAILSYNCRSType read GetItem; default;
  end;

{ IXMLBILLPAYMSGSETType }

  IXMLBILLPAYMSGSETType = interface(IXMLNode)
    ['{6AEAA730-4ADC-447C-8CC3-C476C1FAE5E2}']
    { Property Accessors }
    function GetBILLPAYMSGSETV1: IXMLBILLPAYMSGSETV1Type;
    { Methods & Properties }
    property BILLPAYMSGSETV1: IXMLBILLPAYMSGSETV1Type read GetBILLPAYMSGSETV1;
  end;

{ IXMLBILLPAYMSGSETV1Type }

  IXMLBILLPAYMSGSETV1Type = interface(IXMLNode)
    ['{85494D4B-2A86-4E64-9513-0D5009BB45B7}']
    { Property Accessors }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetDAYSWITH: UnicodeString;
    function GetDFLTDAYSTOPAY: UnicodeString;
    function GetXFERDAYSWITH: UnicodeString;
    function GetXFERDFLTDAYSTOPAY: UnicodeString;
    function GetPROCDAYSOFF: IXMLString_List;
    function GetPROCENDTM: UnicodeString;
    function GetMODELWND: UnicodeString;
    function GetPOSTPROCWND: UnicodeString;
    function GetSTSVIAMODS: UnicodeString;
    function GetPMTBYADDR: UnicodeString;
    function GetPMTBYXFER: UnicodeString;
    function GetPMTBYPAYEEID: UnicodeString;
    function GetCANADDPAYEE: UnicodeString;
    function GetHASEXTDPMT: UnicodeString;
    function GetCANMODPMTS: UnicodeString;
    function GetCANMODMDLS: UnicodeString;
    function GetDIFFFIRSTPMT: UnicodeString;
    function GetDIFFLASTPMT: UnicodeString;
    procedure SetDAYSWITH(Value: UnicodeString);
    procedure SetDFLTDAYSTOPAY(Value: UnicodeString);
    procedure SetXFERDAYSWITH(Value: UnicodeString);
    procedure SetXFERDFLTDAYSTOPAY(Value: UnicodeString);
    procedure SetPROCENDTM(Value: UnicodeString);
    procedure SetMODELWND(Value: UnicodeString);
    procedure SetPOSTPROCWND(Value: UnicodeString);
    procedure SetSTSVIAMODS(Value: UnicodeString);
    procedure SetPMTBYADDR(Value: UnicodeString);
    procedure SetPMTBYXFER(Value: UnicodeString);
    procedure SetPMTBYPAYEEID(Value: UnicodeString);
    procedure SetCANADDPAYEE(Value: UnicodeString);
    procedure SetHASEXTDPMT(Value: UnicodeString);
    procedure SetCANMODPMTS(Value: UnicodeString);
    procedure SetCANMODMDLS(Value: UnicodeString);
    procedure SetDIFFFIRSTPMT(Value: UnicodeString);
    procedure SetDIFFLASTPMT(Value: UnicodeString);
    { Methods & Properties }
    property MSGSETCORE: IXMLMSGSETCOREType read GetMSGSETCORE;
    property DAYSWITH: UnicodeString read GetDAYSWITH write SetDAYSWITH;
    property DFLTDAYSTOPAY: UnicodeString read GetDFLTDAYSTOPAY write SetDFLTDAYSTOPAY;
    property XFERDAYSWITH: UnicodeString read GetXFERDAYSWITH write SetXFERDAYSWITH;
    property XFERDFLTDAYSTOPAY: UnicodeString read GetXFERDFLTDAYSTOPAY write SetXFERDFLTDAYSTOPAY;
    property PROCDAYSOFF: IXMLString_List read GetPROCDAYSOFF;
    property PROCENDTM: UnicodeString read GetPROCENDTM write SetPROCENDTM;
    property MODELWND: UnicodeString read GetMODELWND write SetMODELWND;
    property POSTPROCWND: UnicodeString read GetPOSTPROCWND write SetPOSTPROCWND;
    property STSVIAMODS: UnicodeString read GetSTSVIAMODS write SetSTSVIAMODS;
    property PMTBYADDR: UnicodeString read GetPMTBYADDR write SetPMTBYADDR;
    property PMTBYXFER: UnicodeString read GetPMTBYXFER write SetPMTBYXFER;
    property PMTBYPAYEEID: UnicodeString read GetPMTBYPAYEEID write SetPMTBYPAYEEID;
    property CANADDPAYEE: UnicodeString read GetCANADDPAYEE write SetCANADDPAYEE;
    property HASEXTDPMT: UnicodeString read GetHASEXTDPMT write SetHASEXTDPMT;
    property CANMODPMTS: UnicodeString read GetCANMODPMTS write SetCANMODPMTS;
    property CANMODMDLS: UnicodeString read GetCANMODMDLS write SetCANMODMDLS;
    property DIFFFIRSTPMT: UnicodeString read GetDIFFFIRSTPMT write SetDIFFFIRSTPMT;
    property DIFFLASTPMT: UnicodeString read GetDIFFLASTPMT write SetDIFFLASTPMT;
  end;

{ IXMLBPACCTINFOType }

  IXMLBPACCTINFOType = interface(IXMLNode)
    ['{6545BFC1-F6A2-440D-BDCB-3184EF98AC0A}']
    { Property Accessors }
    function GetBANKACCTFROM: UnicodeString;
    function GetSVCSTATUS: UnicodeString;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetSVCSTATUS(Value: UnicodeString);
    { Methods & Properties }
    property BANKACCTFROM: UnicodeString read GetBANKACCTFROM write SetBANKACCTFROM;
    property SVCSTATUS: UnicodeString read GetSVCSTATUS write SetSVCSTATUS;
  end;

{ IXMLSIGNUPMSGSRQV1Type }

  IXMLSIGNUPMSGSRQV1Type = interface(IXMLNode)
    ['{891920C9-1E13-48DF-A6D0-8A1F6BC19FFA}']
    { Property Accessors }
    function GetENROLLTRNRQ: IXMLENROLLTRNRQTypeList;
    function GetACCTINFOTRNRQ: IXMLACCTINFOTRNRQTypeList;
    function GetCHGUSERINFOTRNRQ: IXMLCHGUSERINFOTRNRQTypeList;
    function GetCHGUSERINFOSYNCRQ: IXMLCHGUSERINFOSYNCRQTypeList;
    function GetACCTTRNRQ: IXMLACCTTRNRQTypeList;
    function GetACCTSYNCRQ: IXMLACCTSYNCRQTypeList;
    { Methods & Properties }
    property ENROLLTRNRQ: IXMLENROLLTRNRQTypeList read GetENROLLTRNRQ;
    property ACCTINFOTRNRQ: IXMLACCTINFOTRNRQTypeList read GetACCTINFOTRNRQ;
    property CHGUSERINFOTRNRQ: IXMLCHGUSERINFOTRNRQTypeList read GetCHGUSERINFOTRNRQ;
    property CHGUSERINFOSYNCRQ: IXMLCHGUSERINFOSYNCRQTypeList read GetCHGUSERINFOSYNCRQ;
    property ACCTTRNRQ: IXMLACCTTRNRQTypeList read GetACCTTRNRQ;
    property ACCTSYNCRQ: IXMLACCTSYNCRQTypeList read GetACCTSYNCRQ;
  end;

{ IXMLENROLLTRNRQType }

  IXMLENROLLTRNRQType = interface(IXMLNode)
    ['{58F93F99-FE1B-4F34-8790-86E9F88186FB}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetENROLLRQ: IXMLENROLLRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property ENROLLRQ: IXMLENROLLRQType read GetENROLLRQ;
  end;

{ IXMLENROLLTRNRQTypeList }

  IXMLENROLLTRNRQTypeList = interface(IXMLNodeCollection)
    ['{726DD488-002C-4E07-AB69-1FEBEE25C10C}']
    { Methods & Properties }
    function Add: IXMLENROLLTRNRQType;
    function Insert(const Index: Integer): IXMLENROLLTRNRQType;

    function GetItem(Index: Integer): IXMLENROLLTRNRQType;
    property Items[Index: Integer]: IXMLENROLLTRNRQType read GetItem; default;
  end;

{ IXMLENROLLRQType }

  IXMLENROLLRQType = interface(IXMLNode)
    ['{DAE29D36-8BB3-4039-8013-AB7CC3033813}']
    { Property Accessors }
    function GetFIRSTNAME: UnicodeString;
    function GetMIDDLENAME: UnicodeString;
    function GetLASTNAME: UnicodeString;
    function GetADDR1: UnicodeString;
    function GetADDR2: UnicodeString;
    function GetADDR3: UnicodeString;
    function GetCITY: UnicodeString;
    function GetSTATE: UnicodeString;
    function GetPOSTALCODE: UnicodeString;
    function GetCOUNTRY: UnicodeString;
    function GetDAYPHONE: UnicodeString;
    function GetEVEPHONE: UnicodeString;
    function GetEMAIL: UnicodeString;
    function GetUSERID: UnicodeString;
    function GetTAXID: UnicodeString;
    function GetSECURITYNAME: UnicodeString;
    function GetDATEBIRTH: UnicodeString;
    function GetACCTFROMMACRO: UnicodeString;
    procedure SetFIRSTNAME(Value: UnicodeString);
    procedure SetMIDDLENAME(Value: UnicodeString);
    procedure SetLASTNAME(Value: UnicodeString);
    procedure SetADDR1(Value: UnicodeString);
    procedure SetADDR2(Value: UnicodeString);
    procedure SetADDR3(Value: UnicodeString);
    procedure SetCITY(Value: UnicodeString);
    procedure SetSTATE(Value: UnicodeString);
    procedure SetPOSTALCODE(Value: UnicodeString);
    procedure SetCOUNTRY(Value: UnicodeString);
    procedure SetDAYPHONE(Value: UnicodeString);
    procedure SetEVEPHONE(Value: UnicodeString);
    procedure SetEMAIL(Value: UnicodeString);
    procedure SetUSERID(Value: UnicodeString);
    procedure SetTAXID(Value: UnicodeString);
    procedure SetSECURITYNAME(Value: UnicodeString);
    procedure SetDATEBIRTH(Value: UnicodeString);
    procedure SetACCTFROMMACRO(Value: UnicodeString);
    { Methods & Properties }
    property FIRSTNAME: UnicodeString read GetFIRSTNAME write SetFIRSTNAME;
    property MIDDLENAME: UnicodeString read GetMIDDLENAME write SetMIDDLENAME;
    property LASTNAME: UnicodeString read GetLASTNAME write SetLASTNAME;
    property ADDR1: UnicodeString read GetADDR1 write SetADDR1;
    property ADDR2: UnicodeString read GetADDR2 write SetADDR2;
    property ADDR3: UnicodeString read GetADDR3 write SetADDR3;
    property CITY: UnicodeString read GetCITY write SetCITY;
    property STATE: UnicodeString read GetSTATE write SetSTATE;
    property POSTALCODE: UnicodeString read GetPOSTALCODE write SetPOSTALCODE;
    property COUNTRY: UnicodeString read GetCOUNTRY write SetCOUNTRY;
    property DAYPHONE: UnicodeString read GetDAYPHONE write SetDAYPHONE;
    property EVEPHONE: UnicodeString read GetEVEPHONE write SetEVEPHONE;
    property EMAIL: UnicodeString read GetEMAIL write SetEMAIL;
    property USERID: UnicodeString read GetUSERID write SetUSERID;
    property TAXID: UnicodeString read GetTAXID write SetTAXID;
    property SECURITYNAME: UnicodeString read GetSECURITYNAME write SetSECURITYNAME;
    property DATEBIRTH: UnicodeString read GetDATEBIRTH write SetDATEBIRTH;
    property ACCTFROMMACRO: UnicodeString read GetACCTFROMMACRO write SetACCTFROMMACRO;
  end;

{ IXMLACCTINFOTRNRQType }

  IXMLACCTINFOTRNRQType = interface(IXMLNode)
    ['{3315ABBE-52F7-4E1E-A213-75C155E1F445}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetACCTINFORQ: IXMLACCTINFORQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property ACCTINFORQ: IXMLACCTINFORQType read GetACCTINFORQ;
  end;

{ IXMLACCTINFOTRNRQTypeList }

  IXMLACCTINFOTRNRQTypeList = interface(IXMLNodeCollection)
    ['{BBD34648-9CBA-4EA7-9BDF-EA6496BB314B}']
    { Methods & Properties }
    function Add: IXMLACCTINFOTRNRQType;
    function Insert(const Index: Integer): IXMLACCTINFOTRNRQType;

    function GetItem(Index: Integer): IXMLACCTINFOTRNRQType;
    property Items[Index: Integer]: IXMLACCTINFOTRNRQType read GetItem; default;
  end;

{ IXMLACCTINFORQType }

  IXMLACCTINFORQType = interface(IXMLNode)
    ['{7D7CC69B-1C49-40CF-8B55-E4DBDFA147E7}']
    { Property Accessors }
    function GetDTACCTUP: UnicodeString;
    procedure SetDTACCTUP(Value: UnicodeString);
    { Methods & Properties }
    property DTACCTUP: UnicodeString read GetDTACCTUP write SetDTACCTUP;
  end;

{ IXMLCHGUSERINFOTRNRQType }

  IXMLCHGUSERINFOTRNRQType = interface(IXMLNode)
    ['{D1FDBE7E-E86F-4C4C-9CA0-FD9119B5EDAC}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetCHGUSERINFORQ: IXMLCHGUSERINFORQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property CHGUSERINFORQ: IXMLCHGUSERINFORQType read GetCHGUSERINFORQ;
  end;

{ IXMLCHGUSERINFOTRNRQTypeList }

  IXMLCHGUSERINFOTRNRQTypeList = interface(IXMLNodeCollection)
    ['{DA6434B3-7F2F-4A24-A61A-F91FD10CF31A}']
    { Methods & Properties }
    function Add: IXMLCHGUSERINFOTRNRQType;
    function Insert(const Index: Integer): IXMLCHGUSERINFOTRNRQType;

    function GetItem(Index: Integer): IXMLCHGUSERINFOTRNRQType;
    property Items[Index: Integer]: IXMLCHGUSERINFOTRNRQType read GetItem; default;
  end;

{ IXMLCHGUSERINFORQType }

  IXMLCHGUSERINFORQType = interface(IXMLNode)
    ['{13DB67D4-4311-4D68-B080-86F8BF137DCC}']
    { Property Accessors }
    function GetFIRSTNAME: UnicodeString;
    function GetMIDDLENAME: UnicodeString;
    function GetLASTNAME: UnicodeString;
    function GetADDR1: UnicodeString;
    function GetADDR2: UnicodeString;
    function GetADDR3: UnicodeString;
    function GetCITY: UnicodeString;
    function GetSTATE: UnicodeString;
    function GetPOSTALCODE: UnicodeString;
    function GetCOUNTRY: UnicodeString;
    function GetDAYPHONE: UnicodeString;
    function GetEVEPHONE: UnicodeString;
    function GetEMAIL: UnicodeString;
    procedure SetFIRSTNAME(Value: UnicodeString);
    procedure SetMIDDLENAME(Value: UnicodeString);
    procedure SetLASTNAME(Value: UnicodeString);
    procedure SetADDR1(Value: UnicodeString);
    procedure SetADDR2(Value: UnicodeString);
    procedure SetADDR3(Value: UnicodeString);
    procedure SetCITY(Value: UnicodeString);
    procedure SetSTATE(Value: UnicodeString);
    procedure SetPOSTALCODE(Value: UnicodeString);
    procedure SetCOUNTRY(Value: UnicodeString);
    procedure SetDAYPHONE(Value: UnicodeString);
    procedure SetEVEPHONE(Value: UnicodeString);
    procedure SetEMAIL(Value: UnicodeString);
    { Methods & Properties }
    property FIRSTNAME: UnicodeString read GetFIRSTNAME write SetFIRSTNAME;
    property MIDDLENAME: UnicodeString read GetMIDDLENAME write SetMIDDLENAME;
    property LASTNAME: UnicodeString read GetLASTNAME write SetLASTNAME;
    property ADDR1: UnicodeString read GetADDR1 write SetADDR1;
    property ADDR2: UnicodeString read GetADDR2 write SetADDR2;
    property ADDR3: UnicodeString read GetADDR3 write SetADDR3;
    property CITY: UnicodeString read GetCITY write SetCITY;
    property STATE: UnicodeString read GetSTATE write SetSTATE;
    property POSTALCODE: UnicodeString read GetPOSTALCODE write SetPOSTALCODE;
    property COUNTRY: UnicodeString read GetCOUNTRY write SetCOUNTRY;
    property DAYPHONE: UnicodeString read GetDAYPHONE write SetDAYPHONE;
    property EVEPHONE: UnicodeString read GetEVEPHONE write SetEVEPHONE;
    property EMAIL: UnicodeString read GetEMAIL write SetEMAIL;
  end;

{ IXMLCHGUSERINFOSYNCRQType }

  IXMLCHGUSERINFOSYNCRQType = interface(IXMLNode)
    ['{7C8924CF-724C-420E-9E47-6C42DC7D1138}']
    { Property Accessors }
    function GetSYNCRQMACRO: UnicodeString;
    function GetCHGUSERINFOTRNRQ: IXMLCHGUSERINFOTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRQMACRO: UnicodeString read GetSYNCRQMACRO write SetSYNCRQMACRO;
    property CHGUSERINFOTRNRQ: IXMLCHGUSERINFOTRNRQTypeList read GetCHGUSERINFOTRNRQ;
  end;

{ IXMLCHGUSERINFOSYNCRQTypeList }

  IXMLCHGUSERINFOSYNCRQTypeList = interface(IXMLNodeCollection)
    ['{2D38B83E-40CF-4A10-885A-98CB4F9F59E4}']
    { Methods & Properties }
    function Add: IXMLCHGUSERINFOSYNCRQType;
    function Insert(const Index: Integer): IXMLCHGUSERINFOSYNCRQType;

    function GetItem(Index: Integer): IXMLCHGUSERINFOSYNCRQType;
    property Items[Index: Integer]: IXMLCHGUSERINFOSYNCRQType read GetItem; default;
  end;

{ IXMLACCTTRNRQType }

  IXMLACCTTRNRQType = interface(IXMLNode)
    ['{C1F3EE51-B257-4181-80B0-6183B03A5133}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetACCTRQ: IXMLACCTRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property ACCTRQ: IXMLACCTRQType read GetACCTRQ;
  end;

{ IXMLACCTTRNRQTypeList }

  IXMLACCTTRNRQTypeList = interface(IXMLNodeCollection)
    ['{B7C85331-BA67-4CDC-9471-F87BC571BCCD}']
    { Methods & Properties }
    function Add: IXMLACCTTRNRQType;
    function Insert(const Index: Integer): IXMLACCTTRNRQType;

    function GetItem(Index: Integer): IXMLACCTTRNRQType;
    property Items[Index: Integer]: IXMLACCTTRNRQType read GetItem; default;
  end;

{ IXMLACCTRQType }

  IXMLACCTRQType = interface(IXMLNode)
    ['{C4B57B7D-3B9C-4B7A-8DF2-432C9CEE19CF}']
    { Property Accessors }
    function GetSVCADD: IXMLSVCADDType;
    function GetSVCCHG: IXMLSVCCHGType;
    function GetSVCDEL: IXMLSVCDELType;
    function GetSVC: UnicodeString;
    procedure SetSVC(Value: UnicodeString);
    { Methods & Properties }
    property SVCADD: IXMLSVCADDType read GetSVCADD;
    property SVCCHG: IXMLSVCCHGType read GetSVCCHG;
    property SVCDEL: IXMLSVCDELType read GetSVCDEL;
    property SVC: UnicodeString read GetSVC write SetSVC;
  end;

{ IXMLSVCADDType }

  IXMLSVCADDType = interface(IXMLNode)
    ['{B1599047-0473-4C2A-800F-7390F42A6881}']
    { Property Accessors }
    function GetACCTTOMACRO: UnicodeString;
    procedure SetACCTTOMACRO(Value: UnicodeString);
    { Methods & Properties }
    property ACCTTOMACRO: UnicodeString read GetACCTTOMACRO write SetACCTTOMACRO;
  end;

{ IXMLSVCCHGType }

  IXMLSVCCHGType = interface(IXMLNode)
    ['{3EB12E99-C78A-4771-B8CE-7991EC8C20D2}']
    { Property Accessors }
    function GetACCTFROMMACRO: UnicodeString;
    function GetACCTTOMACRO: UnicodeString;
    procedure SetACCTFROMMACRO(Value: UnicodeString);
    procedure SetACCTTOMACRO(Value: UnicodeString);
    { Methods & Properties }
    property ACCTFROMMACRO: UnicodeString read GetACCTFROMMACRO write SetACCTFROMMACRO;
    property ACCTTOMACRO: UnicodeString read GetACCTTOMACRO write SetACCTTOMACRO;
  end;

{ IXMLSVCDELType }

  IXMLSVCDELType = interface(IXMLNode)
    ['{8DB48C68-AEF3-4628-A59A-D862F47164A7}']
    { Property Accessors }
    function GetACCTFROMMACRO: UnicodeString;
    procedure SetACCTFROMMACRO(Value: UnicodeString);
    { Methods & Properties }
    property ACCTFROMMACRO: UnicodeString read GetACCTFROMMACRO write SetACCTFROMMACRO;
  end;

{ IXMLACCTSYNCRQType }

  IXMLACCTSYNCRQType = interface(IXMLNode)
    ['{E7CDB14B-8AC7-456C-A12E-EE2D5F2B3CD3}']
    { Property Accessors }
    function GetSYNCRQMACRO: UnicodeString;
    function GetACCTTRNRQ: IXMLACCTTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRQMACRO: UnicodeString read GetSYNCRQMACRO write SetSYNCRQMACRO;
    property ACCTTRNRQ: IXMLACCTTRNRQTypeList read GetACCTTRNRQ;
  end;

{ IXMLACCTSYNCRQTypeList }

  IXMLACCTSYNCRQTypeList = interface(IXMLNodeCollection)
    ['{63305D3F-F7A3-4266-AFD9-763BC1D1C21F}']
    { Methods & Properties }
    function Add: IXMLACCTSYNCRQType;
    function Insert(const Index: Integer): IXMLACCTSYNCRQType;

    function GetItem(Index: Integer): IXMLACCTSYNCRQType;
    property Items[Index: Integer]: IXMLACCTSYNCRQType read GetItem; default;
  end;

{ IXMLSIGNUPMSGSRSV1Type }

  IXMLSIGNUPMSGSRSV1Type = interface(IXMLNode)
    ['{B0E4B67F-4C4F-4682-BAF4-983F6A2F47B2}']
    { Property Accessors }
    function GetENROLLTRNRS: IXMLENROLLTRNRSTypeList;
    function GetACCTINFOTRNRS: IXMLACCTINFOTRNRSTypeList;
    function GetCHGUSERINFOTRNRS: IXMLCHGUSERINFOTRNRSTypeList;
    function GetCHGUSERINFOSYNCRS: IXMLCHGUSERINFOSYNCRSTypeList;
    function GetACCTTRNRS: IXMLACCTTRNRSTypeList;
    function GetACCTSYNCRS: IXMLACCTSYNCRSTypeList;
    { Methods & Properties }
    property ENROLLTRNRS: IXMLENROLLTRNRSTypeList read GetENROLLTRNRS;
    property ACCTINFOTRNRS: IXMLACCTINFOTRNRSTypeList read GetACCTINFOTRNRS;
    property CHGUSERINFOTRNRS: IXMLCHGUSERINFOTRNRSTypeList read GetCHGUSERINFOTRNRS;
    property CHGUSERINFOSYNCRS: IXMLCHGUSERINFOSYNCRSTypeList read GetCHGUSERINFOSYNCRS;
    property ACCTTRNRS: IXMLACCTTRNRSTypeList read GetACCTTRNRS;
    property ACCTSYNCRS: IXMLACCTSYNCRSTypeList read GetACCTSYNCRS;
  end;

{ IXMLENROLLTRNRSType }

  IXMLENROLLTRNRSType = interface(IXMLNode)
    ['{C8481FE0-E1CB-4007-BA7E-14F8125B6DC8}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetENROLLRS: IXMLENROLLRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property ENROLLRS: IXMLENROLLRSType read GetENROLLRS;
  end;

{ IXMLENROLLTRNRSTypeList }

  IXMLENROLLTRNRSTypeList = interface(IXMLNodeCollection)
    ['{0B141933-29EF-4229-B1B2-60E35A178006}']
    { Methods & Properties }
    function Add: IXMLENROLLTRNRSType;
    function Insert(const Index: Integer): IXMLENROLLTRNRSType;

    function GetItem(Index: Integer): IXMLENROLLTRNRSType;
    property Items[Index: Integer]: IXMLENROLLTRNRSType read GetItem; default;
  end;

{ IXMLENROLLRSType }

  IXMLENROLLRSType = interface(IXMLNode)
    ['{A2C9D4EB-5253-4605-8FFC-5C86E9FBA1EC}']
    { Property Accessors }
    function GetTEMPPASS: UnicodeString;
    function GetUSERID: UnicodeString;
    function GetDTEXPIRE: UnicodeString;
    procedure SetTEMPPASS(Value: UnicodeString);
    procedure SetUSERID(Value: UnicodeString);
    procedure SetDTEXPIRE(Value: UnicodeString);
    { Methods & Properties }
    property TEMPPASS: UnicodeString read GetTEMPPASS write SetTEMPPASS;
    property USERID: UnicodeString read GetUSERID write SetUSERID;
    property DTEXPIRE: UnicodeString read GetDTEXPIRE write SetDTEXPIRE;
  end;

{ IXMLACCTINFOTRNRSType }

  IXMLACCTINFOTRNRSType = interface(IXMLNode)
    ['{DC071D46-7F01-4BAE-A9A4-8FB2F46DB662}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetACCTINFORS: IXMLACCTINFORSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property ACCTINFORS: IXMLACCTINFORSType read GetACCTINFORS;
  end;

{ IXMLACCTINFOTRNRSTypeList }

  IXMLACCTINFOTRNRSTypeList = interface(IXMLNodeCollection)
    ['{9415B174-C0F7-410D-9692-7E7841417407}']
    { Methods & Properties }
    function Add: IXMLACCTINFOTRNRSType;
    function Insert(const Index: Integer): IXMLACCTINFOTRNRSType;

    function GetItem(Index: Integer): IXMLACCTINFOTRNRSType;
    property Items[Index: Integer]: IXMLACCTINFOTRNRSType read GetItem; default;
  end;

{ IXMLACCTINFORSType }

  IXMLACCTINFORSType = interface(IXMLNode)
    ['{D01B0B13-C504-462A-AE6F-84E944519650}']
    { Property Accessors }
    function GetDTACCTUP: UnicodeString;
    function GetACCTINFO: IXMLACCTINFOTypeList;
    procedure SetDTACCTUP(Value: UnicodeString);
    { Methods & Properties }
    property DTACCTUP: UnicodeString read GetDTACCTUP write SetDTACCTUP;
    property ACCTINFO: IXMLACCTINFOTypeList read GetACCTINFO;
  end;

{ IXMLACCTINFOType }

  IXMLACCTINFOType = interface(IXMLNode)
    ['{973C3D92-EDF9-4158-B8EC-569C48570579}']
    { Property Accessors }
    function GetDESC: UnicodeString;
    function GetPHONE: UnicodeString;
    function GetACCTINFOMACRO: IXMLString_List;
    procedure SetDESC(Value: UnicodeString);
    procedure SetPHONE(Value: UnicodeString);
    { Methods & Properties }
    property DESC: UnicodeString read GetDESC write SetDESC;
    property PHONE: UnicodeString read GetPHONE write SetPHONE;
    property ACCTINFOMACRO: IXMLString_List read GetACCTINFOMACRO;
  end;

{ IXMLACCTINFOTypeList }

  IXMLACCTINFOTypeList = interface(IXMLNodeCollection)
    ['{9E3A0141-79E8-4C0A-91C0-3C6D5EA658AC}']
    { Methods & Properties }
    function Add: IXMLACCTINFOType;
    function Insert(const Index: Integer): IXMLACCTINFOType;

    function GetItem(Index: Integer): IXMLACCTINFOType;
    property Items[Index: Integer]: IXMLACCTINFOType read GetItem; default;
  end;

{ IXMLCHGUSERINFOTRNRSType }

  IXMLCHGUSERINFOTRNRSType = interface(IXMLNode)
    ['{31772370-BA56-45B1-9DD8-D5B0C0AB4487}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetCHGUSERINFORS: IXMLCHGUSERINFORSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property CHGUSERINFORS: IXMLCHGUSERINFORSType read GetCHGUSERINFORS;
  end;

{ IXMLCHGUSERINFOTRNRSTypeList }

  IXMLCHGUSERINFOTRNRSTypeList = interface(IXMLNodeCollection)
    ['{C60C8F8A-9EDB-4E85-85B8-8B7203E5A3BE}']
    { Methods & Properties }
    function Add: IXMLCHGUSERINFOTRNRSType;
    function Insert(const Index: Integer): IXMLCHGUSERINFOTRNRSType;

    function GetItem(Index: Integer): IXMLCHGUSERINFOTRNRSType;
    property Items[Index: Integer]: IXMLCHGUSERINFOTRNRSType read GetItem; default;
  end;

{ IXMLCHGUSERINFORSType }

  IXMLCHGUSERINFORSType = interface(IXMLNode)
    ['{1CE71D8E-AC8C-4538-9C86-F5DCFB185E9F}']
    { Property Accessors }
    function GetFIRSTNAME: UnicodeString;
    function GetMIDDLENAME: UnicodeString;
    function GetLASTNAME: UnicodeString;
    function GetADDR1: UnicodeString;
    function GetADDR2: UnicodeString;
    function GetADDR3: UnicodeString;
    function GetCITY: UnicodeString;
    function GetSTATE: UnicodeString;
    function GetPOSTALCODE: UnicodeString;
    function GetCOUNTRY: UnicodeString;
    function GetDAYPHONE: UnicodeString;
    function GetEVEPHONE: UnicodeString;
    function GetEMAIL: UnicodeString;
    function GetDTINFOCHG: UnicodeString;
    procedure SetFIRSTNAME(Value: UnicodeString);
    procedure SetMIDDLENAME(Value: UnicodeString);
    procedure SetLASTNAME(Value: UnicodeString);
    procedure SetADDR1(Value: UnicodeString);
    procedure SetADDR2(Value: UnicodeString);
    procedure SetADDR3(Value: UnicodeString);
    procedure SetCITY(Value: UnicodeString);
    procedure SetSTATE(Value: UnicodeString);
    procedure SetPOSTALCODE(Value: UnicodeString);
    procedure SetCOUNTRY(Value: UnicodeString);
    procedure SetDAYPHONE(Value: UnicodeString);
    procedure SetEVEPHONE(Value: UnicodeString);
    procedure SetEMAIL(Value: UnicodeString);
    procedure SetDTINFOCHG(Value: UnicodeString);
    { Methods & Properties }
    property FIRSTNAME: UnicodeString read GetFIRSTNAME write SetFIRSTNAME;
    property MIDDLENAME: UnicodeString read GetMIDDLENAME write SetMIDDLENAME;
    property LASTNAME: UnicodeString read GetLASTNAME write SetLASTNAME;
    property ADDR1: UnicodeString read GetADDR1 write SetADDR1;
    property ADDR2: UnicodeString read GetADDR2 write SetADDR2;
    property ADDR3: UnicodeString read GetADDR3 write SetADDR3;
    property CITY: UnicodeString read GetCITY write SetCITY;
    property STATE: UnicodeString read GetSTATE write SetSTATE;
    property POSTALCODE: UnicodeString read GetPOSTALCODE write SetPOSTALCODE;
    property COUNTRY: UnicodeString read GetCOUNTRY write SetCOUNTRY;
    property DAYPHONE: UnicodeString read GetDAYPHONE write SetDAYPHONE;
    property EVEPHONE: UnicodeString read GetEVEPHONE write SetEVEPHONE;
    property EMAIL: UnicodeString read GetEMAIL write SetEMAIL;
    property DTINFOCHG: UnicodeString read GetDTINFOCHG write SetDTINFOCHG;
  end;

{ IXMLCHGUSERINFOSYNCRSType }

  IXMLCHGUSERINFOSYNCRSType = interface(IXMLNode)
    ['{EBAA6207-A935-4DE1-B8A1-5DB0537D683F}']
    { Property Accessors }
    function GetSYNCRSMACRO: UnicodeString;
    function GetCHGUSERINFOTRNRS: IXMLCHGUSERINFOTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRSMACRO: UnicodeString read GetSYNCRSMACRO write SetSYNCRSMACRO;
    property CHGUSERINFOTRNRS: IXMLCHGUSERINFOTRNRSTypeList read GetCHGUSERINFOTRNRS;
  end;

{ IXMLCHGUSERINFOSYNCRSTypeList }

  IXMLCHGUSERINFOSYNCRSTypeList = interface(IXMLNodeCollection)
    ['{D06B7695-C8AC-4734-993E-8755A5160077}']
    { Methods & Properties }
    function Add: IXMLCHGUSERINFOSYNCRSType;
    function Insert(const Index: Integer): IXMLCHGUSERINFOSYNCRSType;

    function GetItem(Index: Integer): IXMLCHGUSERINFOSYNCRSType;
    property Items[Index: Integer]: IXMLCHGUSERINFOSYNCRSType read GetItem; default;
  end;

{ IXMLACCTTRNRSType }

  IXMLACCTTRNRSType = interface(IXMLNode)
    ['{E3C71EAA-2C8D-4F99-8CEF-87F488000899}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetACCTRS: IXMLACCTRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property ACCTRS: IXMLACCTRSType read GetACCTRS;
  end;

{ IXMLACCTTRNRSTypeList }

  IXMLACCTTRNRSTypeList = interface(IXMLNodeCollection)
    ['{12469EBA-42F2-40F7-B244-F2522E8B5EE1}']
    { Methods & Properties }
    function Add: IXMLACCTTRNRSType;
    function Insert(const Index: Integer): IXMLACCTTRNRSType;

    function GetItem(Index: Integer): IXMLACCTTRNRSType;
    property Items[Index: Integer]: IXMLACCTTRNRSType read GetItem; default;
  end;

{ IXMLACCTRSType }

  IXMLACCTRSType = interface(IXMLNode)
    ['{D08E723E-0D11-4C9F-B38B-EE5070490DDE}']
    { Property Accessors }
    function GetSVCADD: IXMLSVCADDType;
    function GetSVCCHG: IXMLSVCCHGType;
    function GetSVCDEL: IXMLSVCDELType;
    function GetSVC: UnicodeString;
    function GetSVCSTATUS: UnicodeString;
    procedure SetSVC(Value: UnicodeString);
    procedure SetSVCSTATUS(Value: UnicodeString);
    { Methods & Properties }
    property SVCADD: IXMLSVCADDType read GetSVCADD;
    property SVCCHG: IXMLSVCCHGType read GetSVCCHG;
    property SVCDEL: IXMLSVCDELType read GetSVCDEL;
    property SVC: UnicodeString read GetSVC write SetSVC;
    property SVCSTATUS: UnicodeString read GetSVCSTATUS write SetSVCSTATUS;
  end;

{ IXMLACCTSYNCRSType }

  IXMLACCTSYNCRSType = interface(IXMLNode)
    ['{726BABB7-D73A-4BF2-8840-486BF681E65B}']
    { Property Accessors }
    function GetSYNCRSMACRO: UnicodeString;
    function GetACCTTRNRS: IXMLACCTTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRSMACRO: UnicodeString read GetSYNCRSMACRO write SetSYNCRSMACRO;
    property ACCTTRNRS: IXMLACCTTRNRSTypeList read GetACCTTRNRS;
  end;

{ IXMLACCTSYNCRSTypeList }

  IXMLACCTSYNCRSTypeList = interface(IXMLNodeCollection)
    ['{B19E563E-2E5D-4293-A5BB-8266E136D883}']
    { Methods & Properties }
    function Add: IXMLACCTSYNCRSType;
    function Insert(const Index: Integer): IXMLACCTSYNCRSType;

    function GetItem(Index: Integer): IXMLACCTSYNCRSType;
    property Items[Index: Integer]: IXMLACCTSYNCRSType read GetItem; default;
  end;

{ IXMLSIGNUPMSGSETType }

  IXMLSIGNUPMSGSETType = interface(IXMLNode)
    ['{1AE2177D-1D9F-4A6C-94C0-20FD514AE41C}']
    { Property Accessors }
    function GetSIGNUPMSGSETV1: IXMLSIGNUPMSGSETV1Type;
    { Methods & Properties }
    property SIGNUPMSGSETV1: IXMLSIGNUPMSGSETV1Type read GetSIGNUPMSGSETV1;
  end;

{ IXMLSIGNUPMSGSETV1Type }

  IXMLSIGNUPMSGSETV1Type = interface(IXMLNode)
    ['{30DE3F60-5EE0-4516-89DD-BEB15045C9E7}']
    { Property Accessors }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetCLIENTENROLL: IXMLCLIENTENROLLType;
    function GetWEBENROLL: IXMLWEBENROLLType;
    function GetOTHERENROLL: IXMLOTHERENROLLType;
    function GetCHGUSERINFO: UnicodeString;
    function GetAVAILACCTS: UnicodeString;
    function GetCLIENTACTREQ: UnicodeString;
    procedure SetCHGUSERINFO(Value: UnicodeString);
    procedure SetAVAILACCTS(Value: UnicodeString);
    procedure SetCLIENTACTREQ(Value: UnicodeString);
    { Methods & Properties }
    property MSGSETCORE: IXMLMSGSETCOREType read GetMSGSETCORE;
    property CLIENTENROLL: IXMLCLIENTENROLLType read GetCLIENTENROLL;
    property WEBENROLL: IXMLWEBENROLLType read GetWEBENROLL;
    property OTHERENROLL: IXMLOTHERENROLLType read GetOTHERENROLL;
    property CHGUSERINFO: UnicodeString read GetCHGUSERINFO write SetCHGUSERINFO;
    property AVAILACCTS: UnicodeString read GetAVAILACCTS write SetAVAILACCTS;
    property CLIENTACTREQ: UnicodeString read GetCLIENTACTREQ write SetCLIENTACTREQ;
  end;

{ IXMLCLIENTENROLLType }

  IXMLCLIENTENROLLType = interface(IXMLNode)
    ['{7B64D9C5-5E89-4B5F-8746-35F2ECBCFA39}']
    { Property Accessors }
    function GetACCTREQUIRED: UnicodeString;
    procedure SetACCTREQUIRED(Value: UnicodeString);
    { Methods & Properties }
    property ACCTREQUIRED: UnicodeString read GetACCTREQUIRED write SetACCTREQUIRED;
  end;

{ IXMLWEBENROLLType }

  IXMLWEBENROLLType = interface(IXMLNode)
    ['{85A274E9-4097-49B5-BAC2-1D1F16527BFB}']
    { Property Accessors }
    function GetURL: UnicodeString;
    procedure SetURL(Value: UnicodeString);
    { Methods & Properties }
    property URL: UnicodeString read GetURL write SetURL;
  end;

{ IXMLOTHERENROLLType }

  IXMLOTHERENROLLType = interface(IXMLNode)
    ['{113B2AA5-E3E1-4B59-9E6B-185A7842813E}']
    { Property Accessors }
    function GetMESSAGE: UnicodeString;
    procedure SetMESSAGE(Value: UnicodeString);
    { Methods & Properties }
    property MESSAGE: UnicodeString read GetMESSAGE write SetMESSAGE;
  end;

{ IXMLINVSTMTMSGSRQV1Type }

  IXMLINVSTMTMSGSRQV1Type = interface(IXMLNode)
    ['{4083CFC5-231F-4134-93B0-D72629E30AAB}']
    { Property Accessors }
    function GetINVSTMTTRNRQ: IXMLINVSTMTTRNRQType;
    function GetINVMAILTRNRQ: IXMLINVMAILTRNRQTypeList;
    function GetINVMAILSYNCRQ: IXMLINVMAILSYNCRQTypeList;
    { Methods & Properties }
    property INVSTMTTRNRQ: IXMLINVSTMTTRNRQType read GetINVSTMTTRNRQ;
    property INVMAILTRNRQ: IXMLINVMAILTRNRQTypeList read GetINVMAILTRNRQ;
    property INVMAILSYNCRQ: IXMLINVMAILSYNCRQTypeList read GetINVMAILSYNCRQ;
  end;

{ IXMLINVSTMTTRNRQType }

  IXMLINVSTMTTRNRQType = interface(IXMLNode)
    ['{2E32A1F4-781E-4C81-B4DE-329BFB4FBC81}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetINVSTMTRQ: IXMLINVSTMTRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property INVSTMTRQ: IXMLINVSTMTRQType read GetINVSTMTRQ;
  end;

{ IXMLINVSTMTRQType }

  IXMLINVSTMTRQType = interface(IXMLNode)
    ['{23EA44AD-D9C8-46B7-985D-D716EEC0B6F5}']
    { Property Accessors }
    function GetINVACCTFROM: IXMLINVACCTFROMType;
    function GetINCTRAN: IXMLINCTRANType;
    function GetINCOO: UnicodeString;
    function GetINCPOS: IXMLINCPOSType;
    function GetINCBAL: UnicodeString;
    procedure SetINCOO(Value: UnicodeString);
    procedure SetINCBAL(Value: UnicodeString);
    { Methods & Properties }
    property INVACCTFROM: IXMLINVACCTFROMType read GetINVACCTFROM;
    property INCTRAN: IXMLINCTRANType read GetINCTRAN;
    property INCOO: UnicodeString read GetINCOO write SetINCOO;
    property INCPOS: IXMLINCPOSType read GetINCPOS;
    property INCBAL: UnicodeString read GetINCBAL write SetINCBAL;
  end;

{ IXMLINVACCTFROMType }

  IXMLINVACCTFROMType = interface(IXMLNode)
    ['{16811926-5D2B-4ACE-A909-EFCD0D420938}']
    { Property Accessors }
    function GetBROKERID: UnicodeString;
    function GetACCTID: UnicodeString;
    procedure SetBROKERID(Value: UnicodeString);
    procedure SetACCTID(Value: UnicodeString);
    { Methods & Properties }
    property BROKERID: UnicodeString read GetBROKERID write SetBROKERID;
    property ACCTID: UnicodeString read GetACCTID write SetACCTID;
  end;

{ IXMLINCPOSType }

  IXMLINCPOSType = interface(IXMLNode)
    ['{3C34977A-1B3A-4A78-A321-F5046C839453}']
    { Property Accessors }
    function GetDTASOF: UnicodeString;
    function GetINCLUDE: UnicodeString;
    procedure SetDTASOF(Value: UnicodeString);
    procedure SetINCLUDE(Value: UnicodeString);
    { Methods & Properties }
    property DTASOF: UnicodeString read GetDTASOF write SetDTASOF;
    property INCLUDE: UnicodeString read GetINCLUDE write SetINCLUDE;
  end;

{ IXMLINVMAILTRNRQType }

  IXMLINVMAILTRNRQType = interface(IXMLNode)
    ['{142FFE8B-95BE-4C8F-85F7-AFEAAB98B55C}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetINVMAILRQ: IXMLINVMAILRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property INVMAILRQ: IXMLINVMAILRQType read GetINVMAILRQ;
  end;

{ IXMLINVMAILTRNRQTypeList }

  IXMLINVMAILTRNRQTypeList = interface(IXMLNodeCollection)
    ['{6F992DC2-D3E6-4F97-A197-142F8FFCE769}']
    { Methods & Properties }
    function Add: IXMLINVMAILTRNRQType;
    function Insert(const Index: Integer): IXMLINVMAILTRNRQType;

    function GetItem(Index: Integer): IXMLINVMAILTRNRQType;
    property Items[Index: Integer]: IXMLINVMAILTRNRQType read GetItem; default;
  end;

{ IXMLINVMAILRQType }

  IXMLINVMAILRQType = interface(IXMLNode)
    ['{9256E4AB-3137-42B1-B364-610E3786E8EF}']
    { Property Accessors }
    function GetINVACCTFROM: IXMLINVACCTFROMType;
    function GetMAIL: IXMLMAILType;
    { Methods & Properties }
    property INVACCTFROM: IXMLINVACCTFROMType read GetINVACCTFROM;
    property MAIL: IXMLMAILType read GetMAIL;
  end;

{ IXMLINVMAILSYNCRQType }

  IXMLINVMAILSYNCRQType = interface(IXMLNode)
    ['{96A9121D-DDBB-4944-8F32-3AA0A1DF1764}']
    { Property Accessors }
    function GetSYNCRQMACRO: UnicodeString;
    function GetINCIMAGES: UnicodeString;
    function GetUSEHTML: UnicodeString;
    function GetINVACCTFROM: IXMLINVACCTFROMType;
    function GetINVMAILTRNRQ: IXMLINVMAILTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetINCIMAGES(Value: UnicodeString);
    procedure SetUSEHTML(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRQMACRO: UnicodeString read GetSYNCRQMACRO write SetSYNCRQMACRO;
    property INCIMAGES: UnicodeString read GetINCIMAGES write SetINCIMAGES;
    property USEHTML: UnicodeString read GetUSEHTML write SetUSEHTML;
    property INVACCTFROM: IXMLINVACCTFROMType read GetINVACCTFROM;
    property INVMAILTRNRQ: IXMLINVMAILTRNRQTypeList read GetINVMAILTRNRQ;
  end;

{ IXMLINVMAILSYNCRQTypeList }

  IXMLINVMAILSYNCRQTypeList = interface(IXMLNodeCollection)
    ['{2C724C65-02BA-4641-938A-D679A8F8A2A8}']
    { Methods & Properties }
    function Add: IXMLINVMAILSYNCRQType;
    function Insert(const Index: Integer): IXMLINVMAILSYNCRQType;

    function GetItem(Index: Integer): IXMLINVMAILSYNCRQType;
    property Items[Index: Integer]: IXMLINVMAILSYNCRQType read GetItem; default;
  end;

{ IXMLINVSTMTMSGSRSV1Type }

  IXMLINVSTMTMSGSRSV1Type = interface(IXMLNode)
    ['{2384A844-38F6-4BA0-86D1-728BFBD9F41F}']
    { Property Accessors }
    function GetINVSTMTTRNRS: IXMLINVSTMTTRNRSTypeList;
    function GetINVMAILTRNRS: IXMLINVMAILTRNRSTypeList;
    function GetINVMAILSYNCRS: IXMLINVMAILSYNCRSTypeList;
    { Methods & Properties }
    property INVSTMTTRNRS: IXMLINVSTMTTRNRSTypeList read GetINVSTMTTRNRS;
    property INVMAILTRNRS: IXMLINVMAILTRNRSTypeList read GetINVMAILTRNRS;
    property INVMAILSYNCRS: IXMLINVMAILSYNCRSTypeList read GetINVMAILSYNCRS;
  end;

{ IXMLINVSTMTTRNRSType }

  IXMLINVSTMTTRNRSType = interface(IXMLNode)
    ['{C53F1015-ACC1-45F3-B990-FD352EA3D1E7}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetINVSTMTRS: IXMLINVSTMTRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property INVSTMTRS: IXMLINVSTMTRSType read GetINVSTMTRS;
  end;

{ IXMLINVSTMTTRNRSTypeList }

  IXMLINVSTMTTRNRSTypeList = interface(IXMLNodeCollection)
    ['{E99D7D82-D787-4670-B48F-41B868A130AC}']
    { Methods & Properties }
    function Add: IXMLINVSTMTTRNRSType;
    function Insert(const Index: Integer): IXMLINVSTMTTRNRSType;

    function GetItem(Index: Integer): IXMLINVSTMTTRNRSType;
    property Items[Index: Integer]: IXMLINVSTMTTRNRSType read GetItem; default;
  end;

{ IXMLINVSTMTRSType }

  IXMLINVSTMTRSType = interface(IXMLNode)
    ['{38B67735-F506-4BF0-AFC2-AD3A1F09A2F2}']
    { Property Accessors }
    function GetDTASOF: UnicodeString;
    function GetCURDEF: UnicodeString;
    function GetINVACCTFROM: IXMLINVACCTFROMType;
    function GetINVTRANLIST: IXMLINVTRANLISTType;
    function GetINVPOSLIST: IXMLINVPOSLISTType;
    function GetINVBAL: IXMLINVBALType;
    function GetINVOOLIST: IXMLINVOOLISTType;
    function GetMKTGINFO: UnicodeString;
    procedure SetDTASOF(Value: UnicodeString);
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetMKTGINFO(Value: UnicodeString);
    { Methods & Properties }
    property DTASOF: UnicodeString read GetDTASOF write SetDTASOF;
    property CURDEF: UnicodeString read GetCURDEF write SetCURDEF;
    property INVACCTFROM: IXMLINVACCTFROMType read GetINVACCTFROM;
    property INVTRANLIST: IXMLINVTRANLISTType read GetINVTRANLIST;
    property INVPOSLIST: IXMLINVPOSLISTType read GetINVPOSLIST;
    property INVBAL: IXMLINVBALType read GetINVBAL;
    property INVOOLIST: IXMLINVOOLISTType read GetINVOOLIST;
    property MKTGINFO: UnicodeString read GetMKTGINFO write SetMKTGINFO;
  end;

{ IXMLINVTRANLISTType }

  IXMLINVTRANLISTType = interface(IXMLNode)
    ['{FB5A191E-377C-4AA6-A180-E2C70400103D}']
    { Property Accessors }
    function GetDTSTART: UnicodeString;
    function GetDTEND: UnicodeString;
    function GetBUYDEBT: IXMLBUYDEBTTypeList;
    function GetBUYMF: IXMLBUYMFTypeList;
    function GetBUYOPT: IXMLBUYOPTTypeList;
    function GetBUYOTHER: IXMLBUYOTHERTypeList;
    function GetBUYSTOCK: IXMLBUYSTOCKTypeList;
    function GetCLOSUREOPT: IXMLCLOSUREOPTTypeList;
    function GetINCOME: IXMLINCOMETypeList;
    function GetINVEXPENSE: IXMLINVEXPENSETypeList;
    function GetJRNLFUND: IXMLJRNLFUNDTypeList;
    function GetJRNLSEC: IXMLJRNLSECTypeList;
    function GetMARGININTEREST: IXMLMARGININTERESTTypeList;
    function GetREINVEST: IXMLREINVESTTypeList;
    function GetRETOFCAP: IXMLRETOFCAPTypeList;
    function GetSELLDEBT: IXMLSELLDEBTTypeList;
    function GetSELLMF: IXMLSELLMFTypeList;
    function GetSELLOPT: IXMLSELLOPTTypeList;
    function GetSELLOTHER: IXMLSELLOTHERTypeList;
    function GetSELLSTOCK: IXMLSELLSTOCKTypeList;
    function GetSPLIT: IXMLSPLITTypeList;
    function GetTRANSFER: IXMLTRANSFERTypeList;
    function GetINVBANKTRAN: IXMLINVBANKTRANTypeList;
    procedure SetDTSTART(Value: UnicodeString);
    procedure SetDTEND(Value: UnicodeString);
    { Methods & Properties }
    property DTSTART: UnicodeString read GetDTSTART write SetDTSTART;
    property DTEND: UnicodeString read GetDTEND write SetDTEND;
    property BUYDEBT: IXMLBUYDEBTTypeList read GetBUYDEBT;
    property BUYMF: IXMLBUYMFTypeList read GetBUYMF;
    property BUYOPT: IXMLBUYOPTTypeList read GetBUYOPT;
    property BUYOTHER: IXMLBUYOTHERTypeList read GetBUYOTHER;
    property BUYSTOCK: IXMLBUYSTOCKTypeList read GetBUYSTOCK;
    property CLOSUREOPT: IXMLCLOSUREOPTTypeList read GetCLOSUREOPT;
    property INCOME: IXMLINCOMETypeList read GetINCOME;
    property INVEXPENSE: IXMLINVEXPENSETypeList read GetINVEXPENSE;
    property JRNLFUND: IXMLJRNLFUNDTypeList read GetJRNLFUND;
    property JRNLSEC: IXMLJRNLSECTypeList read GetJRNLSEC;
    property MARGININTEREST: IXMLMARGININTERESTTypeList read GetMARGININTEREST;
    property REINVEST: IXMLREINVESTTypeList read GetREINVEST;
    property RETOFCAP: IXMLRETOFCAPTypeList read GetRETOFCAP;
    property SELLDEBT: IXMLSELLDEBTTypeList read GetSELLDEBT;
    property SELLMF: IXMLSELLMFTypeList read GetSELLMF;
    property SELLOPT: IXMLSELLOPTTypeList read GetSELLOPT;
    property SELLOTHER: IXMLSELLOTHERTypeList read GetSELLOTHER;
    property SELLSTOCK: IXMLSELLSTOCKTypeList read GetSELLSTOCK;
    property SPLIT: IXMLSPLITTypeList read GetSPLIT;
    property TRANSFER: IXMLTRANSFERTypeList read GetTRANSFER;
    property INVBANKTRAN: IXMLINVBANKTRANTypeList read GetINVBANKTRAN;
  end;

{ IXMLBUYDEBTType }

  IXMLBUYDEBTType = interface(IXMLNode)
    ['{1964F167-E0FF-4508-BD00-11748EDBF149}']
    { Property Accessors }
    function GetINVBUY: IXMLINVBUYType;
    function GetACCRDINT: UnicodeString;
    procedure SetACCRDINT(Value: UnicodeString);
    { Methods & Properties }
    property INVBUY: IXMLINVBUYType read GetINVBUY;
    property ACCRDINT: UnicodeString read GetACCRDINT write SetACCRDINT;
  end;

{ IXMLBUYDEBTTypeList }

  IXMLBUYDEBTTypeList = interface(IXMLNodeCollection)
    ['{EA0DD009-3089-40F8-9281-DDBA7FE2A3AC}']
    { Methods & Properties }
    function Add: IXMLBUYDEBTType;
    function Insert(const Index: Integer): IXMLBUYDEBTType;

    function GetItem(Index: Integer): IXMLBUYDEBTType;
    property Items[Index: Integer]: IXMLBUYDEBTType read GetItem; default;
  end;

{ IXMLINVBUYType }

  IXMLINVBUYType = interface(IXMLNode)
    ['{965C0FFF-20E6-4764-8461-4B85FFB176B5}']
    { Property Accessors }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetUNITS: UnicodeString;
    function GetUNITPRICE: UnicodeString;
    function GetMARKUP: UnicodeString;
    function GetCOMMISSION: UnicodeString;
    function GetTAXES: UnicodeString;
    function GetFEES: UnicodeString;
    function GetLOAD: UnicodeString;
    function GetTOTAL: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    function GetSUBACCTSEC: UnicodeString;
    function GetSUBACCTFUND: IXMLSUBACCTFUNDType;
    procedure SetUNITS(Value: UnicodeString);
    procedure SetUNITPRICE(Value: UnicodeString);
    procedure SetMARKUP(Value: UnicodeString);
    procedure SetCOMMISSION(Value: UnicodeString);
    procedure SetTAXES(Value: UnicodeString);
    procedure SetFEES(Value: UnicodeString);
    procedure SetLOAD(Value: UnicodeString);
    procedure SetTOTAL(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
    procedure SetSUBACCTSEC(Value: UnicodeString);
    { Methods & Properties }
    property INVTRAN: IXMLINVTRANType read GetINVTRAN;
    property SECID: IXMLSECIDType read GetSECID;
    property UNITS: UnicodeString read GetUNITS write SetUNITS;
    property UNITPRICE: UnicodeString read GetUNITPRICE write SetUNITPRICE;
    property MARKUP: UnicodeString read GetMARKUP write SetMARKUP;
    property COMMISSION: UnicodeString read GetCOMMISSION write SetCOMMISSION;
    property TAXES: UnicodeString read GetTAXES write SetTAXES;
    property FEES: UnicodeString read GetFEES write SetFEES;
    property LOAD: UnicodeString read GetLOAD write SetLOAD;
    property TOTAL: UnicodeString read GetTOTAL write SetTOTAL;
    property CURRENCY: UnicodeString read GetCURRENCY write SetCURRENCY;
    property ORIGCURRENCY: UnicodeString read GetORIGCURRENCY write SetORIGCURRENCY;
    property SUBACCTSEC: UnicodeString read GetSUBACCTSEC write SetSUBACCTSEC;
    property SUBACCTFUND: IXMLSUBACCTFUNDType read GetSUBACCTFUND;
  end;

{ IXMLINVTRANType }

  IXMLINVTRANType = interface(IXMLNode)
    ['{31EF51A6-FF08-400E-ABC6-F68D3C9958D8}']
    { Property Accessors }
    function GetFITID: UnicodeString;
    function GetSRVRTID: UnicodeString;
    function GetDTTRADE: UnicodeString;
    function GetDTSETTLE: UnicodeString;
    function GetMEMO: UnicodeString;
    procedure SetFITID(Value: UnicodeString);
    procedure SetSRVRTID(Value: UnicodeString);
    procedure SetDTTRADE(Value: UnicodeString);
    procedure SetDTSETTLE(Value: UnicodeString);
    procedure SetMEMO(Value: UnicodeString);
    { Methods & Properties }
    property FITID: UnicodeString read GetFITID write SetFITID;
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
    property DTTRADE: UnicodeString read GetDTTRADE write SetDTTRADE;
    property DTSETTLE: UnicodeString read GetDTSETTLE write SetDTSETTLE;
    property MEMO: UnicodeString read GetMEMO write SetMEMO;
  end;

{ IXMLSECIDType }

  IXMLSECIDType = interface(IXMLNode)
    ['{3B79724A-2D72-4590-94F6-4C0FE873F816}']
    { Property Accessors }
    function GetUNIQUEID: UnicodeString;
    function GetUNIQUEIDTYPE: UnicodeString;
    procedure SetUNIQUEID(Value: UnicodeString);
    procedure SetUNIQUEIDTYPE(Value: UnicodeString);
    { Methods & Properties }
    property UNIQUEID: UnicodeString read GetUNIQUEID write SetUNIQUEID;
    property UNIQUEIDTYPE: UnicodeString read GetUNIQUEIDTYPE write SetUNIQUEIDTYPE;
  end;

{ IXMLSUBACCTFUNDType }

  IXMLSUBACCTFUNDType = interface(IXMLNode)
    ['{84C59986-E74B-4F9F-ABFE-492EA2F9F43E}']
    { Property Accessors }
    function GetSTRTYPE: UnicodeString;
    procedure SetSTRTYPE(Value: UnicodeString);
    { Methods & Properties }
    property STRTYPE: UnicodeString read GetSTRTYPE write SetSTRTYPE;
  end;

{ IXMLBUYMFType }

  IXMLBUYMFType = interface(IXMLNode)
    ['{F92B813D-F52C-4300-AA06-16F6C1847B67}']
    { Property Accessors }
    function GetINVBUY: IXMLINVBUYType;
    function GetBUYTYPE: UnicodeString;
    function GetRELFITID: UnicodeString;
    procedure SetBUYTYPE(Value: UnicodeString);
    procedure SetRELFITID(Value: UnicodeString);
    { Methods & Properties }
    property INVBUY: IXMLINVBUYType read GetINVBUY;
    property BUYTYPE: UnicodeString read GetBUYTYPE write SetBUYTYPE;
    property RELFITID: UnicodeString read GetRELFITID write SetRELFITID;
  end;

{ IXMLBUYMFTypeList }

  IXMLBUYMFTypeList = interface(IXMLNodeCollection)
    ['{2E813A92-D1B4-4018-8FB2-44E1C8DDB34E}']
    { Methods & Properties }
    function Add: IXMLBUYMFType;
    function Insert(const Index: Integer): IXMLBUYMFType;

    function GetItem(Index: Integer): IXMLBUYMFType;
    property Items[Index: Integer]: IXMLBUYMFType read GetItem; default;
  end;

{ IXMLBUYOPTType }

  IXMLBUYOPTType = interface(IXMLNode)
    ['{F64BC80F-9A15-433D-ADD8-2CAD1136A03C}']
    { Property Accessors }
    function GetINVBUY: IXMLINVBUYType;
    function GetOPTBUYTYPE: UnicodeString;
    function GetSHPERCTRCT: UnicodeString;
    procedure SetOPTBUYTYPE(Value: UnicodeString);
    procedure SetSHPERCTRCT(Value: UnicodeString);
    { Methods & Properties }
    property INVBUY: IXMLINVBUYType read GetINVBUY;
    property OPTBUYTYPE: UnicodeString read GetOPTBUYTYPE write SetOPTBUYTYPE;
    property SHPERCTRCT: UnicodeString read GetSHPERCTRCT write SetSHPERCTRCT;
  end;

{ IXMLBUYOPTTypeList }

  IXMLBUYOPTTypeList = interface(IXMLNodeCollection)
    ['{695BDB90-5CBA-4E99-83B1-A944606E4C01}']
    { Methods & Properties }
    function Add: IXMLBUYOPTType;
    function Insert(const Index: Integer): IXMLBUYOPTType;

    function GetItem(Index: Integer): IXMLBUYOPTType;
    property Items[Index: Integer]: IXMLBUYOPTType read GetItem; default;
  end;

{ IXMLBUYOTHERType }

  IXMLBUYOTHERType = interface(IXMLNode)
    ['{9AF91C20-6C89-432F-985A-B3E88D4C7C61}']
    { Property Accessors }
    function GetINVBUY: IXMLINVBUYType;
    { Methods & Properties }
    property INVBUY: IXMLINVBUYType read GetINVBUY;
  end;

{ IXMLBUYOTHERTypeList }

  IXMLBUYOTHERTypeList = interface(IXMLNodeCollection)
    ['{45D409F4-C86C-4F2C-922A-C194B4AF851A}']
    { Methods & Properties }
    function Add: IXMLBUYOTHERType;
    function Insert(const Index: Integer): IXMLBUYOTHERType;

    function GetItem(Index: Integer): IXMLBUYOTHERType;
    property Items[Index: Integer]: IXMLBUYOTHERType read GetItem; default;
  end;

{ IXMLBUYSTOCKType }

  IXMLBUYSTOCKType = interface(IXMLNode)
    ['{DA7D9D78-B9FD-4AB6-B1D7-C3DBF3308C20}']
    { Property Accessors }
    function GetINVBUY: IXMLINVBUYType;
    function GetBUYTYPE: UnicodeString;
    procedure SetBUYTYPE(Value: UnicodeString);
    { Methods & Properties }
    property INVBUY: IXMLINVBUYType read GetINVBUY;
    property BUYTYPE: UnicodeString read GetBUYTYPE write SetBUYTYPE;
  end;

{ IXMLBUYSTOCKTypeList }

  IXMLBUYSTOCKTypeList = interface(IXMLNodeCollection)
    ['{3FC0D51C-BC32-4EFC-8724-5E5F43D36176}']
    { Methods & Properties }
    function Add: IXMLBUYSTOCKType;
    function Insert(const Index: Integer): IXMLBUYSTOCKType;

    function GetItem(Index: Integer): IXMLBUYSTOCKType;
    property Items[Index: Integer]: IXMLBUYSTOCKType read GetItem; default;
  end;

{ IXMLCLOSUREOPTType }

  IXMLCLOSUREOPTType = interface(IXMLNode)
    ['{2F1716E7-6ADE-421C-8356-3579107929B3}']
    { Property Accessors }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetOPTACTION: UnicodeString;
    function GetUNITS: UnicodeString;
    function GetSHPERCTRCT: UnicodeString;
    function GetSUBACCTSEC: UnicodeString;
    function GetRELFITID: UnicodeString;
    function GetGAIN: UnicodeString;
    procedure SetOPTACTION(Value: UnicodeString);
    procedure SetUNITS(Value: UnicodeString);
    procedure SetSHPERCTRCT(Value: UnicodeString);
    procedure SetSUBACCTSEC(Value: UnicodeString);
    procedure SetRELFITID(Value: UnicodeString);
    procedure SetGAIN(Value: UnicodeString);
    { Methods & Properties }
    property INVTRAN: IXMLINVTRANType read GetINVTRAN;
    property SECID: IXMLSECIDType read GetSECID;
    property OPTACTION: UnicodeString read GetOPTACTION write SetOPTACTION;
    property UNITS: UnicodeString read GetUNITS write SetUNITS;
    property SHPERCTRCT: UnicodeString read GetSHPERCTRCT write SetSHPERCTRCT;
    property SUBACCTSEC: UnicodeString read GetSUBACCTSEC write SetSUBACCTSEC;
    property RELFITID: UnicodeString read GetRELFITID write SetRELFITID;
    property GAIN: UnicodeString read GetGAIN write SetGAIN;
  end;

{ IXMLCLOSUREOPTTypeList }

  IXMLCLOSUREOPTTypeList = interface(IXMLNodeCollection)
    ['{6FA1F84B-F1BB-4284-B11D-77C612961180}']
    { Methods & Properties }
    function Add: IXMLCLOSUREOPTType;
    function Insert(const Index: Integer): IXMLCLOSUREOPTType;

    function GetItem(Index: Integer): IXMLCLOSUREOPTType;
    property Items[Index: Integer]: IXMLCLOSUREOPTType read GetItem; default;
  end;

{ IXMLINCOMEType }

  IXMLINCOMEType = interface(IXMLNode)
    ['{11E31943-23C8-4094-B844-DA8CE7BF0A87}']
    { Property Accessors }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetINCOMETYPE: UnicodeString;
    function GetTOTAL: UnicodeString;
    function GetSUBACCTSEC: UnicodeString;
    function GetSUBACCTFUND: IXMLSUBACCTFUNDType;
    function GetTAXEXEMPT: UnicodeString;
    function GetWITHHOLDING: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetINCOMETYPE(Value: UnicodeString);
    procedure SetTOTAL(Value: UnicodeString);
    procedure SetSUBACCTSEC(Value: UnicodeString);
    procedure SetTAXEXEMPT(Value: UnicodeString);
    procedure SetWITHHOLDING(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
    { Methods & Properties }
    property INVTRAN: IXMLINVTRANType read GetINVTRAN;
    property SECID: IXMLSECIDType read GetSECID;
    property INCOMETYPE: UnicodeString read GetINCOMETYPE write SetINCOMETYPE;
    property TOTAL: UnicodeString read GetTOTAL write SetTOTAL;
    property SUBACCTSEC: UnicodeString read GetSUBACCTSEC write SetSUBACCTSEC;
    property SUBACCTFUND: IXMLSUBACCTFUNDType read GetSUBACCTFUND;
    property TAXEXEMPT: UnicodeString read GetTAXEXEMPT write SetTAXEXEMPT;
    property WITHHOLDING: UnicodeString read GetWITHHOLDING write SetWITHHOLDING;
    property CURRENCY: UnicodeString read GetCURRENCY write SetCURRENCY;
    property ORIGCURRENCY: UnicodeString read GetORIGCURRENCY write SetORIGCURRENCY;
  end;

{ IXMLINCOMETypeList }

  IXMLINCOMETypeList = interface(IXMLNodeCollection)
    ['{DCA52504-68CE-48B7-8790-E3227ABE9167}']
    { Methods & Properties }
    function Add: IXMLINCOMEType;
    function Insert(const Index: Integer): IXMLINCOMEType;

    function GetItem(Index: Integer): IXMLINCOMEType;
    property Items[Index: Integer]: IXMLINCOMEType read GetItem; default;
  end;

{ IXMLINVEXPENSEType }

  IXMLINVEXPENSEType = interface(IXMLNode)
    ['{3E2D69B5-57CA-41E0-A69B-B859A3E271F7}']
    { Property Accessors }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetTOTAL: UnicodeString;
    function GetSUBACCTSEC: UnicodeString;
    function GetSUBACCTFUND: IXMLSUBACCTFUNDType;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetTOTAL(Value: UnicodeString);
    procedure SetSUBACCTSEC(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
    { Methods & Properties }
    property INVTRAN: IXMLINVTRANType read GetINVTRAN;
    property SECID: IXMLSECIDType read GetSECID;
    property TOTAL: UnicodeString read GetTOTAL write SetTOTAL;
    property SUBACCTSEC: UnicodeString read GetSUBACCTSEC write SetSUBACCTSEC;
    property SUBACCTFUND: IXMLSUBACCTFUNDType read GetSUBACCTFUND;
    property CURRENCY: UnicodeString read GetCURRENCY write SetCURRENCY;
    property ORIGCURRENCY: UnicodeString read GetORIGCURRENCY write SetORIGCURRENCY;
  end;

{ IXMLINVEXPENSETypeList }

  IXMLINVEXPENSETypeList = interface(IXMLNodeCollection)
    ['{F19A467E-A3B3-4369-9EA9-568951520314}']
    { Methods & Properties }
    function Add: IXMLINVEXPENSEType;
    function Insert(const Index: Integer): IXMLINVEXPENSEType;

    function GetItem(Index: Integer): IXMLINVEXPENSEType;
    property Items[Index: Integer]: IXMLINVEXPENSEType read GetItem; default;
  end;

{ IXMLJRNLFUNDType }

  IXMLJRNLFUNDType = interface(IXMLNode)
    ['{95A9B295-20C0-4E53-8D89-B2F364289F76}']
    { Property Accessors }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSUBACCTTO: UnicodeString;
    function GetSUBACCTFROM: UnicodeString;
    function GetTOTAL: UnicodeString;
    procedure SetSUBACCTTO(Value: UnicodeString);
    procedure SetSUBACCTFROM(Value: UnicodeString);
    procedure SetTOTAL(Value: UnicodeString);
    { Methods & Properties }
    property INVTRAN: IXMLINVTRANType read GetINVTRAN;
    property SUBACCTTO: UnicodeString read GetSUBACCTTO write SetSUBACCTTO;
    property SUBACCTFROM: UnicodeString read GetSUBACCTFROM write SetSUBACCTFROM;
    property TOTAL: UnicodeString read GetTOTAL write SetTOTAL;
  end;

{ IXMLJRNLFUNDTypeList }

  IXMLJRNLFUNDTypeList = interface(IXMLNodeCollection)
    ['{BCAE81F4-EFA3-4DDF-BF70-D1B9CCA3B897}']
    { Methods & Properties }
    function Add: IXMLJRNLFUNDType;
    function Insert(const Index: Integer): IXMLJRNLFUNDType;

    function GetItem(Index: Integer): IXMLJRNLFUNDType;
    property Items[Index: Integer]: IXMLJRNLFUNDType read GetItem; default;
  end;

{ IXMLJRNLSECType }

  IXMLJRNLSECType = interface(IXMLNode)
    ['{9A3988BA-D4CE-49EC-B0E5-CCA60DB445A6}']
    { Property Accessors }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetSUBACCTTO: UnicodeString;
    function GetSUBACCTFROM: UnicodeString;
    function GetUNITS: UnicodeString;
    procedure SetSUBACCTTO(Value: UnicodeString);
    procedure SetSUBACCTFROM(Value: UnicodeString);
    procedure SetUNITS(Value: UnicodeString);
    { Methods & Properties }
    property INVTRAN: IXMLINVTRANType read GetINVTRAN;
    property SECID: IXMLSECIDType read GetSECID;
    property SUBACCTTO: UnicodeString read GetSUBACCTTO write SetSUBACCTTO;
    property SUBACCTFROM: UnicodeString read GetSUBACCTFROM write SetSUBACCTFROM;
    property UNITS: UnicodeString read GetUNITS write SetUNITS;
  end;

{ IXMLJRNLSECTypeList }

  IXMLJRNLSECTypeList = interface(IXMLNodeCollection)
    ['{51279520-9AF6-4486-B3D3-A6E8844797DA}']
    { Methods & Properties }
    function Add: IXMLJRNLSECType;
    function Insert(const Index: Integer): IXMLJRNLSECType;

    function GetItem(Index: Integer): IXMLJRNLSECType;
    property Items[Index: Integer]: IXMLJRNLSECType read GetItem; default;
  end;

{ IXMLMARGININTERESTType }

  IXMLMARGININTERESTType = interface(IXMLNode)
    ['{7F7D11ED-751D-4D60-BE3D-0234C8B15F0C}']
    { Property Accessors }
    function GetINVTRAN: IXMLINVTRANType;
    function GetTOTAL: UnicodeString;
    function GetSUBACCTFUND: IXMLSUBACCTFUNDType;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetTOTAL(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
    { Methods & Properties }
    property INVTRAN: IXMLINVTRANType read GetINVTRAN;
    property TOTAL: UnicodeString read GetTOTAL write SetTOTAL;
    property SUBACCTFUND: IXMLSUBACCTFUNDType read GetSUBACCTFUND;
    property CURRENCY: UnicodeString read GetCURRENCY write SetCURRENCY;
    property ORIGCURRENCY: UnicodeString read GetORIGCURRENCY write SetORIGCURRENCY;
  end;

{ IXMLMARGININTERESTTypeList }

  IXMLMARGININTERESTTypeList = interface(IXMLNodeCollection)
    ['{4C0C6A58-298F-461D-BDAC-F86F4EECAF9F}']
    { Methods & Properties }
    function Add: IXMLMARGININTERESTType;
    function Insert(const Index: Integer): IXMLMARGININTERESTType;

    function GetItem(Index: Integer): IXMLMARGININTERESTType;
    property Items[Index: Integer]: IXMLMARGININTERESTType read GetItem; default;
  end;

{ IXMLREINVESTType }

  IXMLREINVESTType = interface(IXMLNode)
    ['{667ABAEA-4291-4F58-A929-1641F76D556E}']
    { Property Accessors }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetINCOMETYPE: UnicodeString;
    function GetTOTAL: UnicodeString;
    function GetSUBACCTSEC: UnicodeString;
    function GetUNITS: UnicodeString;
    function GetUNITPRICE: UnicodeString;
    function GetCOMMISSION: UnicodeString;
    function GetTAXES: UnicodeString;
    function GetFEES: UnicodeString;
    function GetLOAD: UnicodeString;
    function GetTAXEXEMPT: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetINCOMETYPE(Value: UnicodeString);
    procedure SetTOTAL(Value: UnicodeString);
    procedure SetSUBACCTSEC(Value: UnicodeString);
    procedure SetUNITS(Value: UnicodeString);
    procedure SetUNITPRICE(Value: UnicodeString);
    procedure SetCOMMISSION(Value: UnicodeString);
    procedure SetTAXES(Value: UnicodeString);
    procedure SetFEES(Value: UnicodeString);
    procedure SetLOAD(Value: UnicodeString);
    procedure SetTAXEXEMPT(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
    { Methods & Properties }
    property INVTRAN: IXMLINVTRANType read GetINVTRAN;
    property SECID: IXMLSECIDType read GetSECID;
    property INCOMETYPE: UnicodeString read GetINCOMETYPE write SetINCOMETYPE;
    property TOTAL: UnicodeString read GetTOTAL write SetTOTAL;
    property SUBACCTSEC: UnicodeString read GetSUBACCTSEC write SetSUBACCTSEC;
    property UNITS: UnicodeString read GetUNITS write SetUNITS;
    property UNITPRICE: UnicodeString read GetUNITPRICE write SetUNITPRICE;
    property COMMISSION: UnicodeString read GetCOMMISSION write SetCOMMISSION;
    property TAXES: UnicodeString read GetTAXES write SetTAXES;
    property FEES: UnicodeString read GetFEES write SetFEES;
    property LOAD: UnicodeString read GetLOAD write SetLOAD;
    property TAXEXEMPT: UnicodeString read GetTAXEXEMPT write SetTAXEXEMPT;
    property CURRENCY: UnicodeString read GetCURRENCY write SetCURRENCY;
    property ORIGCURRENCY: UnicodeString read GetORIGCURRENCY write SetORIGCURRENCY;
  end;

{ IXMLREINVESTTypeList }

  IXMLREINVESTTypeList = interface(IXMLNodeCollection)
    ['{C3766442-7578-4E41-B6BC-9A715F59F553}']
    { Methods & Properties }
    function Add: IXMLREINVESTType;
    function Insert(const Index: Integer): IXMLREINVESTType;

    function GetItem(Index: Integer): IXMLREINVESTType;
    property Items[Index: Integer]: IXMLREINVESTType read GetItem; default;
  end;

{ IXMLRETOFCAPType }

  IXMLRETOFCAPType = interface(IXMLNode)
    ['{53463B95-7FDA-4720-B25A-74D93775775C}']
    { Property Accessors }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetTOTAL: UnicodeString;
    function GetSUBACCTSEC: UnicodeString;
    function GetSUBACCTFUND: IXMLSUBACCTFUNDType;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetTOTAL(Value: UnicodeString);
    procedure SetSUBACCTSEC(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
    { Methods & Properties }
    property INVTRAN: IXMLINVTRANType read GetINVTRAN;
    property SECID: IXMLSECIDType read GetSECID;
    property TOTAL: UnicodeString read GetTOTAL write SetTOTAL;
    property SUBACCTSEC: UnicodeString read GetSUBACCTSEC write SetSUBACCTSEC;
    property SUBACCTFUND: IXMLSUBACCTFUNDType read GetSUBACCTFUND;
    property CURRENCY: UnicodeString read GetCURRENCY write SetCURRENCY;
    property ORIGCURRENCY: UnicodeString read GetORIGCURRENCY write SetORIGCURRENCY;
  end;

{ IXMLRETOFCAPTypeList }

  IXMLRETOFCAPTypeList = interface(IXMLNodeCollection)
    ['{A0CEC511-94C4-4AE5-B6CE-C11D2F1B1708}']
    { Methods & Properties }
    function Add: IXMLRETOFCAPType;
    function Insert(const Index: Integer): IXMLRETOFCAPType;

    function GetItem(Index: Integer): IXMLRETOFCAPType;
    property Items[Index: Integer]: IXMLRETOFCAPType read GetItem; default;
  end;

{ IXMLSELLDEBTType }

  IXMLSELLDEBTType = interface(IXMLNode)
    ['{7630D7A3-3443-46DA-9F55-EB58FB1B9B60}']
    { Property Accessors }
    function GetINVSELL: IXMLINVSELLType;
    function GetSELLREASON: UnicodeString;
    function GetACCRDINT: UnicodeString;
    procedure SetSELLREASON(Value: UnicodeString);
    procedure SetACCRDINT(Value: UnicodeString);
    { Methods & Properties }
    property INVSELL: IXMLINVSELLType read GetINVSELL;
    property SELLREASON: UnicodeString read GetSELLREASON write SetSELLREASON;
    property ACCRDINT: UnicodeString read GetACCRDINT write SetACCRDINT;
  end;

{ IXMLSELLDEBTTypeList }

  IXMLSELLDEBTTypeList = interface(IXMLNodeCollection)
    ['{B9FD70B8-BB52-470E-BA6F-F1BD3C116E12}']
    { Methods & Properties }
    function Add: IXMLSELLDEBTType;
    function Insert(const Index: Integer): IXMLSELLDEBTType;

    function GetItem(Index: Integer): IXMLSELLDEBTType;
    property Items[Index: Integer]: IXMLSELLDEBTType read GetItem; default;
  end;

{ IXMLINVSELLType }

  IXMLINVSELLType = interface(IXMLNode)
    ['{9B07A490-3C29-4773-A6E6-3822693254D9}']
    { Property Accessors }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetUNITS: UnicodeString;
    function GetUNITPRICE: UnicodeString;
    function GetMARKDOWN: UnicodeString;
    function GetCOMMISSION: UnicodeString;
    function GetTAXES: UnicodeString;
    function GetFEES: UnicodeString;
    function GetLOAD: UnicodeString;
    function GetWITHHOLDING: UnicodeString;
    function GetTAXEXEMPT: UnicodeString;
    function GetTOTAL: UnicodeString;
    function GetGAIN: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    function GetSUBACCTSEC: UnicodeString;
    function GetSUBACCTFUND: IXMLSUBACCTFUNDType;
    procedure SetUNITS(Value: UnicodeString);
    procedure SetUNITPRICE(Value: UnicodeString);
    procedure SetMARKDOWN(Value: UnicodeString);
    procedure SetCOMMISSION(Value: UnicodeString);
    procedure SetTAXES(Value: UnicodeString);
    procedure SetFEES(Value: UnicodeString);
    procedure SetLOAD(Value: UnicodeString);
    procedure SetWITHHOLDING(Value: UnicodeString);
    procedure SetTAXEXEMPT(Value: UnicodeString);
    procedure SetTOTAL(Value: UnicodeString);
    procedure SetGAIN(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
    procedure SetSUBACCTSEC(Value: UnicodeString);
    { Methods & Properties }
    property INVTRAN: IXMLINVTRANType read GetINVTRAN;
    property SECID: IXMLSECIDType read GetSECID;
    property UNITS: UnicodeString read GetUNITS write SetUNITS;
    property UNITPRICE: UnicodeString read GetUNITPRICE write SetUNITPRICE;
    property MARKDOWN: UnicodeString read GetMARKDOWN write SetMARKDOWN;
    property COMMISSION: UnicodeString read GetCOMMISSION write SetCOMMISSION;
    property TAXES: UnicodeString read GetTAXES write SetTAXES;
    property FEES: UnicodeString read GetFEES write SetFEES;
    property LOAD: UnicodeString read GetLOAD write SetLOAD;
    property WITHHOLDING: UnicodeString read GetWITHHOLDING write SetWITHHOLDING;
    property TAXEXEMPT: UnicodeString read GetTAXEXEMPT write SetTAXEXEMPT;
    property TOTAL: UnicodeString read GetTOTAL write SetTOTAL;
    property GAIN: UnicodeString read GetGAIN write SetGAIN;
    property CURRENCY: UnicodeString read GetCURRENCY write SetCURRENCY;
    property ORIGCURRENCY: UnicodeString read GetORIGCURRENCY write SetORIGCURRENCY;
    property SUBACCTSEC: UnicodeString read GetSUBACCTSEC write SetSUBACCTSEC;
    property SUBACCTFUND: IXMLSUBACCTFUNDType read GetSUBACCTFUND;
  end;

{ IXMLSELLMFType }

  IXMLSELLMFType = interface(IXMLNode)
    ['{DCF82272-D93E-4234-980F-8EEB674EF192}']
    { Property Accessors }
    function GetINVSELL: IXMLINVSELLType;
    function GetSELLTYPE: UnicodeString;
    function GetAVGCOSTBASIS: UnicodeString;
    function GetRELFITID: UnicodeString;
    procedure SetSELLTYPE(Value: UnicodeString);
    procedure SetAVGCOSTBASIS(Value: UnicodeString);
    procedure SetRELFITID(Value: UnicodeString);
    { Methods & Properties }
    property INVSELL: IXMLINVSELLType read GetINVSELL;
    property SELLTYPE: UnicodeString read GetSELLTYPE write SetSELLTYPE;
    property AVGCOSTBASIS: UnicodeString read GetAVGCOSTBASIS write SetAVGCOSTBASIS;
    property RELFITID: UnicodeString read GetRELFITID write SetRELFITID;
  end;

{ IXMLSELLMFTypeList }

  IXMLSELLMFTypeList = interface(IXMLNodeCollection)
    ['{614DF3C0-F51B-4306-B6E6-AEF854B88BAD}']
    { Methods & Properties }
    function Add: IXMLSELLMFType;
    function Insert(const Index: Integer): IXMLSELLMFType;

    function GetItem(Index: Integer): IXMLSELLMFType;
    property Items[Index: Integer]: IXMLSELLMFType read GetItem; default;
  end;

{ IXMLSELLOPTType }

  IXMLSELLOPTType = interface(IXMLNode)
    ['{67246782-078F-49A3-BE6B-62B364B393D8}']
    { Property Accessors }
    function GetINVSELL: IXMLINVSELLType;
    function GetOPTSELLTYPE: UnicodeString;
    function GetSHPERCTRCT: UnicodeString;
    function GetRELFITID: UnicodeString;
    function GetRELTYPE: UnicodeString;
    function GetSECURED: UnicodeString;
    procedure SetOPTSELLTYPE(Value: UnicodeString);
    procedure SetSHPERCTRCT(Value: UnicodeString);
    procedure SetRELFITID(Value: UnicodeString);
    procedure SetRELTYPE(Value: UnicodeString);
    procedure SetSECURED(Value: UnicodeString);
    { Methods & Properties }
    property INVSELL: IXMLINVSELLType read GetINVSELL;
    property OPTSELLTYPE: UnicodeString read GetOPTSELLTYPE write SetOPTSELLTYPE;
    property SHPERCTRCT: UnicodeString read GetSHPERCTRCT write SetSHPERCTRCT;
    property RELFITID: UnicodeString read GetRELFITID write SetRELFITID;
    property RELTYPE: UnicodeString read GetRELTYPE write SetRELTYPE;
    property SECURED: UnicodeString read GetSECURED write SetSECURED;
  end;

{ IXMLSELLOPTTypeList }

  IXMLSELLOPTTypeList = interface(IXMLNodeCollection)
    ['{DC289944-896C-4967-82E5-531045794BE1}']
    { Methods & Properties }
    function Add: IXMLSELLOPTType;
    function Insert(const Index: Integer): IXMLSELLOPTType;

    function GetItem(Index: Integer): IXMLSELLOPTType;
    property Items[Index: Integer]: IXMLSELLOPTType read GetItem; default;
  end;

{ IXMLSELLOTHERType }

  IXMLSELLOTHERType = interface(IXMLNode)
    ['{83EBE237-23FF-4843-A512-151699A7C393}']
    { Property Accessors }
    function GetINVSELL: IXMLINVSELLType;
    { Methods & Properties }
    property INVSELL: IXMLINVSELLType read GetINVSELL;
  end;

{ IXMLSELLOTHERTypeList }

  IXMLSELLOTHERTypeList = interface(IXMLNodeCollection)
    ['{EC99D85F-E9F3-4620-9FA9-5341D9C9179D}']
    { Methods & Properties }
    function Add: IXMLSELLOTHERType;
    function Insert(const Index: Integer): IXMLSELLOTHERType;

    function GetItem(Index: Integer): IXMLSELLOTHERType;
    property Items[Index: Integer]: IXMLSELLOTHERType read GetItem; default;
  end;

{ IXMLSELLSTOCKType }

  IXMLSELLSTOCKType = interface(IXMLNode)
    ['{300C5EDC-5B7A-42B9-983E-0D937467AD86}']
    { Property Accessors }
    function GetINVSELL: IXMLINVSELLType;
    function GetSELLTYPE: UnicodeString;
    procedure SetSELLTYPE(Value: UnicodeString);
    { Methods & Properties }
    property INVSELL: IXMLINVSELLType read GetINVSELL;
    property SELLTYPE: UnicodeString read GetSELLTYPE write SetSELLTYPE;
  end;

{ IXMLSELLSTOCKTypeList }

  IXMLSELLSTOCKTypeList = interface(IXMLNodeCollection)
    ['{36428834-043C-4A21-8A26-9C7E1994EFF4}']
    { Methods & Properties }
    function Add: IXMLSELLSTOCKType;
    function Insert(const Index: Integer): IXMLSELLSTOCKType;

    function GetItem(Index: Integer): IXMLSELLSTOCKType;
    property Items[Index: Integer]: IXMLSELLSTOCKType read GetItem; default;
  end;

{ IXMLSPLITType }

  IXMLSPLITType = interface(IXMLNode)
    ['{A37BD391-B1AA-4E1D-AD9D-E6BED1A09E84}']
    { Property Accessors }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetSUBACCTSEC: UnicodeString;
    function GetOLDUNITS: UnicodeString;
    function GetNEWUNITS: UnicodeString;
    function GetNUMERATOR: UnicodeString;
    function GetDENOMINATOR: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    function GetFRACCASH: UnicodeString;
    function GetSUBACCTFUND: IXMLSUBACCTFUNDType;
    procedure SetSUBACCTSEC(Value: UnicodeString);
    procedure SetOLDUNITS(Value: UnicodeString);
    procedure SetNEWUNITS(Value: UnicodeString);
    procedure SetNUMERATOR(Value: UnicodeString);
    procedure SetDENOMINATOR(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
    procedure SetFRACCASH(Value: UnicodeString);
    { Methods & Properties }
    property INVTRAN: IXMLINVTRANType read GetINVTRAN;
    property SECID: IXMLSECIDType read GetSECID;
    property SUBACCTSEC: UnicodeString read GetSUBACCTSEC write SetSUBACCTSEC;
    property OLDUNITS: UnicodeString read GetOLDUNITS write SetOLDUNITS;
    property NEWUNITS: UnicodeString read GetNEWUNITS write SetNEWUNITS;
    property NUMERATOR: UnicodeString read GetNUMERATOR write SetNUMERATOR;
    property DENOMINATOR: UnicodeString read GetDENOMINATOR write SetDENOMINATOR;
    property CURRENCY: UnicodeString read GetCURRENCY write SetCURRENCY;
    property ORIGCURRENCY: UnicodeString read GetORIGCURRENCY write SetORIGCURRENCY;
    property FRACCASH: UnicodeString read GetFRACCASH write SetFRACCASH;
    property SUBACCTFUND: IXMLSUBACCTFUNDType read GetSUBACCTFUND;
  end;

{ IXMLSPLITTypeList }

  IXMLSPLITTypeList = interface(IXMLNodeCollection)
    ['{DDB470F5-EA50-4D54-9630-62A713D9DE34}']
    { Methods & Properties }
    function Add: IXMLSPLITType;
    function Insert(const Index: Integer): IXMLSPLITType;

    function GetItem(Index: Integer): IXMLSPLITType;
    property Items[Index: Integer]: IXMLSPLITType read GetItem; default;
  end;

{ IXMLTRANSFERType }

  IXMLTRANSFERType = interface(IXMLNode)
    ['{83B1A859-E1A7-45C5-AEE2-530995358135}']
    { Property Accessors }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetSUBACCTSEC: UnicodeString;
    function GetUNITS: UnicodeString;
    function GetTFERACTION: UnicodeString;
    function GetPOSTYPE: UnicodeString;
    function GetINVACCTFROM: IXMLINVACCTFROMType;
    function GetAVGCOSTBASIS: UnicodeString;
    function GetUNITPRICE: UnicodeString;
    function GetDTPURCHASE: UnicodeString;
    procedure SetSUBACCTSEC(Value: UnicodeString);
    procedure SetUNITS(Value: UnicodeString);
    procedure SetTFERACTION(Value: UnicodeString);
    procedure SetPOSTYPE(Value: UnicodeString);
    procedure SetAVGCOSTBASIS(Value: UnicodeString);
    procedure SetUNITPRICE(Value: UnicodeString);
    procedure SetDTPURCHASE(Value: UnicodeString);
    { Methods & Properties }
    property INVTRAN: IXMLINVTRANType read GetINVTRAN;
    property SECID: IXMLSECIDType read GetSECID;
    property SUBACCTSEC: UnicodeString read GetSUBACCTSEC write SetSUBACCTSEC;
    property UNITS: UnicodeString read GetUNITS write SetUNITS;
    property TFERACTION: UnicodeString read GetTFERACTION write SetTFERACTION;
    property POSTYPE: UnicodeString read GetPOSTYPE write SetPOSTYPE;
    property INVACCTFROM: IXMLINVACCTFROMType read GetINVACCTFROM;
    property AVGCOSTBASIS: UnicodeString read GetAVGCOSTBASIS write SetAVGCOSTBASIS;
    property UNITPRICE: UnicodeString read GetUNITPRICE write SetUNITPRICE;
    property DTPURCHASE: UnicodeString read GetDTPURCHASE write SetDTPURCHASE;
  end;

{ IXMLTRANSFERTypeList }

  IXMLTRANSFERTypeList = interface(IXMLNodeCollection)
    ['{B3C66A99-E5EC-42F2-B6D0-AA36043362A3}']
    { Methods & Properties }
    function Add: IXMLTRANSFERType;
    function Insert(const Index: Integer): IXMLTRANSFERType;

    function GetItem(Index: Integer): IXMLTRANSFERType;
    property Items[Index: Integer]: IXMLTRANSFERType read GetItem; default;
  end;

{ IXMLINVBANKTRANType }

  IXMLINVBANKTRANType = interface(IXMLNode)
    ['{61EBD2EE-4560-413E-B1D5-55A6013BE111}']
    { Property Accessors }
    function GetSTMTTRN: IXMLSTMTTRNType;
    function GetSUBACCTFUND: IXMLSUBACCTFUNDType;
    { Methods & Properties }
    property STMTTRN: IXMLSTMTTRNType read GetSTMTTRN;
    property SUBACCTFUND: IXMLSUBACCTFUNDType read GetSUBACCTFUND;
  end;

{ IXMLINVBANKTRANTypeList }

  IXMLINVBANKTRANTypeList = interface(IXMLNodeCollection)
    ['{FC1A89DB-91B3-4424-A9DE-6934278A756D}']
    { Methods & Properties }
    function Add: IXMLINVBANKTRANType;
    function Insert(const Index: Integer): IXMLINVBANKTRANType;

    function GetItem(Index: Integer): IXMLINVBANKTRANType;
    property Items[Index: Integer]: IXMLINVBANKTRANType read GetItem; default;
  end;

{ IXMLINVPOSLISTType }

  IXMLINVPOSLISTType = interface(IXMLNode)
    ['{4583E2AF-CFDE-45B5-92B1-B069BC39CADF}']
    { Property Accessors }
    function GetPOSMF: IXMLPOSMFTypeList;
    function GetPOSSTOCK: IXMLPOSSTOCKTypeList;
    function GetPOSDEBT: IXMLPOSDEBTTypeList;
    function GetPOSOPT: IXMLPOSOPTTypeList;
    function GetPOSOTHER: IXMLPOSOTHERTypeList;
    { Methods & Properties }
    property POSMF: IXMLPOSMFTypeList read GetPOSMF;
    property POSSTOCK: IXMLPOSSTOCKTypeList read GetPOSSTOCK;
    property POSDEBT: IXMLPOSDEBTTypeList read GetPOSDEBT;
    property POSOPT: IXMLPOSOPTTypeList read GetPOSOPT;
    property POSOTHER: IXMLPOSOTHERTypeList read GetPOSOTHER;
  end;

{ IXMLPOSMFType }

  IXMLPOSMFType = interface(IXMLNode)
    ['{DBC40F07-7896-49E3-B568-51693E5321EF}']
    { Property Accessors }
    function GetINVPOS: IXMLINVPOSType;
    function GetUNITSSTREET: UnicodeString;
    function GetUNITSUSER: UnicodeString;
    function GetREINVDIV: UnicodeString;
    function GetREINVCG: UnicodeString;
    procedure SetUNITSSTREET(Value: UnicodeString);
    procedure SetUNITSUSER(Value: UnicodeString);
    procedure SetREINVDIV(Value: UnicodeString);
    procedure SetREINVCG(Value: UnicodeString);
    { Methods & Properties }
    property INVPOS: IXMLINVPOSType read GetINVPOS;
    property UNITSSTREET: UnicodeString read GetUNITSSTREET write SetUNITSSTREET;
    property UNITSUSER: UnicodeString read GetUNITSUSER write SetUNITSUSER;
    property REINVDIV: UnicodeString read GetREINVDIV write SetREINVDIV;
    property REINVCG: UnicodeString read GetREINVCG write SetREINVCG;
  end;

{ IXMLPOSMFTypeList }

  IXMLPOSMFTypeList = interface(IXMLNodeCollection)
    ['{5C7ADE0A-41A2-49C9-9C31-33961F2F37F2}']
    { Methods & Properties }
    function Add: IXMLPOSMFType;
    function Insert(const Index: Integer): IXMLPOSMFType;

    function GetItem(Index: Integer): IXMLPOSMFType;
    property Items[Index: Integer]: IXMLPOSMFType read GetItem; default;
  end;

{ IXMLINVPOSType }

  IXMLINVPOSType = interface(IXMLNode)
    ['{7668F291-110B-4D20-866D-ECCFB37B727D}']
    { Property Accessors }
    function GetSECID: IXMLSECIDType;
    function GetHELDINACCT: UnicodeString;
    function GetPOSTYPE: UnicodeString;
    function GetUNITS: UnicodeString;
    function GetUNITPRICE: UnicodeString;
    function GetMKTVAL: UnicodeString;
    function GetDTPRICEASOF: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetMEMO: UnicodeString;
    procedure SetHELDINACCT(Value: UnicodeString);
    procedure SetPOSTYPE(Value: UnicodeString);
    procedure SetUNITS(Value: UnicodeString);
    procedure SetUNITPRICE(Value: UnicodeString);
    procedure SetMKTVAL(Value: UnicodeString);
    procedure SetDTPRICEASOF(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetMEMO(Value: UnicodeString);
    { Methods & Properties }
    property SECID: IXMLSECIDType read GetSECID;
    property HELDINACCT: UnicodeString read GetHELDINACCT write SetHELDINACCT;
    property POSTYPE: UnicodeString read GetPOSTYPE write SetPOSTYPE;
    property UNITS: UnicodeString read GetUNITS write SetUNITS;
    property UNITPRICE: UnicodeString read GetUNITPRICE write SetUNITPRICE;
    property MKTVAL: UnicodeString read GetMKTVAL write SetMKTVAL;
    property DTPRICEASOF: UnicodeString read GetDTPRICEASOF write SetDTPRICEASOF;
    property CURRENCY: UnicodeString read GetCURRENCY write SetCURRENCY;
    property MEMO: UnicodeString read GetMEMO write SetMEMO;
  end;

{ IXMLPOSSTOCKType }

  IXMLPOSSTOCKType = interface(IXMLNode)
    ['{FED3E85E-EE56-4F75-B5D0-53DF36248E2B}']
    { Property Accessors }
    function GetINVPOS: IXMLINVPOSType;
    function GetUNITSSTREET: UnicodeString;
    function GetUNITSUSER: UnicodeString;
    function GetREINVDIV: UnicodeString;
    procedure SetUNITSSTREET(Value: UnicodeString);
    procedure SetUNITSUSER(Value: UnicodeString);
    procedure SetREINVDIV(Value: UnicodeString);
    { Methods & Properties }
    property INVPOS: IXMLINVPOSType read GetINVPOS;
    property UNITSSTREET: UnicodeString read GetUNITSSTREET write SetUNITSSTREET;
    property UNITSUSER: UnicodeString read GetUNITSUSER write SetUNITSUSER;
    property REINVDIV: UnicodeString read GetREINVDIV write SetREINVDIV;
  end;

{ IXMLPOSSTOCKTypeList }

  IXMLPOSSTOCKTypeList = interface(IXMLNodeCollection)
    ['{17AE5453-2FDD-4C4D-93C0-64F339A18DE7}']
    { Methods & Properties }
    function Add: IXMLPOSSTOCKType;
    function Insert(const Index: Integer): IXMLPOSSTOCKType;

    function GetItem(Index: Integer): IXMLPOSSTOCKType;
    property Items[Index: Integer]: IXMLPOSSTOCKType read GetItem; default;
  end;

{ IXMLPOSDEBTType }

  IXMLPOSDEBTType = interface(IXMLNode)
    ['{13144A14-6913-4D5D-8292-55A30E203037}']
    { Property Accessors }
    function GetINVPOS: IXMLINVPOSType;
    { Methods & Properties }
    property INVPOS: IXMLINVPOSType read GetINVPOS;
  end;

{ IXMLPOSDEBTTypeList }

  IXMLPOSDEBTTypeList = interface(IXMLNodeCollection)
    ['{D02D83B3-6DB8-4BBE-B338-7359B6F9095A}']
    { Methods & Properties }
    function Add: IXMLPOSDEBTType;
    function Insert(const Index: Integer): IXMLPOSDEBTType;

    function GetItem(Index: Integer): IXMLPOSDEBTType;
    property Items[Index: Integer]: IXMLPOSDEBTType read GetItem; default;
  end;

{ IXMLPOSOPTType }

  IXMLPOSOPTType = interface(IXMLNode)
    ['{A8AC8AC8-9044-4836-9C8F-2F593DA0DBE2}']
    { Property Accessors }
    function GetINVPOS: IXMLINVPOSType;
    function GetSECURED: UnicodeString;
    procedure SetSECURED(Value: UnicodeString);
    { Methods & Properties }
    property INVPOS: IXMLINVPOSType read GetINVPOS;
    property SECURED: UnicodeString read GetSECURED write SetSECURED;
  end;

{ IXMLPOSOPTTypeList }

  IXMLPOSOPTTypeList = interface(IXMLNodeCollection)
    ['{9768DE72-4C47-47FC-8AA0-E02C9230328C}']
    { Methods & Properties }
    function Add: IXMLPOSOPTType;
    function Insert(const Index: Integer): IXMLPOSOPTType;

    function GetItem(Index: Integer): IXMLPOSOPTType;
    property Items[Index: Integer]: IXMLPOSOPTType read GetItem; default;
  end;

{ IXMLPOSOTHERType }

  IXMLPOSOTHERType = interface(IXMLNode)
    ['{C58317E5-2125-4E9D-ADB0-363727363090}']
    { Property Accessors }
    function GetINVPOS: IXMLINVPOSType;
    { Methods & Properties }
    property INVPOS: IXMLINVPOSType read GetINVPOS;
  end;

{ IXMLPOSOTHERTypeList }

  IXMLPOSOTHERTypeList = interface(IXMLNodeCollection)
    ['{0737108D-0DBF-4BFC-B2A4-C65F87E12ECD}']
    { Methods & Properties }
    function Add: IXMLPOSOTHERType;
    function Insert(const Index: Integer): IXMLPOSOTHERType;

    function GetItem(Index: Integer): IXMLPOSOTHERType;
    property Items[Index: Integer]: IXMLPOSOTHERType read GetItem; default;
  end;

{ IXMLINVBALType }

  IXMLINVBALType = interface(IXMLNode)
    ['{0C12915F-8D58-4DD7-BE35-D12C3B34A2CE}']
    { Property Accessors }
    function GetAVAILCASH: UnicodeString;
    function GetMARGINBALANCE: UnicodeString;
    function GetSHORTBALANCE: UnicodeString;
    function GetBUYPOWER: UnicodeString;
    function GetBALLIST: IXMLBALLISTType;
    procedure SetAVAILCASH(Value: UnicodeString);
    procedure SetMARGINBALANCE(Value: UnicodeString);
    procedure SetSHORTBALANCE(Value: UnicodeString);
    procedure SetBUYPOWER(Value: UnicodeString);
    { Methods & Properties }
    property AVAILCASH: UnicodeString read GetAVAILCASH write SetAVAILCASH;
    property MARGINBALANCE: UnicodeString read GetMARGINBALANCE write SetMARGINBALANCE;
    property SHORTBALANCE: UnicodeString read GetSHORTBALANCE write SetSHORTBALANCE;
    property BUYPOWER: UnicodeString read GetBUYPOWER write SetBUYPOWER;
    property BALLIST: IXMLBALLISTType read GetBALLIST;
  end;

{ IXMLBALLISTType }

  IXMLBALLISTType = interface(IXMLNodeCollection)
    ['{41571BED-C3A9-45CE-B74F-8D1E4524EB77}']
    { Property Accessors }
    function GetBAL(Index: Integer): IXMLBALType;
    { Methods & Properties }
    function Add: IXMLBALType;
    function Insert(const Index: Integer): IXMLBALType;
    property BAL[Index: Integer]: IXMLBALType read GetBAL; default;
  end;

{ IXMLBALType }

  IXMLBALType = interface(IXMLNode)
    ['{46CAF0FD-A4CF-4E7A-8CA9-6599FB34A1F1}']
    { Property Accessors }
    function GetNAME: UnicodeString;
    function GetDESC: UnicodeString;
    function GetBALTYPE: UnicodeString;
    function GetVALUE: UnicodeString;
    function GetDTASOF: UnicodeString;
    function GetCURRENCY: UnicodeString;
    procedure SetNAME(Value: UnicodeString);
    procedure SetDESC(Value: UnicodeString);
    procedure SetBALTYPE(Value: UnicodeString);
    procedure SetVALUE(Value: UnicodeString);
    procedure SetDTASOF(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    { Methods & Properties }
    property NAME: UnicodeString read GetNAME write SetNAME;
    property DESC: UnicodeString read GetDESC write SetDESC;
    property BALTYPE: UnicodeString read GetBALTYPE write SetBALTYPE;
    property VALUE: UnicodeString read GetVALUE write SetVALUE;
    property DTASOF: UnicodeString read GetDTASOF write SetDTASOF;
    property CURRENCY: UnicodeString read GetCURRENCY write SetCURRENCY;
  end;

{ IXMLINVOOLISTType }

  IXMLINVOOLISTType = interface(IXMLNode)
    ['{2E8E07BF-27EC-4AE4-8387-76198C8798F2}']
    { Property Accessors }
    function GetOOBUYDEBT: IXMLOOBUYDEBTTypeList;
    function GetOOBUYMF: IXMLOOBUYMFTypeList;
    function GetOOBUYOPT: IXMLOOBUYOPTTypeList;
    function GetOOBUYOTHER: IXMLOOBUYOTHERTypeList;
    function GetOOBUYSTOCK: IXMLOOBUYSTOCKTypeList;
    function GetOOSELLDEBT: IXMLOOSELLDEBTTypeList;
    function GetOOSELLMF: IXMLOOSELLMFTypeList;
    function GetOOSELLOPT: IXMLOOSELLOPTTypeList;
    function GetOOSELLOTHER: IXMLOOSELLOTHERTypeList;
    function GetOOSELLSTOCK: IXMLOOSELLSTOCKTypeList;
    function GetOOSWITCHMF: IXMLOOSWITCHMFTypeList;
    { Methods & Properties }
    property OOBUYDEBT: IXMLOOBUYDEBTTypeList read GetOOBUYDEBT;
    property OOBUYMF: IXMLOOBUYMFTypeList read GetOOBUYMF;
    property OOBUYOPT: IXMLOOBUYOPTTypeList read GetOOBUYOPT;
    property OOBUYOTHER: IXMLOOBUYOTHERTypeList read GetOOBUYOTHER;
    property OOBUYSTOCK: IXMLOOBUYSTOCKTypeList read GetOOBUYSTOCK;
    property OOSELLDEBT: IXMLOOSELLDEBTTypeList read GetOOSELLDEBT;
    property OOSELLMF: IXMLOOSELLMFTypeList read GetOOSELLMF;
    property OOSELLOPT: IXMLOOSELLOPTTypeList read GetOOSELLOPT;
    property OOSELLOTHER: IXMLOOSELLOTHERTypeList read GetOOSELLOTHER;
    property OOSELLSTOCK: IXMLOOSELLSTOCKTypeList read GetOOSELLSTOCK;
    property OOSWITCHMF: IXMLOOSWITCHMFTypeList read GetOOSWITCHMF;
  end;

{ IXMLOOBUYDEBTType }

  IXMLOOBUYDEBTType = interface(IXMLNode)
    ['{A48CE7AF-B07E-4EE0-AFCD-E15E943DA52C}']
    { Property Accessors }
    function GetOO: IXMLOOType;
    function GetAUCTION: UnicodeString;
    function GetDTAUCTION: UnicodeString;
    procedure SetAUCTION(Value: UnicodeString);
    procedure SetDTAUCTION(Value: UnicodeString);
    { Methods & Properties }
    property OO: IXMLOOType read GetOO;
    property AUCTION: UnicodeString read GetAUCTION write SetAUCTION;
    property DTAUCTION: UnicodeString read GetDTAUCTION write SetDTAUCTION;
  end;

{ IXMLOOBUYDEBTTypeList }

  IXMLOOBUYDEBTTypeList = interface(IXMLNodeCollection)
    ['{14328650-9765-4528-899C-9F692BBD64DA}']
    { Methods & Properties }
    function Add: IXMLOOBUYDEBTType;
    function Insert(const Index: Integer): IXMLOOBUYDEBTType;

    function GetItem(Index: Integer): IXMLOOBUYDEBTType;
    property Items[Index: Integer]: IXMLOOBUYDEBTType read GetItem; default;
  end;

{ IXMLOOType }

  IXMLOOType = interface(IXMLNode)
    ['{4E9504BF-E562-4315-9A5E-B1678F9A7ED9}']
    { Property Accessors }
    function GetFITID: UnicodeString;
    function GetSRVRTID: UnicodeString;
    function GetSECID: IXMLSECIDType;
    function GetDTPLACED: UnicodeString;
    function GetUNITS: UnicodeString;
    function GetSUBACCT: UnicodeString;
    function GetDURATION: UnicodeString;
    function GetRESTRICTION: UnicodeString;
    function GetMINUNITS: UnicodeString;
    function GetLIMITPRICE: UnicodeString;
    function GetSTOPPRICE: UnicodeString;
    function GetMEMO: UnicodeString;
    function GetCURRENCY: UnicodeString;
    procedure SetFITID(Value: UnicodeString);
    procedure SetSRVRTID(Value: UnicodeString);
    procedure SetDTPLACED(Value: UnicodeString);
    procedure SetUNITS(Value: UnicodeString);
    procedure SetSUBACCT(Value: UnicodeString);
    procedure SetDURATION(Value: UnicodeString);
    procedure SetRESTRICTION(Value: UnicodeString);
    procedure SetMINUNITS(Value: UnicodeString);
    procedure SetLIMITPRICE(Value: UnicodeString);
    procedure SetSTOPPRICE(Value: UnicodeString);
    procedure SetMEMO(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    { Methods & Properties }
    property FITID: UnicodeString read GetFITID write SetFITID;
    property SRVRTID: UnicodeString read GetSRVRTID write SetSRVRTID;
    property SECID: IXMLSECIDType read GetSECID;
    property DTPLACED: UnicodeString read GetDTPLACED write SetDTPLACED;
    property UNITS: UnicodeString read GetUNITS write SetUNITS;
    property SUBACCT: UnicodeString read GetSUBACCT write SetSUBACCT;
    property DURATION: UnicodeString read GetDURATION write SetDURATION;
    property RESTRICTION: UnicodeString read GetRESTRICTION write SetRESTRICTION;
    property MINUNITS: UnicodeString read GetMINUNITS write SetMINUNITS;
    property LIMITPRICE: UnicodeString read GetLIMITPRICE write SetLIMITPRICE;
    property STOPPRICE: UnicodeString read GetSTOPPRICE write SetSTOPPRICE;
    property MEMO: UnicodeString read GetMEMO write SetMEMO;
    property CURRENCY: UnicodeString read GetCURRENCY write SetCURRENCY;
  end;

{ IXMLOOBUYMFType }

  IXMLOOBUYMFType = interface(IXMLNode)
    ['{72F1FAB9-BE0F-41C0-B57A-E2D04654C0A7}']
    { Property Accessors }
    function GetOO: IXMLOOType;
    function GetBUYTYPE: UnicodeString;
    function GetUNITTYPE: UnicodeString;
    procedure SetBUYTYPE(Value: UnicodeString);
    procedure SetUNITTYPE(Value: UnicodeString);
    { Methods & Properties }
    property OO: IXMLOOType read GetOO;
    property BUYTYPE: UnicodeString read GetBUYTYPE write SetBUYTYPE;
    property UNITTYPE: UnicodeString read GetUNITTYPE write SetUNITTYPE;
  end;

{ IXMLOOBUYMFTypeList }

  IXMLOOBUYMFTypeList = interface(IXMLNodeCollection)
    ['{CA0A95F7-84D2-4B6D-8380-0FEB351D55EC}']
    { Methods & Properties }
    function Add: IXMLOOBUYMFType;
    function Insert(const Index: Integer): IXMLOOBUYMFType;

    function GetItem(Index: Integer): IXMLOOBUYMFType;
    property Items[Index: Integer]: IXMLOOBUYMFType read GetItem; default;
  end;

{ IXMLOOBUYOPTType }

  IXMLOOBUYOPTType = interface(IXMLNode)
    ['{327FA056-B749-4DCD-8EF8-9674B20C707B}']
    { Property Accessors }
    function GetOO: IXMLOOType;
    function GetOPTBUYTYPE: UnicodeString;
    procedure SetOPTBUYTYPE(Value: UnicodeString);
    { Methods & Properties }
    property OO: IXMLOOType read GetOO;
    property OPTBUYTYPE: UnicodeString read GetOPTBUYTYPE write SetOPTBUYTYPE;
  end;

{ IXMLOOBUYOPTTypeList }

  IXMLOOBUYOPTTypeList = interface(IXMLNodeCollection)
    ['{0327FA2B-5788-4A4D-A359-A4B9F159DFF3}']
    { Methods & Properties }
    function Add: IXMLOOBUYOPTType;
    function Insert(const Index: Integer): IXMLOOBUYOPTType;

    function GetItem(Index: Integer): IXMLOOBUYOPTType;
    property Items[Index: Integer]: IXMLOOBUYOPTType read GetItem; default;
  end;

{ IXMLOOBUYOTHERType }

  IXMLOOBUYOTHERType = interface(IXMLNode)
    ['{3FC597A8-7D97-4FBD-BA7F-7EF27E4FE142}']
    { Property Accessors }
    function GetOO: IXMLOOType;
    function GetUNITTYPE: UnicodeString;
    procedure SetUNITTYPE(Value: UnicodeString);
    { Methods & Properties }
    property OO: IXMLOOType read GetOO;
    property UNITTYPE: UnicodeString read GetUNITTYPE write SetUNITTYPE;
  end;

{ IXMLOOBUYOTHERTypeList }

  IXMLOOBUYOTHERTypeList = interface(IXMLNodeCollection)
    ['{BE6B8B74-CAAF-443F-8FA7-991AEE8DA2BC}']
    { Methods & Properties }
    function Add: IXMLOOBUYOTHERType;
    function Insert(const Index: Integer): IXMLOOBUYOTHERType;

    function GetItem(Index: Integer): IXMLOOBUYOTHERType;
    property Items[Index: Integer]: IXMLOOBUYOTHERType read GetItem; default;
  end;

{ IXMLOOBUYSTOCKType }

  IXMLOOBUYSTOCKType = interface(IXMLNode)
    ['{F8CF8F7A-38CE-4106-B25C-E6E8022B7916}']
    { Property Accessors }
    function GetOO: IXMLOOType;
    function GetBUYTYPE: UnicodeString;
    procedure SetBUYTYPE(Value: UnicodeString);
    { Methods & Properties }
    property OO: IXMLOOType read GetOO;
    property BUYTYPE: UnicodeString read GetBUYTYPE write SetBUYTYPE;
  end;

{ IXMLOOBUYSTOCKTypeList }

  IXMLOOBUYSTOCKTypeList = interface(IXMLNodeCollection)
    ['{11B79E6E-E20E-44C3-885E-BF1A00FA6754}']
    { Methods & Properties }
    function Add: IXMLOOBUYSTOCKType;
    function Insert(const Index: Integer): IXMLOOBUYSTOCKType;

    function GetItem(Index: Integer): IXMLOOBUYSTOCKType;
    property Items[Index: Integer]: IXMLOOBUYSTOCKType read GetItem; default;
  end;

{ IXMLOOSELLDEBTType }

  IXMLOOSELLDEBTType = interface(IXMLNode)
    ['{73001E9E-5B70-49CB-9CC8-E77F3977C0CA}']
    { Property Accessors }
    function GetOO: IXMLOOType;
    { Methods & Properties }
    property OO: IXMLOOType read GetOO;
  end;

{ IXMLOOSELLDEBTTypeList }

  IXMLOOSELLDEBTTypeList = interface(IXMLNodeCollection)
    ['{C78389CB-4084-4691-B472-FD7B14BF7BA3}']
    { Methods & Properties }
    function Add: IXMLOOSELLDEBTType;
    function Insert(const Index: Integer): IXMLOOSELLDEBTType;

    function GetItem(Index: Integer): IXMLOOSELLDEBTType;
    property Items[Index: Integer]: IXMLOOSELLDEBTType read GetItem; default;
  end;

{ IXMLOOSELLMFType }

  IXMLOOSELLMFType = interface(IXMLNode)
    ['{2A27F027-E0F6-4947-9346-588D55E77E88}']
    { Property Accessors }
    function GetOO: IXMLOOType;
    function GetSELLTYPE: UnicodeString;
    function GetUNITTYPE: UnicodeString;
    function GetSELLALL: UnicodeString;
    procedure SetSELLTYPE(Value: UnicodeString);
    procedure SetUNITTYPE(Value: UnicodeString);
    procedure SetSELLALL(Value: UnicodeString);
    { Methods & Properties }
    property OO: IXMLOOType read GetOO;
    property SELLTYPE: UnicodeString read GetSELLTYPE write SetSELLTYPE;
    property UNITTYPE: UnicodeString read GetUNITTYPE write SetUNITTYPE;
    property SELLALL: UnicodeString read GetSELLALL write SetSELLALL;
  end;

{ IXMLOOSELLMFTypeList }

  IXMLOOSELLMFTypeList = interface(IXMLNodeCollection)
    ['{9C32CC42-5078-4345-880D-362D804FB99E}']
    { Methods & Properties }
    function Add: IXMLOOSELLMFType;
    function Insert(const Index: Integer): IXMLOOSELLMFType;

    function GetItem(Index: Integer): IXMLOOSELLMFType;
    property Items[Index: Integer]: IXMLOOSELLMFType read GetItem; default;
  end;

{ IXMLOOSELLOPTType }

  IXMLOOSELLOPTType = interface(IXMLNode)
    ['{B91E177D-DA69-4B69-A6B7-460FBC6E1554}']
    { Property Accessors }
    function GetOO: IXMLOOType;
    function GetOPTSELLTYPE: UnicodeString;
    procedure SetOPTSELLTYPE(Value: UnicodeString);
    { Methods & Properties }
    property OO: IXMLOOType read GetOO;
    property OPTSELLTYPE: UnicodeString read GetOPTSELLTYPE write SetOPTSELLTYPE;
  end;

{ IXMLOOSELLOPTTypeList }

  IXMLOOSELLOPTTypeList = interface(IXMLNodeCollection)
    ['{90B656D8-65E1-4493-85B7-0168D1A78E06}']
    { Methods & Properties }
    function Add: IXMLOOSELLOPTType;
    function Insert(const Index: Integer): IXMLOOSELLOPTType;

    function GetItem(Index: Integer): IXMLOOSELLOPTType;
    property Items[Index: Integer]: IXMLOOSELLOPTType read GetItem; default;
  end;

{ IXMLOOSELLOTHERType }

  IXMLOOSELLOTHERType = interface(IXMLNode)
    ['{4AE69D2A-D45E-42A7-A568-E6B6F5297076}']
    { Property Accessors }
    function GetOO: IXMLOOType;
    function GetUNITTYPE: UnicodeString;
    procedure SetUNITTYPE(Value: UnicodeString);
    { Methods & Properties }
    property OO: IXMLOOType read GetOO;
    property UNITTYPE: UnicodeString read GetUNITTYPE write SetUNITTYPE;
  end;

{ IXMLOOSELLOTHERTypeList }

  IXMLOOSELLOTHERTypeList = interface(IXMLNodeCollection)
    ['{21CDB793-9F96-492A-9E8C-F97712EDC8B4}']
    { Methods & Properties }
    function Add: IXMLOOSELLOTHERType;
    function Insert(const Index: Integer): IXMLOOSELLOTHERType;

    function GetItem(Index: Integer): IXMLOOSELLOTHERType;
    property Items[Index: Integer]: IXMLOOSELLOTHERType read GetItem; default;
  end;

{ IXMLOOSELLSTOCKType }

  IXMLOOSELLSTOCKType = interface(IXMLNode)
    ['{E8155DA0-6205-4017-AA7B-705DF75C2E57}']
    { Property Accessors }
    function GetOO: IXMLOOType;
    function GetSELLTYPE: UnicodeString;
    procedure SetSELLTYPE(Value: UnicodeString);
    { Methods & Properties }
    property OO: IXMLOOType read GetOO;
    property SELLTYPE: UnicodeString read GetSELLTYPE write SetSELLTYPE;
  end;

{ IXMLOOSELLSTOCKTypeList }

  IXMLOOSELLSTOCKTypeList = interface(IXMLNodeCollection)
    ['{328C0669-C4F1-4F96-95C3-C36A31B511E0}']
    { Methods & Properties }
    function Add: IXMLOOSELLSTOCKType;
    function Insert(const Index: Integer): IXMLOOSELLSTOCKType;

    function GetItem(Index: Integer): IXMLOOSELLSTOCKType;
    property Items[Index: Integer]: IXMLOOSELLSTOCKType read GetItem; default;
  end;

{ IXMLOOSWITCHMFType }

  IXMLOOSWITCHMFType = interface(IXMLNode)
    ['{2B89BE5C-2098-44FF-8842-C51449E17A52}']
    { Property Accessors }
    function GetOO: IXMLOOType;
    function GetSECID: IXMLSECIDType;
    function GetUNITTYPE: UnicodeString;
    function GetSWITCHALL: UnicodeString;
    procedure SetUNITTYPE(Value: UnicodeString);
    procedure SetSWITCHALL(Value: UnicodeString);
    { Methods & Properties }
    property OO: IXMLOOType read GetOO;
    property SECID: IXMLSECIDType read GetSECID;
    property UNITTYPE: UnicodeString read GetUNITTYPE write SetUNITTYPE;
    property SWITCHALL: UnicodeString read GetSWITCHALL write SetSWITCHALL;
  end;

{ IXMLOOSWITCHMFTypeList }

  IXMLOOSWITCHMFTypeList = interface(IXMLNodeCollection)
    ['{DAC22240-0F28-4B5D-97C9-470B6988C56B}']
    { Methods & Properties }
    function Add: IXMLOOSWITCHMFType;
    function Insert(const Index: Integer): IXMLOOSWITCHMFType;

    function GetItem(Index: Integer): IXMLOOSWITCHMFType;
    property Items[Index: Integer]: IXMLOOSWITCHMFType read GetItem; default;
  end;

{ IXMLINVMAILTRNRSType }

  IXMLINVMAILTRNRSType = interface(IXMLNode)
    ['{40B0EA5D-F3CF-4FF2-A749-4F67EF394715}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetINVMAILRS: IXMLINVMAILRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property INVMAILRS: IXMLINVMAILRSType read GetINVMAILRS;
  end;

{ IXMLINVMAILTRNRSTypeList }

  IXMLINVMAILTRNRSTypeList = interface(IXMLNodeCollection)
    ['{60E80183-1F7D-4707-B2EE-2554912DF757}']
    { Methods & Properties }
    function Add: IXMLINVMAILTRNRSType;
    function Insert(const Index: Integer): IXMLINVMAILTRNRSType;

    function GetItem(Index: Integer): IXMLINVMAILTRNRSType;
    property Items[Index: Integer]: IXMLINVMAILTRNRSType read GetItem; default;
  end;

{ IXMLINVMAILRSType }

  IXMLINVMAILRSType = interface(IXMLNode)
    ['{3BC8A3CC-C22A-4F7E-A620-C0B2C2B65487}']
    { Property Accessors }
    function GetINVACCTFROM: IXMLINVACCTFROMType;
    function GetMAIL: IXMLMAILType;
    { Methods & Properties }
    property INVACCTFROM: IXMLINVACCTFROMType read GetINVACCTFROM;
    property MAIL: IXMLMAILType read GetMAIL;
  end;

{ IXMLINVMAILSYNCRSType }

  IXMLINVMAILSYNCRSType = interface(IXMLNode)
    ['{218E3E8D-E909-41BB-BFF0-4CB6142AACB3}']
    { Property Accessors }
    function GetSYNCRSMACRO: UnicodeString;
    function GetINVACCTFROM: IXMLINVACCTFROMType;
    function GetINVMAILTRNRS: IXMLINVMAILTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRSMACRO: UnicodeString read GetSYNCRSMACRO write SetSYNCRSMACRO;
    property INVACCTFROM: IXMLINVACCTFROMType read GetINVACCTFROM;
    property INVMAILTRNRS: IXMLINVMAILTRNRSTypeList read GetINVMAILTRNRS;
  end;

{ IXMLINVMAILSYNCRSTypeList }

  IXMLINVMAILSYNCRSTypeList = interface(IXMLNodeCollection)
    ['{4454F07B-0EE2-4B85-8ACE-A734AEFD1CDF}']
    { Methods & Properties }
    function Add: IXMLINVMAILSYNCRSType;
    function Insert(const Index: Integer): IXMLINVMAILSYNCRSType;

    function GetItem(Index: Integer): IXMLINVMAILSYNCRSType;
    property Items[Index: Integer]: IXMLINVMAILSYNCRSType read GetItem; default;
  end;

{ IXMLSECLISTMSGSRQV1Type }

  IXMLSECLISTMSGSRQV1Type = interface(IXMLNodeCollection)
    ['{B7F13793-C2C1-4FFF-BE46-B0AFAEAC8620}']
    { Property Accessors }
    function GetSECLISTTRNRQ(Index: Integer): IXMLSECLISTTRNRQType;
    { Methods & Properties }
    function Add: IXMLSECLISTTRNRQType;
    function Insert(const Index: Integer): IXMLSECLISTTRNRQType;
    property SECLISTTRNRQ[Index: Integer]: IXMLSECLISTTRNRQType read GetSECLISTTRNRQ; default;
  end;

{ IXMLSECLISTTRNRQType }

  IXMLSECLISTTRNRQType = interface(IXMLNode)
    ['{D16BF5A2-C2C7-48B9-B3AC-C49D04BCB90C}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetSECLISTRQ: IXMLSECLISTRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property SECLISTRQ: IXMLSECLISTRQType read GetSECLISTRQ;
  end;

{ IXMLSECLISTRQType }

  IXMLSECLISTRQType = interface(IXMLNodeCollection)
    ['{B30C1AC4-840B-488A-8D63-5424C8AA6908}']
    { Property Accessors }
    function GetSECRQ(Index: Integer): IXMLSECRQType;
    { Methods & Properties }
    function Add: IXMLSECRQType;
    function Insert(const Index: Integer): IXMLSECRQType;
    property SECRQ[Index: Integer]: IXMLSECRQType read GetSECRQ; default;
  end;

{ IXMLSECRQType }

  IXMLSECRQType = interface(IXMLNode)
    ['{6B33B9D4-C7D0-474D-A36C-0075E3C3294A}']
    { Property Accessors }
    function GetSECID: IXMLSECIDType;
    function GetTICKER: UnicodeString;
    function GetFIID: UnicodeString;
    procedure SetTICKER(Value: UnicodeString);
    procedure SetFIID(Value: UnicodeString);
    { Methods & Properties }
    property SECID: IXMLSECIDType read GetSECID;
    property TICKER: UnicodeString read GetTICKER write SetTICKER;
    property FIID: UnicodeString read GetFIID write SetFIID;
  end;

{ IXMLSECLISTMSGSRSV1Type }

  IXMLSECLISTMSGSRSV1Type = interface(IXMLNode)
    ['{D33727D3-AD6C-40A6-9278-C72F840D69E3}']
    { Property Accessors }
    function GetSECLISTTRNRS: IXMLSECLISTTRNRSTypeList;
    function GetSECLIST: IXMLSECLISTType;
    { Methods & Properties }
    property SECLISTTRNRS: IXMLSECLISTTRNRSTypeList read GetSECLISTTRNRS;
    property SECLIST: IXMLSECLISTType read GetSECLIST;
  end;

{ IXMLSECLISTTRNRSType }

  IXMLSECLISTTRNRSType = interface(IXMLNode)
    ['{9A498E95-DF7E-43BB-B49B-60AE5D5C453D}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetSECLISTRS: UnicodeString;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    procedure SetSECLISTRS(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property SECLISTRS: UnicodeString read GetSECLISTRS write SetSECLISTRS;
  end;

{ IXMLSECLISTTRNRSTypeList }

  IXMLSECLISTTRNRSTypeList = interface(IXMLNodeCollection)
    ['{99AA40EA-1720-4B61-880F-988BEC670DFC}']
    { Methods & Properties }
    function Add: IXMLSECLISTTRNRSType;
    function Insert(const Index: Integer): IXMLSECLISTTRNRSType;

    function GetItem(Index: Integer): IXMLSECLISTTRNRSType;
    property Items[Index: Integer]: IXMLSECLISTTRNRSType read GetItem; default;
  end;

{ IXMLSECLISTType }

  IXMLSECLISTType = interface(IXMLNode)
    ['{4F14E4D7-2FB9-44B5-B458-290530DF1562}']
    { Property Accessors }
    function GetMFINFO: IXMLMFINFOTypeList;
    function GetSTOCKINFO: IXMLSTOCKINFOTypeList;
    function GetOPTINFO: IXMLOPTINFOTypeList;
    function GetDEBTINFO: IXMLDEBTINFOTypeList;
    function GetOTHERINFO: IXMLOTHERINFOTypeList;
    { Methods & Properties }
    property MFINFO: IXMLMFINFOTypeList read GetMFINFO;
    property STOCKINFO: IXMLSTOCKINFOTypeList read GetSTOCKINFO;
    property OPTINFO: IXMLOPTINFOTypeList read GetOPTINFO;
    property DEBTINFO: IXMLDEBTINFOTypeList read GetDEBTINFO;
    property OTHERINFO: IXMLOTHERINFOTypeList read GetOTHERINFO;
  end;

{ IXMLMFINFOType }

  IXMLMFINFOType = interface(IXMLNode)
    ['{31922399-071D-4CBF-9B5C-95FCE04E6A97}']
    { Property Accessors }
    function GetSECINFO: IXMLSECINFOType;
    function GetMFTYPE: UnicodeString;
    function GetYIELD: UnicodeString;
    function GetDTYIELDASOF: UnicodeString;
    function GetMFASSETCLASS: IXMLMFASSETCLASSType;
    function GetFIMFASSETCLASS: IXMLFIMFASSETCLASSType;
    procedure SetMFTYPE(Value: UnicodeString);
    procedure SetYIELD(Value: UnicodeString);
    procedure SetDTYIELDASOF(Value: UnicodeString);
    { Methods & Properties }
    property SECINFO: IXMLSECINFOType read GetSECINFO;
    property MFTYPE: UnicodeString read GetMFTYPE write SetMFTYPE;
    property YIELD: UnicodeString read GetYIELD write SetYIELD;
    property DTYIELDASOF: UnicodeString read GetDTYIELDASOF write SetDTYIELDASOF;
    property MFASSETCLASS: IXMLMFASSETCLASSType read GetMFASSETCLASS;
    property FIMFASSETCLASS: IXMLFIMFASSETCLASSType read GetFIMFASSETCLASS;
  end;

{ IXMLMFINFOTypeList }

  IXMLMFINFOTypeList = interface(IXMLNodeCollection)
    ['{EAFF3BE6-1CBC-4AB0-91F4-1374668DFA39}']
    { Methods & Properties }
    function Add: IXMLMFINFOType;
    function Insert(const Index: Integer): IXMLMFINFOType;

    function GetItem(Index: Integer): IXMLMFINFOType;
    property Items[Index: Integer]: IXMLMFINFOType read GetItem; default;
  end;

{ IXMLSECINFOType }

  IXMLSECINFOType = interface(IXMLNode)
    ['{810B43D0-AAB6-4BC8-8C40-81B608084CC3}']
    { Property Accessors }
    function GetSECID: IXMLSECIDType;
    function GetSECNAME: UnicodeString;
    function GetTICKER: UnicodeString;
    function GetFIID: UnicodeString;
    function GetRATING: UnicodeString;
    function GetUNITPRICE: UnicodeString;
    function GetDTASOF: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetMEMO: UnicodeString;
    procedure SetSECNAME(Value: UnicodeString);
    procedure SetTICKER(Value: UnicodeString);
    procedure SetFIID(Value: UnicodeString);
    procedure SetRATING(Value: UnicodeString);
    procedure SetUNITPRICE(Value: UnicodeString);
    procedure SetDTASOF(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetMEMO(Value: UnicodeString);
    { Methods & Properties }
    property SECID: IXMLSECIDType read GetSECID;
    property SECNAME: UnicodeString read GetSECNAME write SetSECNAME;
    property TICKER: UnicodeString read GetTICKER write SetTICKER;
    property FIID: UnicodeString read GetFIID write SetFIID;
    property RATING: UnicodeString read GetRATING write SetRATING;
    property UNITPRICE: UnicodeString read GetUNITPRICE write SetUNITPRICE;
    property DTASOF: UnicodeString read GetDTASOF write SetDTASOF;
    property CURRENCY: UnicodeString read GetCURRENCY write SetCURRENCY;
    property MEMO: UnicodeString read GetMEMO write SetMEMO;
  end;

{ IXMLMFASSETCLASSType }

  IXMLMFASSETCLASSType = interface(IXMLNodeCollection)
    ['{D928A108-6FDA-4750-BDA5-2E4DED7EF13B}']
    { Property Accessors }
    function GetPORTION(Index: Integer): IXMLPORTIONType;
    { Methods & Properties }
    function Add: IXMLPORTIONType;
    function Insert(const Index: Integer): IXMLPORTIONType;
    property PORTION[Index: Integer]: IXMLPORTIONType read GetPORTION; default;
  end;

{ IXMLPORTIONType }

  IXMLPORTIONType = interface(IXMLNode)
    ['{6784CBB6-46A6-451A-BB16-9A8C0CB46980}']
    { Property Accessors }
    function GetASSETCLASS: UnicodeString;
    function GetPERCENT: UnicodeString;
    procedure SetASSETCLASS(Value: UnicodeString);
    procedure SetPERCENT(Value: UnicodeString);
    { Methods & Properties }
    property ASSETCLASS: UnicodeString read GetASSETCLASS write SetASSETCLASS;
    property PERCENT: UnicodeString read GetPERCENT write SetPERCENT;
  end;

{ IXMLFIMFASSETCLASSType }

  IXMLFIMFASSETCLASSType = interface(IXMLNodeCollection)
    ['{43378EC4-DFEE-4E1C-9DB2-2AB1872EA757}']
    { Property Accessors }
    function GetFIPORTION(Index: Integer): IXMLFIPORTIONType;
    { Methods & Properties }
    function Add: IXMLFIPORTIONType;
    function Insert(const Index: Integer): IXMLFIPORTIONType;
    property FIPORTION[Index: Integer]: IXMLFIPORTIONType read GetFIPORTION; default;
  end;

{ IXMLFIPORTIONType }

  IXMLFIPORTIONType = interface(IXMLNode)
    ['{88EC364D-4507-402D-9AAD-977B50B86D51}']
    { Property Accessors }
    function GetFIASSETCLASS: UnicodeString;
    function GetPERCENT: UnicodeString;
    procedure SetFIASSETCLASS(Value: UnicodeString);
    procedure SetPERCENT(Value: UnicodeString);
    { Methods & Properties }
    property FIASSETCLASS: UnicodeString read GetFIASSETCLASS write SetFIASSETCLASS;
    property PERCENT: UnicodeString read GetPERCENT write SetPERCENT;
  end;

{ IXMLSTOCKINFOType }

  IXMLSTOCKINFOType = interface(IXMLNode)
    ['{C2AEDEBC-A45A-44F5-9414-4CB7A9EF3875}']
    { Property Accessors }
    function GetSECINFO: IXMLSECINFOType;
    function GetSTOCKTYPE: UnicodeString;
    function GetYIELD: UnicodeString;
    function GetDTYIELDASOF: UnicodeString;
    function GetASSETCLASS: UnicodeString;
    function GetFIASSETCLASS: UnicodeString;
    procedure SetSTOCKTYPE(Value: UnicodeString);
    procedure SetYIELD(Value: UnicodeString);
    procedure SetDTYIELDASOF(Value: UnicodeString);
    procedure SetASSETCLASS(Value: UnicodeString);
    procedure SetFIASSETCLASS(Value: UnicodeString);
    { Methods & Properties }
    property SECINFO: IXMLSECINFOType read GetSECINFO;
    property STOCKTYPE: UnicodeString read GetSTOCKTYPE write SetSTOCKTYPE;
    property YIELD: UnicodeString read GetYIELD write SetYIELD;
    property DTYIELDASOF: UnicodeString read GetDTYIELDASOF write SetDTYIELDASOF;
    property ASSETCLASS: UnicodeString read GetASSETCLASS write SetASSETCLASS;
    property FIASSETCLASS: UnicodeString read GetFIASSETCLASS write SetFIASSETCLASS;
  end;

{ IXMLSTOCKINFOTypeList }

  IXMLSTOCKINFOTypeList = interface(IXMLNodeCollection)
    ['{AF308F3A-01FC-4268-BA6C-24D86F5E728B}']
    { Methods & Properties }
    function Add: IXMLSTOCKINFOType;
    function Insert(const Index: Integer): IXMLSTOCKINFOType;

    function GetItem(Index: Integer): IXMLSTOCKINFOType;
    property Items[Index: Integer]: IXMLSTOCKINFOType read GetItem; default;
  end;

{ IXMLOPTINFOType }

  IXMLOPTINFOType = interface(IXMLNode)
    ['{BC20AABB-86A8-42C4-A579-21E0C2CB0CF8}']
    { Property Accessors }
    function GetSECINFO: IXMLSECINFOType;
    function GetOPTTYPE: UnicodeString;
    function GetSTRIKEPRICE: UnicodeString;
    function GetDTEXPIRE: UnicodeString;
    function GetSHPERCTRCT: UnicodeString;
    function GetSECID: IXMLSECIDType;
    function GetASSETCLASS: UnicodeString;
    function GetFIASSETCLASS: UnicodeString;
    procedure SetOPTTYPE(Value: UnicodeString);
    procedure SetSTRIKEPRICE(Value: UnicodeString);
    procedure SetDTEXPIRE(Value: UnicodeString);
    procedure SetSHPERCTRCT(Value: UnicodeString);
    procedure SetASSETCLASS(Value: UnicodeString);
    procedure SetFIASSETCLASS(Value: UnicodeString);
    { Methods & Properties }
    property SECINFO: IXMLSECINFOType read GetSECINFO;
    property OPTTYPE: UnicodeString read GetOPTTYPE write SetOPTTYPE;
    property STRIKEPRICE: UnicodeString read GetSTRIKEPRICE write SetSTRIKEPRICE;
    property DTEXPIRE: UnicodeString read GetDTEXPIRE write SetDTEXPIRE;
    property SHPERCTRCT: UnicodeString read GetSHPERCTRCT write SetSHPERCTRCT;
    property SECID: IXMLSECIDType read GetSECID;
    property ASSETCLASS: UnicodeString read GetASSETCLASS write SetASSETCLASS;
    property FIASSETCLASS: UnicodeString read GetFIASSETCLASS write SetFIASSETCLASS;
  end;

{ IXMLOPTINFOTypeList }

  IXMLOPTINFOTypeList = interface(IXMLNodeCollection)
    ['{786F3639-BEDD-4ADA-9F98-E523F0471C58}']
    { Methods & Properties }
    function Add: IXMLOPTINFOType;
    function Insert(const Index: Integer): IXMLOPTINFOType;

    function GetItem(Index: Integer): IXMLOPTINFOType;
    property Items[Index: Integer]: IXMLOPTINFOType read GetItem; default;
  end;

{ IXMLDEBTINFOType }

  IXMLDEBTINFOType = interface(IXMLNode)
    ['{941D5090-7D52-435C-921D-E4059D376FCB}']
    { Property Accessors }
    function GetSECINFO: IXMLSECINFOType;
    function GetPARVALUE: UnicodeString;
    function GetDEBTTYPE: UnicodeString;
    function GetDEBTCLASS: UnicodeString;
    function GetCOUPONRT: UnicodeString;
    function GetDTCOUPON: UnicodeString;
    function GetCOUPONFREQ: UnicodeString;
    function GetCALLPRICE: UnicodeString;
    function GetYIELDTOCALL: UnicodeString;
    function GetDTCALL: UnicodeString;
    function GetCALLTYPE: UnicodeString;
    function GetYIELDTOMAT: UnicodeString;
    function GetDTMAT: UnicodeString;
    function GetASSETCLASS: UnicodeString;
    function GetFIASSETCLASS: UnicodeString;
    procedure SetPARVALUE(Value: UnicodeString);
    procedure SetDEBTTYPE(Value: UnicodeString);
    procedure SetDEBTCLASS(Value: UnicodeString);
    procedure SetCOUPONRT(Value: UnicodeString);
    procedure SetDTCOUPON(Value: UnicodeString);
    procedure SetCOUPONFREQ(Value: UnicodeString);
    procedure SetCALLPRICE(Value: UnicodeString);
    procedure SetYIELDTOCALL(Value: UnicodeString);
    procedure SetDTCALL(Value: UnicodeString);
    procedure SetCALLTYPE(Value: UnicodeString);
    procedure SetYIELDTOMAT(Value: UnicodeString);
    procedure SetDTMAT(Value: UnicodeString);
    procedure SetASSETCLASS(Value: UnicodeString);
    procedure SetFIASSETCLASS(Value: UnicodeString);
    { Methods & Properties }
    property SECINFO: IXMLSECINFOType read GetSECINFO;
    property PARVALUE: UnicodeString read GetPARVALUE write SetPARVALUE;
    property DEBTTYPE: UnicodeString read GetDEBTTYPE write SetDEBTTYPE;
    property DEBTCLASS: UnicodeString read GetDEBTCLASS write SetDEBTCLASS;
    property COUPONRT: UnicodeString read GetCOUPONRT write SetCOUPONRT;
    property DTCOUPON: UnicodeString read GetDTCOUPON write SetDTCOUPON;
    property COUPONFREQ: UnicodeString read GetCOUPONFREQ write SetCOUPONFREQ;
    property CALLPRICE: UnicodeString read GetCALLPRICE write SetCALLPRICE;
    property YIELDTOCALL: UnicodeString read GetYIELDTOCALL write SetYIELDTOCALL;
    property DTCALL: UnicodeString read GetDTCALL write SetDTCALL;
    property CALLTYPE: UnicodeString read GetCALLTYPE write SetCALLTYPE;
    property YIELDTOMAT: UnicodeString read GetYIELDTOMAT write SetYIELDTOMAT;
    property DTMAT: UnicodeString read GetDTMAT write SetDTMAT;
    property ASSETCLASS: UnicodeString read GetASSETCLASS write SetASSETCLASS;
    property FIASSETCLASS: UnicodeString read GetFIASSETCLASS write SetFIASSETCLASS;
  end;

{ IXMLDEBTINFOTypeList }

  IXMLDEBTINFOTypeList = interface(IXMLNodeCollection)
    ['{8F0C4983-9A12-47F9-93EC-544DE2DD59C5}']
    { Methods & Properties }
    function Add: IXMLDEBTINFOType;
    function Insert(const Index: Integer): IXMLDEBTINFOType;

    function GetItem(Index: Integer): IXMLDEBTINFOType;
    property Items[Index: Integer]: IXMLDEBTINFOType read GetItem; default;
  end;

{ IXMLOTHERINFOType }

  IXMLOTHERINFOType = interface(IXMLNode)
    ['{1546694E-A3ED-41FB-ADB6-E56655E6D3F1}']
    { Property Accessors }
    function GetSECINFO: IXMLSECINFOType;
    function GetTYPEDESC: UnicodeString;
    function GetASSETCLASS: UnicodeString;
    function GetFIASSETCLASS: UnicodeString;
    procedure SetTYPEDESC(Value: UnicodeString);
    procedure SetASSETCLASS(Value: UnicodeString);
    procedure SetFIASSETCLASS(Value: UnicodeString);
    { Methods & Properties }
    property SECINFO: IXMLSECINFOType read GetSECINFO;
    property TYPEDESC: UnicodeString read GetTYPEDESC write SetTYPEDESC;
    property ASSETCLASS: UnicodeString read GetASSETCLASS write SetASSETCLASS;
    property FIASSETCLASS: UnicodeString read GetFIASSETCLASS write SetFIASSETCLASS;
  end;

{ IXMLOTHERINFOTypeList }

  IXMLOTHERINFOTypeList = interface(IXMLNodeCollection)
    ['{89ED755F-E2FB-4B91-A542-111CCF691082}']
    { Methods & Properties }
    function Add: IXMLOTHERINFOType;
    function Insert(const Index: Integer): IXMLOTHERINFOType;

    function GetItem(Index: Integer): IXMLOTHERINFOType;
    property Items[Index: Integer]: IXMLOTHERINFOType read GetItem; default;
  end;

{ IXMLINVACCTTOType }

  IXMLINVACCTTOType = interface(IXMLNode)
    ['{89F55BA8-7498-41D6-A568-7A9C10C00E54}']
    { Property Accessors }
    function GetBROKERID: UnicodeString;
    function GetACCTID: UnicodeString;
    procedure SetBROKERID(Value: UnicodeString);
    procedure SetACCTID(Value: UnicodeString);
    { Methods & Properties }
    property BROKERID: UnicodeString read GetBROKERID write SetBROKERID;
    property ACCTID: UnicodeString read GetACCTID write SetACCTID;
  end;

{ IXMLINVACCTINFOType }

  IXMLINVACCTINFOType = interface(IXMLNode)
    ['{81255039-A21A-4B19-9F2C-F1DD8FB4A9D5}']
    { Property Accessors }
    function GetINVACCTFROM: IXMLINVACCTFROMType;
    function GetUSPRODUCTTYPE: UnicodeString;
    function GetCHECKING: UnicodeString;
    function GetSVCSTATUS: UnicodeString;
    function GetINVACCTTYPE: UnicodeString;
    function GetOPTIONLEVEL: UnicodeString;
    procedure SetUSPRODUCTTYPE(Value: UnicodeString);
    procedure SetCHECKING(Value: UnicodeString);
    procedure SetSVCSTATUS(Value: UnicodeString);
    procedure SetINVACCTTYPE(Value: UnicodeString);
    procedure SetOPTIONLEVEL(Value: UnicodeString);
    { Methods & Properties }
    property INVACCTFROM: IXMLINVACCTFROMType read GetINVACCTFROM;
    property USPRODUCTTYPE: UnicodeString read GetUSPRODUCTTYPE write SetUSPRODUCTTYPE;
    property CHECKING: UnicodeString read GetCHECKING write SetCHECKING;
    property SVCSTATUS: UnicodeString read GetSVCSTATUS write SetSVCSTATUS;
    property INVACCTTYPE: UnicodeString read GetINVACCTTYPE write SetINVACCTTYPE;
    property OPTIONLEVEL: UnicodeString read GetOPTIONLEVEL write SetOPTIONLEVEL;
  end;

{ IXMLINVSTMTMSGSETType }

  IXMLINVSTMTMSGSETType = interface(IXMLNode)
    ['{BD4920A8-A6C8-41DA-8375-30A40DCF34BC}']
    { Property Accessors }
    function GetINVSTMTMSGSETV1: IXMLINVSTMTMSGSETV1Type;
    { Methods & Properties }
    property INVSTMTMSGSETV1: IXMLINVSTMTMSGSETV1Type read GetINVSTMTMSGSETV1;
  end;

{ IXMLINVSTMTMSGSETV1Type }

  IXMLINVSTMTMSGSETV1Type = interface(IXMLNode)
    ['{057C1C6B-F8E8-4245-8E68-84663961F983}']
    { Property Accessors }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetTRANDNLD: UnicodeString;
    function GetOODNLD: UnicodeString;
    function GetPOSDNLD: UnicodeString;
    function GetBALDNLD: UnicodeString;
    function GetCANEMAIL: UnicodeString;
    procedure SetTRANDNLD(Value: UnicodeString);
    procedure SetOODNLD(Value: UnicodeString);
    procedure SetPOSDNLD(Value: UnicodeString);
    procedure SetBALDNLD(Value: UnicodeString);
    procedure SetCANEMAIL(Value: UnicodeString);
    { Methods & Properties }
    property MSGSETCORE: IXMLMSGSETCOREType read GetMSGSETCORE;
    property TRANDNLD: UnicodeString read GetTRANDNLD write SetTRANDNLD;
    property OODNLD: UnicodeString read GetOODNLD write SetOODNLD;
    property POSDNLD: UnicodeString read GetPOSDNLD write SetPOSDNLD;
    property BALDNLD: UnicodeString read GetBALDNLD write SetBALDNLD;
    property CANEMAIL: UnicodeString read GetCANEMAIL write SetCANEMAIL;
  end;

{ IXMLSECLISTMSGSETType }

  IXMLSECLISTMSGSETType = interface(IXMLNode)
    ['{116B23A6-2E6C-4ECE-9D4B-01A00907B606}']
    { Property Accessors }
    function GetSECLISTMSGSETV1: IXMLSECLISTMSGSETV1Type;
    { Methods & Properties }
    property SECLISTMSGSETV1: IXMLSECLISTMSGSETV1Type read GetSECLISTMSGSETV1;
  end;

{ IXMLSECLISTMSGSETV1Type }

  IXMLSECLISTMSGSETV1Type = interface(IXMLNode)
    ['{BE35705D-5F39-4BAF-982C-B9F0FE1F9C23}']
    { Property Accessors }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetSECLISTRQDNLD: UnicodeString;
    procedure SetSECLISTRQDNLD(Value: UnicodeString);
    { Methods & Properties }
    property MSGSETCORE: IXMLMSGSETCOREType read GetMSGSETCORE;
    property SECLISTRQDNLD: UnicodeString read GetSECLISTRQDNLD write SetSECLISTRQDNLD;
  end;

{ IXMLEMAILMSGSRQV1Type }

  IXMLEMAILMSGSRQV1Type = interface(IXMLNode)
    ['{FAD98279-E0CA-4190-87F0-A7BE664E78AC}']
    { Property Accessors }
    function GetMAILTRNRQ: IXMLMAILTRNRQTypeList;
    function GetMAILSYNCRQ: IXMLMAILSYNCRQTypeList;
    function GetGETMIMETRNRQ: IXMLGETMIMETRNRQTypeList;
    { Methods & Properties }
    property MAILTRNRQ: IXMLMAILTRNRQTypeList read GetMAILTRNRQ;
    property MAILSYNCRQ: IXMLMAILSYNCRQTypeList read GetMAILSYNCRQ;
    property GETMIMETRNRQ: IXMLGETMIMETRNRQTypeList read GetGETMIMETRNRQ;
  end;

{ IXMLMAILTRNRQType }

  IXMLMAILTRNRQType = interface(IXMLNode)
    ['{DFF3824D-AA73-4B25-97B6-5E22029B50A8}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetMAILRQ: IXMLMAILRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property MAILRQ: IXMLMAILRQType read GetMAILRQ;
  end;

{ IXMLMAILTRNRQTypeList }

  IXMLMAILTRNRQTypeList = interface(IXMLNodeCollection)
    ['{195E01AD-C3D9-428C-BC83-4C3257C7556A}']
    { Methods & Properties }
    function Add: IXMLMAILTRNRQType;
    function Insert(const Index: Integer): IXMLMAILTRNRQType;

    function GetItem(Index: Integer): IXMLMAILTRNRQType;
    property Items[Index: Integer]: IXMLMAILTRNRQType read GetItem; default;
  end;

{ IXMLMAILRQType }

  IXMLMAILRQType = interface(IXMLNode)
    ['{3FC79E6F-DF49-439A-BD74-2C4C2FEC8B0D}']
    { Property Accessors }
    function GetMAIL: IXMLMAILType;
    { Methods & Properties }
    property MAIL: IXMLMAILType read GetMAIL;
  end;

{ IXMLMAILSYNCRQType }

  IXMLMAILSYNCRQType = interface(IXMLNode)
    ['{DA9833F0-09BE-49A6-B066-B67A8EA1F045}']
    { Property Accessors }
    function GetSYNCRQMACRO: UnicodeString;
    function GetINCIMAGES: UnicodeString;
    function GetUSEHTML: UnicodeString;
    function GetMAILTRNRQ: IXMLMAILTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetINCIMAGES(Value: UnicodeString);
    procedure SetUSEHTML(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRQMACRO: UnicodeString read GetSYNCRQMACRO write SetSYNCRQMACRO;
    property INCIMAGES: UnicodeString read GetINCIMAGES write SetINCIMAGES;
    property USEHTML: UnicodeString read GetUSEHTML write SetUSEHTML;
    property MAILTRNRQ: IXMLMAILTRNRQTypeList read GetMAILTRNRQ;
  end;

{ IXMLMAILSYNCRQTypeList }

  IXMLMAILSYNCRQTypeList = interface(IXMLNodeCollection)
    ['{EC7AA65A-8019-4293-BAD1-557CA972AA0A}']
    { Methods & Properties }
    function Add: IXMLMAILSYNCRQType;
    function Insert(const Index: Integer): IXMLMAILSYNCRQType;

    function GetItem(Index: Integer): IXMLMAILSYNCRQType;
    property Items[Index: Integer]: IXMLMAILSYNCRQType read GetItem; default;
  end;

{ IXMLGETMIMETRNRQType }

  IXMLGETMIMETRNRQType = interface(IXMLNode)
    ['{E73385C4-5B8A-4CEC-8FF9-6C1422FD2535}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetGETMIMERQ: IXMLGETMIMERQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property GETMIMERQ: IXMLGETMIMERQType read GetGETMIMERQ;
  end;

{ IXMLGETMIMETRNRQTypeList }

  IXMLGETMIMETRNRQTypeList = interface(IXMLNodeCollection)
    ['{8F882E44-5234-4CEC-B135-36EB450A3E0A}']
    { Methods & Properties }
    function Add: IXMLGETMIMETRNRQType;
    function Insert(const Index: Integer): IXMLGETMIMETRNRQType;

    function GetItem(Index: Integer): IXMLGETMIMETRNRQType;
    property Items[Index: Integer]: IXMLGETMIMETRNRQType read GetItem; default;
  end;

{ IXMLGETMIMERQType }

  IXMLGETMIMERQType = interface(IXMLNode)
    ['{A48F7DB4-C834-4B8C-B534-FCB229B1A6CB}']
    { Property Accessors }
    function GetURL: UnicodeString;
    procedure SetURL(Value: UnicodeString);
    { Methods & Properties }
    property URL: UnicodeString read GetURL write SetURL;
  end;

{ IXMLEMAILMSGSRSV1Type }

  IXMLEMAILMSGSRSV1Type = interface(IXMLNode)
    ['{04576ACF-3299-4B17-B90D-3D8639593D34}']
    { Property Accessors }
    function GetMAILTRNRS: IXMLMAILTRNRSTypeList;
    function GetMAILSYNCRS: IXMLMAILSYNCRSTypeList;
    function GetGETMIMETRNRS: IXMLGETMIMETRNRSTypeList;
    { Methods & Properties }
    property MAILTRNRS: IXMLMAILTRNRSTypeList read GetMAILTRNRS;
    property MAILSYNCRS: IXMLMAILSYNCRSTypeList read GetMAILSYNCRS;
    property GETMIMETRNRS: IXMLGETMIMETRNRSTypeList read GetGETMIMETRNRS;
  end;

{ IXMLMAILTRNRSType }

  IXMLMAILTRNRSType = interface(IXMLNode)
    ['{0613E8AB-7119-4B6C-AE79-890C0A860F10}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetMAILRS: IXMLMAILRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property MAILRS: IXMLMAILRSType read GetMAILRS;
  end;

{ IXMLMAILTRNRSTypeList }

  IXMLMAILTRNRSTypeList = interface(IXMLNodeCollection)
    ['{AA98F0EF-E788-4093-BBBA-A983EFE0A2E7}']
    { Methods & Properties }
    function Add: IXMLMAILTRNRSType;
    function Insert(const Index: Integer): IXMLMAILTRNRSType;

    function GetItem(Index: Integer): IXMLMAILTRNRSType;
    property Items[Index: Integer]: IXMLMAILTRNRSType read GetItem; default;
  end;

{ IXMLMAILRSType }

  IXMLMAILRSType = interface(IXMLNode)
    ['{E3B74483-0A53-4E58-94D3-0553AC7D27B0}']
    { Property Accessors }
    function GetMAIL: IXMLMAILType;
    { Methods & Properties }
    property MAIL: IXMLMAILType read GetMAIL;
  end;

{ IXMLMAILSYNCRSType }

  IXMLMAILSYNCRSType = interface(IXMLNode)
    ['{D9C450A3-CFBA-4F70-87E3-6F653D22F854}']
    { Property Accessors }
    function GetSYNCRSMACRO: UnicodeString;
    function GetMAILTRNRS: IXMLMAILTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property SYNCRSMACRO: UnicodeString read GetSYNCRSMACRO write SetSYNCRSMACRO;
    property MAILTRNRS: IXMLMAILTRNRSTypeList read GetMAILTRNRS;
  end;

{ IXMLMAILSYNCRSTypeList }

  IXMLMAILSYNCRSTypeList = interface(IXMLNodeCollection)
    ['{D0E9D956-1509-4B46-8143-4C8323C5AA25}']
    { Methods & Properties }
    function Add: IXMLMAILSYNCRSType;
    function Insert(const Index: Integer): IXMLMAILSYNCRSType;

    function GetItem(Index: Integer): IXMLMAILSYNCRSType;
    property Items[Index: Integer]: IXMLMAILSYNCRSType read GetItem; default;
  end;

{ IXMLGETMIMETRNRSType }

  IXMLGETMIMETRNRSType = interface(IXMLNode)
    ['{05AC431A-C551-4ED9-9F9B-1ABD37F91A1A}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetGETMIMERS: IXMLGETMIMERSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property GETMIMERS: IXMLGETMIMERSType read GetGETMIMERS;
  end;

{ IXMLGETMIMETRNRSTypeList }

  IXMLGETMIMETRNRSTypeList = interface(IXMLNodeCollection)
    ['{69C5CBEE-B277-4453-B019-D5EE177CCEB6}']
    { Methods & Properties }
    function Add: IXMLGETMIMETRNRSType;
    function Insert(const Index: Integer): IXMLGETMIMETRNRSType;

    function GetItem(Index: Integer): IXMLGETMIMETRNRSType;
    property Items[Index: Integer]: IXMLGETMIMETRNRSType read GetItem; default;
  end;

{ IXMLGETMIMERSType }

  IXMLGETMIMERSType = interface(IXMLNode)
    ['{5B1E3C1F-5A50-4935-A6A5-191EC2B39771}']
    { Property Accessors }
    function GetURL: UnicodeString;
    procedure SetURL(Value: UnicodeString);
    { Methods & Properties }
    property URL: UnicodeString read GetURL write SetURL;
  end;

{ IXMLEMAILMSGSETType }

  IXMLEMAILMSGSETType = interface(IXMLNode)
    ['{ECC61C59-F3E9-40CA-B9D1-804560D8A52C}']
    { Property Accessors }
    function GetEMAILMSGSETV1: IXMLEMAILMSGSETV1Type;
    { Methods & Properties }
    property EMAILMSGSETV1: IXMLEMAILMSGSETV1Type read GetEMAILMSGSETV1;
  end;

{ IXMLEMAILMSGSETV1Type }

  IXMLEMAILMSGSETV1Type = interface(IXMLNode)
    ['{02762C68-9B16-4361-8F14-A31AE0A88F2E}']
    { Property Accessors }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetMAILSUP: UnicodeString;
    function GetGETMIMESUP: UnicodeString;
    procedure SetMAILSUP(Value: UnicodeString);
    procedure SetGETMIMESUP(Value: UnicodeString);
    { Methods & Properties }
    property MSGSETCORE: IXMLMSGSETCOREType read GetMSGSETCORE;
    property MAILSUP: UnicodeString read GetMAILSUP write SetMAILSUP;
    property GETMIMESUP: UnicodeString read GetGETMIMESUP write SetGETMIMESUP;
  end;

{ IXMLPROFMSGSRQV1Type }

  IXMLPROFMSGSRQV1Type = interface(IXMLNodeCollection)
    ['{E58501C1-34E5-47AB-B880-8CA99A1780DD}']
    { Property Accessors }
    function GetPROFTRNRQ(Index: Integer): IXMLPROFTRNRQType;
    { Methods & Properties }
    function Add: IXMLPROFTRNRQType;
    function Insert(const Index: Integer): IXMLPROFTRNRQType;
    property PROFTRNRQ[Index: Integer]: IXMLPROFTRNRQType read GetPROFTRNRQ; default;
  end;

{ IXMLPROFTRNRQType }

  IXMLPROFTRNRQType = interface(IXMLNode)
    ['{863339DD-78AC-4423-A2BF-46F4C4155471}']
    { Property Accessors }
    function GetTRNRQMACRO: UnicodeString;
    function GetPROFRQ: IXMLPROFRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRQMACRO: UnicodeString read GetTRNRQMACRO write SetTRNRQMACRO;
    property PROFRQ: IXMLPROFRQType read GetPROFRQ;
  end;

{ IXMLPROFRQType }

  IXMLPROFRQType = interface(IXMLNode)
    ['{E076FEF5-9086-4AA8-A153-49316F9B7F86}']
    { Property Accessors }
    function GetCLIENTROUTING: UnicodeString;
    function GetDTPROFUP: UnicodeString;
    procedure SetCLIENTROUTING(Value: UnicodeString);
    procedure SetDTPROFUP(Value: UnicodeString);
    { Methods & Properties }
    property CLIENTROUTING: UnicodeString read GetCLIENTROUTING write SetCLIENTROUTING;
    property DTPROFUP: UnicodeString read GetDTPROFUP write SetDTPROFUP;
  end;

{ IXMLPROFMSGSRSV1Type }

  IXMLPROFMSGSRSV1Type = interface(IXMLNodeCollection)
    ['{90711BF7-83E8-42CE-8DFF-B9A2BE8ACD4A}']
    { Property Accessors }
    function GetPROFTRNRS(Index: Integer): IXMLPROFTRNRSType;
    { Methods & Properties }
    function Add: IXMLPROFTRNRSType;
    function Insert(const Index: Integer): IXMLPROFTRNRSType;
    property PROFTRNRS[Index: Integer]: IXMLPROFTRNRSType read GetPROFTRNRS; default;
  end;

{ IXMLPROFTRNRSType }

  IXMLPROFTRNRSType = interface(IXMLNode)
    ['{57847448-CBED-46F2-B05D-1456DFF4663B}']
    { Property Accessors }
    function GetTRNRSMACRO: UnicodeString;
    function GetPROFRS: IXMLPROFRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    { Methods & Properties }
    property TRNRSMACRO: UnicodeString read GetTRNRSMACRO write SetTRNRSMACRO;
    property PROFRS: IXMLPROFRSType read GetPROFRS;
  end;

{ IXMLPROFRSType }

  IXMLPROFRSType = interface(IXMLNode)
    ['{C2F58FC6-793B-4078-B2FC-4A606589F018}']
    { Property Accessors }
    function GetMSGSETLIST: IXMLMSGSETLISTType;
    function GetSIGNONINFOLIST: IXMLSIGNONINFOLISTType;
    function GetDTPROFUP: UnicodeString;
    function GetFINAME: UnicodeString;
    function GetADDR1: UnicodeString;
    function GetADDR2: UnicodeString;
    function GetADDR3: UnicodeString;
    function GetCITY: UnicodeString;
    function GetSTATE: UnicodeString;
    function GetPOSTALCODE: UnicodeString;
    function GetCOUNTRY: UnicodeString;
    function GetCSPHONE: UnicodeString;
    function GetTSPHONE: UnicodeString;
    function GetFAXPHONE: UnicodeString;
    function GetURL: UnicodeString;
    function GetEMAIL: UnicodeString;
    procedure SetDTPROFUP(Value: UnicodeString);
    procedure SetFINAME(Value: UnicodeString);
    procedure SetADDR1(Value: UnicodeString);
    procedure SetADDR2(Value: UnicodeString);
    procedure SetADDR3(Value: UnicodeString);
    procedure SetCITY(Value: UnicodeString);
    procedure SetSTATE(Value: UnicodeString);
    procedure SetPOSTALCODE(Value: UnicodeString);
    procedure SetCOUNTRY(Value: UnicodeString);
    procedure SetCSPHONE(Value: UnicodeString);
    procedure SetTSPHONE(Value: UnicodeString);
    procedure SetFAXPHONE(Value: UnicodeString);
    procedure SetURL(Value: UnicodeString);
    procedure SetEMAIL(Value: UnicodeString);
    { Methods & Properties }
    property MSGSETLIST: IXMLMSGSETLISTType read GetMSGSETLIST;
    property SIGNONINFOLIST: IXMLSIGNONINFOLISTType read GetSIGNONINFOLIST;
    property DTPROFUP: UnicodeString read GetDTPROFUP write SetDTPROFUP;
    property FINAME: UnicodeString read GetFINAME write SetFINAME;
    property ADDR1: UnicodeString read GetADDR1 write SetADDR1;
    property ADDR2: UnicodeString read GetADDR2 write SetADDR2;
    property ADDR3: UnicodeString read GetADDR3 write SetADDR3;
    property CITY: UnicodeString read GetCITY write SetCITY;
    property STATE: UnicodeString read GetSTATE write SetSTATE;
    property POSTALCODE: UnicodeString read GetPOSTALCODE write SetPOSTALCODE;
    property COUNTRY: UnicodeString read GetCOUNTRY write SetCOUNTRY;
    property CSPHONE: UnicodeString read GetCSPHONE write SetCSPHONE;
    property TSPHONE: UnicodeString read GetTSPHONE write SetTSPHONE;
    property FAXPHONE: UnicodeString read GetFAXPHONE write SetFAXPHONE;
    property URL: UnicodeString read GetURL write SetURL;
    property EMAIL: UnicodeString read GetEMAIL write SetEMAIL;
  end;

{ IXMLMSGSETLISTType }

  IXMLMSGSETLISTType = interface(IXMLNodeCollection)
    ['{C825FEAA-132B-4A06-A64F-A42CFC8B3130}']
    { Property Accessors }
    function GetMSGSETMACRO(Index: Integer): UnicodeString;
    { Methods & Properties }
    function Add(const MSGSETMACRO: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const MSGSETMACRO: UnicodeString): IXMLNode;
    property MSGSETMACRO[Index: Integer]: UnicodeString read GetMSGSETMACRO; default;
  end;

{ IXMLSIGNONINFOLISTType }

  IXMLSIGNONINFOLISTType = interface(IXMLNodeCollection)
    ['{90687C62-7010-4AC2-954F-2F8254A9C1A8}']
    { Property Accessors }
    function GetSIGNONINFO(Index: Integer): IXMLSIGNONINFOType;
    { Methods & Properties }
    function Add: IXMLSIGNONINFOType;
    function Insert(const Index: Integer): IXMLSIGNONINFOType;
    property SIGNONINFO[Index: Integer]: IXMLSIGNONINFOType read GetSIGNONINFO; default;
  end;

{ IXMLSIGNONINFOType }

  IXMLSIGNONINFOType = interface(IXMLNode)
    ['{291E11A5-CFF7-49F8-9343-A7F65908E7DA}']
    { Property Accessors }
    function GetSIGNONREALM: UnicodeString;
    function GetMIN: UnicodeString;
    function GetMAX: UnicodeString;
    function GetCHARTYPE: UnicodeString;
    function GetCASESEN: UnicodeString;
    function GetSPECIAL: UnicodeString;
    function GetSPACES: UnicodeString;
    function GetPINCH: UnicodeString;
    function GetCHGPINFIRST: UnicodeString;
    procedure SetSIGNONREALM(Value: UnicodeString);
    procedure SetMIN(Value: UnicodeString);
    procedure SetMAX(Value: UnicodeString);
    procedure SetCHARTYPE(Value: UnicodeString);
    procedure SetCASESEN(Value: UnicodeString);
    procedure SetSPECIAL(Value: UnicodeString);
    procedure SetSPACES(Value: UnicodeString);
    procedure SetPINCH(Value: UnicodeString);
    procedure SetCHGPINFIRST(Value: UnicodeString);
    { Methods & Properties }
    property SIGNONREALM: UnicodeString read GetSIGNONREALM write SetSIGNONREALM;
    property MIN: UnicodeString read GetMIN write SetMIN;
    property MAX: UnicodeString read GetMAX write SetMAX;
    property CHARTYPE: UnicodeString read GetCHARTYPE write SetCHARTYPE;
    property CASESEN: UnicodeString read GetCASESEN write SetCASESEN;
    property SPECIAL: UnicodeString read GetSPECIAL write SetSPECIAL;
    property SPACES: UnicodeString read GetSPACES write SetSPACES;
    property PINCH: UnicodeString read GetPINCH write SetPINCH;
    property CHGPINFIRST: UnicodeString read GetCHGPINFIRST write SetCHGPINFIRST;
  end;

{ IXMLPROFMSGSETType }

  IXMLPROFMSGSETType = interface(IXMLNode)
    ['{1D724028-0BA9-416A-9D04-C4228D2C6D4E}']
    { Property Accessors }
    function GetPROFMSGSETV1: IXMLPROFMSGSETV1Type;
    { Methods & Properties }
    property PROFMSGSETV1: IXMLPROFMSGSETV1Type read GetPROFMSGSETV1;
  end;

{ IXMLPROFMSGSETV1Type }

  IXMLPROFMSGSETV1Type = interface(IXMLNode)
    ['{5C65923D-EBD9-4C0C-9BE1-2F48935A2F25}']
    { Property Accessors }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    { Methods & Properties }
    property MSGSETCORE: IXMLMSGSETCOREType read GetMSGSETCORE;
  end;

{ IXMLOFXType }

  IXMLOFXType = interface(IXMLNode)
    ['{8E8BD79A-71C4-42D8-9BB9-BDAAB4920BD4}']
  end;

{ IXMLString_List }

  IXMLString_List = interface(IXMLNodeCollection)
    ['{E078CFCC-9B45-43BC-8936-8EF3C261BBD7}']
    { Methods & Properties }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function GetItem(Index: Integer): UnicodeString;
    property Items[Index: Integer]: UnicodeString read GetItem; default;
  end;

{ Forward Decls }

  TXMLSIGNONMSGSRQV1Type = class;
  TXMLSONRQType = class;
  TXMLFIType = class;
  TXMLPINCHTRNRQType = class;
  TXMLPINCHRQType = class;
  TXMLCHALLENGETRNRQType = class;
  TXMLCHALLENGERQType = class;
  TXMLSIGNONMSGSRSV1Type = class;
  TXMLSONRSType = class;
  TXMLSTATUSType = class;
  TXMLPINCHTRNRSType = class;
  TXMLPINCHRSType = class;
  TXMLCHALLENGETRNRSType = class;
  TXMLCHALLENGERSType = class;
  TXMLSIGNONMSGSETType = class;
  TXMLSIGNONMSGSETV1Type = class;
  TXMLMSGSETCOREType = class;
  TXMLBANKMSGSETType = class;
  TXMLBANKMSGSETV1Type = class;
  TXMLXFERPROFType = class;
  TXMLSTPCHKPROFType = class;
  TXMLEMAILPROFType = class;
  TXMLCREDITCARDMSGSETType = class;
  TXMLCREDITCARDMSGSETV1Type = class;
  TXMLINTERXFERMSGSETType = class;
  TXMLINTERXFERMSGSETV1Type = class;
  TXMLWIREXFERMSGSETType = class;
  TXMLWIREXFERMSGSETV1Type = class;
  TXMLBANKMSGSRQV1Type = class;
  TXMLSTMTTRNRQType = class;
  TXMLSTMTTRNRQTypeList = class;
  TXMLSTMTRQType = class;
  TXMLINCTRANType = class;
  TXMLSTMTENDTRNRQType = class;
  TXMLSTMTENDTRNRQTypeList = class;
  TXMLSTMTENDRQType = class;
  TXMLINTRATRNRQType = class;
  TXMLINTRATRNRQTypeList = class;
  TXMLINTRARQType = class;
  TXMLXFERINFOType = class;
  TXMLINTRAMODRQType = class;
  TXMLINTRACANRQType = class;
  TXMLRECINTRATRNRQType = class;
  TXMLRECINTRATRNRQTypeList = class;
  TXMLRECINTRARQType = class;
  TXMLRECURRINSTType = class;
  TXMLRECINTRAMODRQType = class;
  TXMLRECINTRACANRQType = class;
  TXMLSTPCHKTRNRQType = class;
  TXMLSTPCHKTRNRQTypeList = class;
  TXMLSTPCHKRQType = class;
  TXMLCHKRANGEType = class;
  TXMLCHKDESCType = class;
  TXMLBANKMAILTRNRQType = class;
  TXMLBANKMAILTRNRQTypeList = class;
  TXMLBANKMAILRQType = class;
  TXMLMAILType = class;
  TXMLBANKMAILSYNCRQType = class;
  TXMLBANKMAILSYNCRQTypeList = class;
  TXMLSTPCHKSYNCRQType = class;
  TXMLSTPCHKSYNCRQTypeList = class;
  TXMLINTRASYNCRQType = class;
  TXMLINTRASYNCRQTypeList = class;
  TXMLRECINTRASYNCRQType = class;
  TXMLRECINTRASYNCRQTypeList = class;
  TXMLCREDITCARDMSGSRQV1Type = class;
  TXMLCCSTMTTRNRQType = class;
  TXMLCCSTMTTRNRQTypeList = class;
  TXMLCCSTMTRQType = class;
  TXMLCCSTMTENDTRNRQType = class;
  TXMLCCSTMTENDTRNRQTypeList = class;
  TXMLCCSTMTENDRQType = class;
  TXMLINTERXFERMSGSRQV1Type = class;
  TXMLINTERTRNRQType = class;
  TXMLINTERTRNRQTypeList = class;
  TXMLINTERRQType = class;
  TXMLINTERMODRQType = class;
  TXMLINTERCANRQType = class;
  TXMLRECINTERTRNRQType = class;
  TXMLRECINTERTRNRQTypeList = class;
  TXMLRECINTERRQType = class;
  TXMLRECINTERMODRQType = class;
  TXMLRECINTERCANRQType = class;
  TXMLINTERSYNCRQType = class;
  TXMLINTERSYNCRQTypeList = class;
  TXMLRECINTERSYNCRQType = class;
  TXMLRECINTERSYNCRQTypeList = class;
  TXMLWIREXFERMSGSRQV1Type = class;
  TXMLWIRETRNRQType = class;
  TXMLWIRETRNRQTypeList = class;
  TXMLWIRERQType = class;
  TXMLWIREBENEFICIARYType = class;
  TXMLWIREDESTBANKType = class;
  TXMLEXTBANKDESCType = class;
  TXMLWIRECANRQType = class;
  TXMLWIRESYNCRQType = class;
  TXMLWIRESYNCRQTypeList = class;
  TXMLBANKMSGSRSV1Type = class;
  TXMLSTMTTRNRSType = class;
  TXMLSTMTTRNRSTypeList = class;
  TXMLSTMTRSType = class;
  TXMLBANKTRANLISTType = class;
  TXMLSTMTTRNType = class;
  TXMLSTMTTRNTypeList = class;
  TXMLPAYEEType = class;
  TXMLLEDGERBALType = class;
  TXMLAVAILBALType = class;
  TXMLSTMTENDTRNRSType = class;
  TXMLSTMTENDTRNRSTypeList = class;
  TXMLSTMTENDRSType = class;
  TXMLCLOSINGType = class;
  TXMLCLOSINGTypeList = class;
  TXMLINTRATRNRSType = class;
  TXMLINTRATRNRSTypeList = class;
  TXMLINTRARSType = class;
  TXMLXFERPRCSTSType = class;
  TXMLINTRAMODRSType = class;
  TXMLINTRACANRSType = class;
  TXMLRECINTRATRNRSType = class;
  TXMLRECINTRATRNRSTypeList = class;
  TXMLRECINTRARSType = class;
  TXMLRECINTRAMODRSType = class;
  TXMLRECINTRACANRSType = class;
  TXMLSTPCHKTRNRSType = class;
  TXMLSTPCHKTRNRSTypeList = class;
  TXMLSTPCHKRSType = class;
  TXMLSTPCHKNUMType = class;
  TXMLSTPCHKNUMTypeList = class;
  TXMLBANKMAILTRNRSType = class;
  TXMLBANKMAILTRNRSTypeList = class;
  TXMLBANKMAILRSType = class;
  TXMLCHKMAILRSType = class;
  TXMLDEPMAILRSType = class;
  TXMLBANKMAILSYNCRSType = class;
  TXMLBANKMAILSYNCRSTypeList = class;
  TXMLSTPCHKSYNCRSType = class;
  TXMLSTPCHKSYNCRSTypeList = class;
  TXMLINTRASYNCRSType = class;
  TXMLINTRASYNCRSTypeList = class;
  TXMLRECINTRASYNCRSType = class;
  TXMLRECINTRASYNCRSTypeList = class;
  TXMLCREDITCARDMSGSRSV1Type = class;
  TXMLCCSTMTTRNRSType = class;
  TXMLCCSTMTTRNRSTypeList = class;
  TXMLCCSTMTRSType = class;
  TXMLCCSTMTENDTRNRSType = class;
  TXMLCCSTMTENDTRNRSTypeList = class;
  TXMLCCSTMTENDRSType = class;
  TXMLCCCLOSINGType = class;
  TXMLCCCLOSINGTypeList = class;
  TXMLINTERXFERMSGSRSV1Type = class;
  TXMLINTERTRNRSType = class;
  TXMLINTERTRNRSTypeList = class;
  TXMLINTERRSType = class;
  TXMLINTERMODRSType = class;
  TXMLINTERCANRSType = class;
  TXMLRECINTERTRNRSType = class;
  TXMLRECINTERTRNRSTypeList = class;
  TXMLRECINTERRSType = class;
  TXMLRECINTERMODRSType = class;
  TXMLRECINTERCANRSType = class;
  TXMLINTERSYNCRSType = class;
  TXMLINTERSYNCRSTypeList = class;
  TXMLRECINTERSYNCRSType = class;
  TXMLRECINTERSYNCRSTypeList = class;
  TXMLWIREXFERMSGSRSV1Type = class;
  TXMLWIRETRNRSType = class;
  TXMLWIRETRNRSTypeList = class;
  TXMLWIRERSType = class;
  TXMLWIRECANRSType = class;
  TXMLWIRESYNCRSType = class;
  TXMLWIRESYNCRSTypeList = class;
  TXMLBANKACCTINFOType = class;
  TXMLCCACCTINFOType = class;
  TXMLBILLPAYMSGSRQV1Type = class;
  TXMLPAYEETRNRQType = class;
  TXMLPAYEETRNRQTypeList = class;
  TXMLPAYEERQType = class;
  TXMLPAYEEMODRQType = class;
  TXMLPAYEEDELRQType = class;
  TXMLPAYEESYNCRQType = class;
  TXMLPAYEESYNCRQTypeList = class;
  TXMLPMTTRNRQType = class;
  TXMLPMTTRNRQTypeList = class;
  TXMLPMTRQType = class;
  TXMLPMTINFOType = class;
  TXMLEXTDPMTType = class;
  TXMLEXTDPMTTypeList = class;
  TXMLEXTDPMTINVType = class;
  TXMLINVOICEType = class;
  TXMLDISCOUNTType = class;
  TXMLADJUSTMENTType = class;
  TXMLLINEITEMType = class;
  TXMLLINEITEMTypeList = class;
  TXMLPMTMODRQType = class;
  TXMLPMTCANCRQType = class;
  TXMLRECPMTTRNRQType = class;
  TXMLRECPMTTRNRQTypeList = class;
  TXMLRECPMTRQType = class;
  TXMLRECPMTMODRQType = class;
  TXMLRECPMTCANCRQType = class;
  TXMLPMTINQTRNRQType = class;
  TXMLPMTINQTRNRQTypeList = class;
  TXMLPMTINQRQType = class;
  TXMLPMTMAILTRNRQType = class;
  TXMLPMTMAILTRNRQTypeList = class;
  TXMLPMTMAILRQType = class;
  TXMLPMTSYNCRQType = class;
  TXMLPMTSYNCRQTypeList = class;
  TXMLRECPMTSYNCRQType = class;
  TXMLRECPMTSYNCRQTypeList = class;
  TXMLPMTMAILSYNCRQType = class;
  TXMLPMTMAILSYNCRQTypeList = class;
  TXMLBILLPAYMSGSRSV1Type = class;
  TXMLPAYEETRNRSType = class;
  TXMLPAYEETRNRSTypeList = class;
  TXMLPAYEERSType = class;
  TXMLEXTDPAYEEType = class;
  TXMLPAYEEMODRSType = class;
  TXMLPAYEEDELRSType = class;
  TXMLPAYEESYNCRSType = class;
  TXMLPAYEESYNCRSTypeList = class;
  TXMLPMTTRNRSType = class;
  TXMLPMTTRNRSTypeList = class;
  TXMLPMTRSType = class;
  TXMLPMTPRCSTSType = class;
  TXMLPMTMODRSType = class;
  TXMLPMTCANCRSType = class;
  TXMLRECPMTTRNRSType = class;
  TXMLRECPMTTRNRSTypeList = class;
  TXMLRECPMTRSType = class;
  TXMLRECPMTMODRSType = class;
  TXMLRECPMTCANCRSType = class;
  TXMLPMTINQTRNRSType = class;
  TXMLPMTINQTRNRSTypeList = class;
  TXMLPMTINQRSType = class;
  TXMLPMTMAILTRNRSType = class;
  TXMLPMTMAILTRNRSTypeList = class;
  TXMLPMTMAILRSType = class;
  TXMLPMTSYNCRSType = class;
  TXMLPMTSYNCRSTypeList = class;
  TXMLRECPMTSYNCRSType = class;
  TXMLRECPMTSYNCRSTypeList = class;
  TXMLPMTMAILSYNCRSType = class;
  TXMLPMTMAILSYNCRSTypeList = class;
  TXMLBILLPAYMSGSETType = class;
  TXMLBILLPAYMSGSETV1Type = class;
  TXMLBPACCTINFOType = class;
  TXMLSIGNUPMSGSRQV1Type = class;
  TXMLENROLLTRNRQType = class;
  TXMLENROLLTRNRQTypeList = class;
  TXMLENROLLRQType = class;
  TXMLACCTINFOTRNRQType = class;
  TXMLACCTINFOTRNRQTypeList = class;
  TXMLACCTINFORQType = class;
  TXMLCHGUSERINFOTRNRQType = class;
  TXMLCHGUSERINFOTRNRQTypeList = class;
  TXMLCHGUSERINFORQType = class;
  TXMLCHGUSERINFOSYNCRQType = class;
  TXMLCHGUSERINFOSYNCRQTypeList = class;
  TXMLACCTTRNRQType = class;
  TXMLACCTTRNRQTypeList = class;
  TXMLACCTRQType = class;
  TXMLSVCADDType = class;
  TXMLSVCCHGType = class;
  TXMLSVCDELType = class;
  TXMLACCTSYNCRQType = class;
  TXMLACCTSYNCRQTypeList = class;
  TXMLSIGNUPMSGSRSV1Type = class;
  TXMLENROLLTRNRSType = class;
  TXMLENROLLTRNRSTypeList = class;
  TXMLENROLLRSType = class;
  TXMLACCTINFOTRNRSType = class;
  TXMLACCTINFOTRNRSTypeList = class;
  TXMLACCTINFORSType = class;
  TXMLACCTINFOType = class;
  TXMLACCTINFOTypeList = class;
  TXMLCHGUSERINFOTRNRSType = class;
  TXMLCHGUSERINFOTRNRSTypeList = class;
  TXMLCHGUSERINFORSType = class;
  TXMLCHGUSERINFOSYNCRSType = class;
  TXMLCHGUSERINFOSYNCRSTypeList = class;
  TXMLACCTTRNRSType = class;
  TXMLACCTTRNRSTypeList = class;
  TXMLACCTRSType = class;
  TXMLACCTSYNCRSType = class;
  TXMLACCTSYNCRSTypeList = class;
  TXMLSIGNUPMSGSETType = class;
  TXMLSIGNUPMSGSETV1Type = class;
  TXMLCLIENTENROLLType = class;
  TXMLWEBENROLLType = class;
  TXMLOTHERENROLLType = class;
  TXMLINVSTMTMSGSRQV1Type = class;
  TXMLINVSTMTTRNRQType = class;
  TXMLINVSTMTRQType = class;
  TXMLINVACCTFROMType = class;
  TXMLINCPOSType = class;
  TXMLINVMAILTRNRQType = class;
  TXMLINVMAILTRNRQTypeList = class;
  TXMLINVMAILRQType = class;
  TXMLINVMAILSYNCRQType = class;
  TXMLINVMAILSYNCRQTypeList = class;
  TXMLINVSTMTMSGSRSV1Type = class;
  TXMLINVSTMTTRNRSType = class;
  TXMLINVSTMTTRNRSTypeList = class;
  TXMLINVSTMTRSType = class;
  TXMLINVTRANLISTType = class;
  TXMLBUYDEBTType = class;
  TXMLBUYDEBTTypeList = class;
  TXMLINVBUYType = class;
  TXMLINVTRANType = class;
  TXMLSECIDType = class;
  TXMLSUBACCTFUNDType = class;
  TXMLBUYMFType = class;
  TXMLBUYMFTypeList = class;
  TXMLBUYOPTType = class;
  TXMLBUYOPTTypeList = class;
  TXMLBUYOTHERType = class;
  TXMLBUYOTHERTypeList = class;
  TXMLBUYSTOCKType = class;
  TXMLBUYSTOCKTypeList = class;
  TXMLCLOSUREOPTType = class;
  TXMLCLOSUREOPTTypeList = class;
  TXMLINCOMEType = class;
  TXMLINCOMETypeList = class;
  TXMLINVEXPENSEType = class;
  TXMLINVEXPENSETypeList = class;
  TXMLJRNLFUNDType = class;
  TXMLJRNLFUNDTypeList = class;
  TXMLJRNLSECType = class;
  TXMLJRNLSECTypeList = class;
  TXMLMARGININTERESTType = class;
  TXMLMARGININTERESTTypeList = class;
  TXMLREINVESTType = class;
  TXMLREINVESTTypeList = class;
  TXMLRETOFCAPType = class;
  TXMLRETOFCAPTypeList = class;
  TXMLSELLDEBTType = class;
  TXMLSELLDEBTTypeList = class;
  TXMLINVSELLType = class;
  TXMLSELLMFType = class;
  TXMLSELLMFTypeList = class;
  TXMLSELLOPTType = class;
  TXMLSELLOPTTypeList = class;
  TXMLSELLOTHERType = class;
  TXMLSELLOTHERTypeList = class;
  TXMLSELLSTOCKType = class;
  TXMLSELLSTOCKTypeList = class;
  TXMLSPLITType = class;
  TXMLSPLITTypeList = class;
  TXMLTRANSFERType = class;
  TXMLTRANSFERTypeList = class;
  TXMLINVBANKTRANType = class;
  TXMLINVBANKTRANTypeList = class;
  TXMLINVPOSLISTType = class;
  TXMLPOSMFType = class;
  TXMLPOSMFTypeList = class;
  TXMLINVPOSType = class;
  TXMLPOSSTOCKType = class;
  TXMLPOSSTOCKTypeList = class;
  TXMLPOSDEBTType = class;
  TXMLPOSDEBTTypeList = class;
  TXMLPOSOPTType = class;
  TXMLPOSOPTTypeList = class;
  TXMLPOSOTHERType = class;
  TXMLPOSOTHERTypeList = class;
  TXMLINVBALType = class;
  TXMLBALLISTType = class;
  TXMLBALType = class;
  TXMLINVOOLISTType = class;
  TXMLOOBUYDEBTType = class;
  TXMLOOBUYDEBTTypeList = class;
  TXMLOOType = class;
  TXMLOOBUYMFType = class;
  TXMLOOBUYMFTypeList = class;
  TXMLOOBUYOPTType = class;
  TXMLOOBUYOPTTypeList = class;
  TXMLOOBUYOTHERType = class;
  TXMLOOBUYOTHERTypeList = class;
  TXMLOOBUYSTOCKType = class;
  TXMLOOBUYSTOCKTypeList = class;
  TXMLOOSELLDEBTType = class;
  TXMLOOSELLDEBTTypeList = class;
  TXMLOOSELLMFType = class;
  TXMLOOSELLMFTypeList = class;
  TXMLOOSELLOPTType = class;
  TXMLOOSELLOPTTypeList = class;
  TXMLOOSELLOTHERType = class;
  TXMLOOSELLOTHERTypeList = class;
  TXMLOOSELLSTOCKType = class;
  TXMLOOSELLSTOCKTypeList = class;
  TXMLOOSWITCHMFType = class;
  TXMLOOSWITCHMFTypeList = class;
  TXMLINVMAILTRNRSType = class;
  TXMLINVMAILTRNRSTypeList = class;
  TXMLINVMAILRSType = class;
  TXMLINVMAILSYNCRSType = class;
  TXMLINVMAILSYNCRSTypeList = class;
  TXMLSECLISTMSGSRQV1Type = class;
  TXMLSECLISTTRNRQType = class;
  TXMLSECLISTRQType = class;
  TXMLSECRQType = class;
  TXMLSECLISTMSGSRSV1Type = class;
  TXMLSECLISTTRNRSType = class;
  TXMLSECLISTTRNRSTypeList = class;
  TXMLSECLISTType = class;
  TXMLMFINFOType = class;
  TXMLMFINFOTypeList = class;
  TXMLSECINFOType = class;
  TXMLMFASSETCLASSType = class;
  TXMLPORTIONType = class;
  TXMLFIMFASSETCLASSType = class;
  TXMLFIPORTIONType = class;
  TXMLSTOCKINFOType = class;
  TXMLSTOCKINFOTypeList = class;
  TXMLOPTINFOType = class;
  TXMLOPTINFOTypeList = class;
  TXMLDEBTINFOType = class;
  TXMLDEBTINFOTypeList = class;
  TXMLOTHERINFOType = class;
  TXMLOTHERINFOTypeList = class;
  TXMLINVACCTTOType = class;
  TXMLINVACCTINFOType = class;
  TXMLINVSTMTMSGSETType = class;
  TXMLINVSTMTMSGSETV1Type = class;
  TXMLSECLISTMSGSETType = class;
  TXMLSECLISTMSGSETV1Type = class;
  TXMLEMAILMSGSRQV1Type = class;
  TXMLMAILTRNRQType = class;
  TXMLMAILTRNRQTypeList = class;
  TXMLMAILRQType = class;
  TXMLMAILSYNCRQType = class;
  TXMLMAILSYNCRQTypeList = class;
  TXMLGETMIMETRNRQType = class;
  TXMLGETMIMETRNRQTypeList = class;
  TXMLGETMIMERQType = class;
  TXMLEMAILMSGSRSV1Type = class;
  TXMLMAILTRNRSType = class;
  TXMLMAILTRNRSTypeList = class;
  TXMLMAILRSType = class;
  TXMLMAILSYNCRSType = class;
  TXMLMAILSYNCRSTypeList = class;
  TXMLGETMIMETRNRSType = class;
  TXMLGETMIMETRNRSTypeList = class;
  TXMLGETMIMERSType = class;
  TXMLEMAILMSGSETType = class;
  TXMLEMAILMSGSETV1Type = class;
  TXMLPROFMSGSRQV1Type = class;
  TXMLPROFTRNRQType = class;
  TXMLPROFRQType = class;
  TXMLPROFMSGSRSV1Type = class;
  TXMLPROFTRNRSType = class;
  TXMLPROFRSType = class;
  TXMLMSGSETLISTType = class;
  TXMLSIGNONINFOLISTType = class;
  TXMLSIGNONINFOType = class;
  TXMLPROFMSGSETType = class;
  TXMLPROFMSGSETV1Type = class;
  TXMLOFXType = class;
  TXMLString_List = class;

{ TXMLSIGNONMSGSRQV1Type }

  TXMLSIGNONMSGSRQV1Type = class(TXMLNode, IXMLSIGNONMSGSRQV1Type)
  protected
    { IXMLSIGNONMSGSRQV1Type }
    function GetSONRQ: IXMLSONRQType;
    function GetPINCHTRNRQ: IXMLPINCHTRNRQType;
    function GetCHALLENGETRNRQ: IXMLCHALLENGETRNRQType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSONRQType }

  TXMLSONRQType = class(TXMLNode, IXMLSONRQType)
  protected
    { IXMLSONRQType }
    function GetDTCLIENT: UnicodeString;
    function GetUSERID: UnicodeString;
    function GetUSERPASS: UnicodeString;
    function GetUSERKEY: UnicodeString;
    function GetGENUSERKEY: UnicodeString;
    function GetLANGUAGE: UnicodeString;
    function GetFI: IXMLFIType;
    function GetSESSCOOKIE: UnicodeString;
    function GetAPPID: UnicodeString;
    function GetAPPVER: UnicodeString;
    procedure SetDTCLIENT(Value: UnicodeString);
    procedure SetUSERID(Value: UnicodeString);
    procedure SetUSERPASS(Value: UnicodeString);
    procedure SetUSERKEY(Value: UnicodeString);
    procedure SetGENUSERKEY(Value: UnicodeString);
    procedure SetLANGUAGE(Value: UnicodeString);
    procedure SetSESSCOOKIE(Value: UnicodeString);
    procedure SetAPPID(Value: UnicodeString);
    procedure SetAPPVER(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLFIType }

  TXMLFIType = class(TXMLNode, IXMLFIType)
  protected
    { IXMLFIType }
    function GetORG: UnicodeString;
    function GetFID: UnicodeString;
    procedure SetORG(Value: UnicodeString);
    procedure SetFID(Value: UnicodeString);
  end;

{ TXMLPINCHTRNRQType }

  TXMLPINCHTRNRQType = class(TXMLNode, IXMLPINCHTRNRQType)
  protected
    { IXMLPINCHTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetPINCHRQ: IXMLPINCHRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPINCHRQType }

  TXMLPINCHRQType = class(TXMLNode, IXMLPINCHRQType)
  protected
    { IXMLPINCHRQType }
    function GetUSERID: UnicodeString;
    function GetNEWUSERPASS: UnicodeString;
    procedure SetUSERID(Value: UnicodeString);
    procedure SetNEWUSERPASS(Value: UnicodeString);
  end;

{ TXMLCHALLENGETRNRQType }

  TXMLCHALLENGETRNRQType = class(TXMLNode, IXMLCHALLENGETRNRQType)
  protected
    { IXMLCHALLENGETRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetCHALLENGERQ: IXMLCHALLENGERQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCHALLENGERQType }

  TXMLCHALLENGERQType = class(TXMLNode, IXMLCHALLENGERQType)
  protected
    { IXMLCHALLENGERQType }
    function GetUSERID: UnicodeString;
    function GetFICERTID: UnicodeString;
    procedure SetUSERID(Value: UnicodeString);
    procedure SetFICERTID(Value: UnicodeString);
  end;

{ TXMLSIGNONMSGSRSV1Type }

  TXMLSIGNONMSGSRSV1Type = class(TXMLNode, IXMLSIGNONMSGSRSV1Type)
  protected
    { IXMLSIGNONMSGSRSV1Type }
    function GetSONRS: IXMLSONRSType;
    function GetPINCHTRNRS: IXMLPINCHTRNRSType;
    function GetCHALLENGETRNRS: IXMLCHALLENGETRNRSType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSONRSType }

  TXMLSONRSType = class(TXMLNode, IXMLSONRSType)
  protected
    { IXMLSONRSType }
    function GetSTATUS: IXMLSTATUSType;
    function GetDTSERVER: UnicodeString;
    function GetUSERKEY: UnicodeString;
    function GetTSKEYEXPIRE: UnicodeString;
    function GetLANGUAGE: UnicodeString;
    function GetDTPROFUP: UnicodeString;
    function GetDTACCTUP: UnicodeString;
    function GetFI: IXMLFIType;
    function GetSESSCOOKIE: UnicodeString;
    procedure SetDTSERVER(Value: UnicodeString);
    procedure SetUSERKEY(Value: UnicodeString);
    procedure SetTSKEYEXPIRE(Value: UnicodeString);
    procedure SetLANGUAGE(Value: UnicodeString);
    procedure SetDTPROFUP(Value: UnicodeString);
    procedure SetDTACCTUP(Value: UnicodeString);
    procedure SetSESSCOOKIE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSTATUSType }

  TXMLSTATUSType = class(TXMLNode, IXMLSTATUSType)
  protected
    { IXMLSTATUSType }
    function GetCODE: UnicodeString;
    function GetSEVERITY: UnicodeString;
    function GetMESSAGE: UnicodeString;
    procedure SetCODE(Value: UnicodeString);
    procedure SetSEVERITY(Value: UnicodeString);
    procedure SetMESSAGE(Value: UnicodeString);
  end;

{ TXMLPINCHTRNRSType }

  TXMLPINCHTRNRSType = class(TXMLNode, IXMLPINCHTRNRSType)
  protected
    { IXMLPINCHTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetPINCHRS: IXMLPINCHRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPINCHRSType }

  TXMLPINCHRSType = class(TXMLNode, IXMLPINCHRSType)
  protected
    { IXMLPINCHRSType }
    function GetUSERID: UnicodeString;
    function GetDTCHANGED: UnicodeString;
    procedure SetUSERID(Value: UnicodeString);
    procedure SetDTCHANGED(Value: UnicodeString);
  end;

{ TXMLCHALLENGETRNRSType }

  TXMLCHALLENGETRNRSType = class(TXMLNode, IXMLCHALLENGETRNRSType)
  protected
    { IXMLCHALLENGETRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetCHALLENGERS: IXMLCHALLENGERSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCHALLENGERSType }

  TXMLCHALLENGERSType = class(TXMLNode, IXMLCHALLENGERSType)
  protected
    { IXMLCHALLENGERSType }
    function GetUSERID: UnicodeString;
    function GetNONCE: UnicodeString;
    function GetFICERTID: UnicodeString;
    procedure SetUSERID(Value: UnicodeString);
    procedure SetNONCE(Value: UnicodeString);
    procedure SetFICERTID(Value: UnicodeString);
  end;

{ TXMLSIGNONMSGSETType }

  TXMLSIGNONMSGSETType = class(TXMLNode, IXMLSIGNONMSGSETType)
  protected
    { IXMLSIGNONMSGSETType }
    function GetSIGNONMSGSETV1: IXMLSIGNONMSGSETV1Type;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSIGNONMSGSETV1Type }

  TXMLSIGNONMSGSETV1Type = class(TXMLNode, IXMLSIGNONMSGSETV1Type)
  protected
    { IXMLSIGNONMSGSETV1Type }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMSGSETCOREType }

  TXMLMSGSETCOREType = class(TXMLNode, IXMLMSGSETCOREType)
  private
    FLANGUAGE: IXMLString_List;
  protected
    { IXMLMSGSETCOREType }
    function GetVER: UnicodeString;
    function GetURL: UnicodeString;
    function GetOFXSEC: UnicodeString;
    function GetTRANSPSEC: UnicodeString;
    function GetSIGNONREALM: UnicodeString;
    function GetLANGUAGE: IXMLString_List;
    function GetSYNCMODE: UnicodeString;
    function GetRESPFILEER: UnicodeString;
    function GetSPNAME: UnicodeString;
    procedure SetVER(Value: UnicodeString);
    procedure SetURL(Value: UnicodeString);
    procedure SetOFXSEC(Value: UnicodeString);
    procedure SetTRANSPSEC(Value: UnicodeString);
    procedure SetSIGNONREALM(Value: UnicodeString);
    procedure SetSYNCMODE(Value: UnicodeString);
    procedure SetRESPFILEER(Value: UnicodeString);
    procedure SetSPNAME(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBANKMSGSETType }

  TXMLBANKMSGSETType = class(TXMLNode, IXMLBANKMSGSETType)
  protected
    { IXMLBANKMSGSETType }
    function GetBANKMSGSETV1: IXMLBANKMSGSETV1Type;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBANKMSGSETV1Type }

  TXMLBANKMSGSETV1Type = class(TXMLNode, IXMLBANKMSGSETV1Type)
  private
    FINVALIDACCTTYPE: IXMLString_List;
  protected
    { IXMLBANKMSGSETV1Type }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetINVALIDACCTTYPE: IXMLString_List;
    function GetCLOSINGAVAIL: UnicodeString;
    function GetXFERPROF: IXMLXFERPROFType;
    function GetSTPCHKPROF: IXMLSTPCHKPROFType;
    function GetEMAILPROF: IXMLEMAILPROFType;
    procedure SetCLOSINGAVAIL(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLXFERPROFType }

  TXMLXFERPROFType = class(TXMLNode, IXMLXFERPROFType)
  private
    FPROCDAYSOFF: IXMLString_List;
  protected
    { IXMLXFERPROFType }
    function GetPROCDAYSOFF: IXMLString_List;
    function GetPROCENDTM: UnicodeString;
    function GetCANSCHED: UnicodeString;
    function GetCANRECUR: UnicodeString;
    function GetCANMODXFERS: UnicodeString;
    function GetCANMODMDLS: UnicodeString;
    function GetMODELWND: UnicodeString;
    function GetDAYSWITH: UnicodeString;
    function GetDFLTDAYSTOPAY: UnicodeString;
    procedure SetPROCENDTM(Value: UnicodeString);
    procedure SetCANSCHED(Value: UnicodeString);
    procedure SetCANRECUR(Value: UnicodeString);
    procedure SetCANMODXFERS(Value: UnicodeString);
    procedure SetCANMODMDLS(Value: UnicodeString);
    procedure SetMODELWND(Value: UnicodeString);
    procedure SetDAYSWITH(Value: UnicodeString);
    procedure SetDFLTDAYSTOPAY(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSTPCHKPROFType }

  TXMLSTPCHKPROFType = class(TXMLNode, IXMLSTPCHKPROFType)
  private
    FPROCDAYSOFF: IXMLString_List;
  protected
    { IXMLSTPCHKPROFType }
    function GetPROCDAYSOFF: IXMLString_List;
    function GetPROCENDTM: UnicodeString;
    function GetCANUSERANGE: UnicodeString;
    function GetCANUSEDESC: UnicodeString;
    function GetSTPCHKFEE: UnicodeString;
    procedure SetPROCENDTM(Value: UnicodeString);
    procedure SetCANUSERANGE(Value: UnicodeString);
    procedure SetCANUSEDESC(Value: UnicodeString);
    procedure SetSTPCHKFEE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLEMAILPROFType }

  TXMLEMAILPROFType = class(TXMLNode, IXMLEMAILPROFType)
  protected
    { IXMLEMAILPROFType }
    function GetCANEMAIL: UnicodeString;
    function GetCANNOTIFY: UnicodeString;
    procedure SetCANEMAIL(Value: UnicodeString);
    procedure SetCANNOTIFY(Value: UnicodeString);
  end;

{ TXMLCREDITCARDMSGSETType }

  TXMLCREDITCARDMSGSETType = class(TXMLNode, IXMLCREDITCARDMSGSETType)
  protected
    { IXMLCREDITCARDMSGSETType }
    function GetCREDITCARDMSGSETV1: IXMLCREDITCARDMSGSETV1Type;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCREDITCARDMSGSETV1Type }

  TXMLCREDITCARDMSGSETV1Type = class(TXMLNode, IXMLCREDITCARDMSGSETV1Type)
  protected
    { IXMLCREDITCARDMSGSETV1Type }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetCLOSINGAVAIL: UnicodeString;
    procedure SetCLOSINGAVAIL(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTERXFERMSGSETType }

  TXMLINTERXFERMSGSETType = class(TXMLNode, IXMLINTERXFERMSGSETType)
  protected
    { IXMLINTERXFERMSGSETType }
    function GetINTERXFERMSGSETV1: IXMLINTERXFERMSGSETV1Type;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTERXFERMSGSETV1Type }

  TXMLINTERXFERMSGSETV1Type = class(TXMLNode, IXMLINTERXFERMSGSETV1Type)
  protected
    { IXMLINTERXFERMSGSETV1Type }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetXFERPROF: IXMLXFERPROFType;
    function GetCANBILLPAY: UnicodeString;
    function GetCANCELWND: UnicodeString;
    function GetDOMXFERFEE: UnicodeString;
    function GetINTLXFERFEE: UnicodeString;
    procedure SetCANBILLPAY(Value: UnicodeString);
    procedure SetCANCELWND(Value: UnicodeString);
    procedure SetDOMXFERFEE(Value: UnicodeString);
    procedure SetINTLXFERFEE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLWIREXFERMSGSETType }

  TXMLWIREXFERMSGSETType = class(TXMLNode, IXMLWIREXFERMSGSETType)
  protected
    { IXMLWIREXFERMSGSETType }
    function GetWIREXFERMSGSETV1: IXMLWIREXFERMSGSETV1Type;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLWIREXFERMSGSETV1Type }

  TXMLWIREXFERMSGSETV1Type = class(TXMLNode, IXMLWIREXFERMSGSETV1Type)
  private
    FPROCDAYSOFF: IXMLString_List;
  protected
    { IXMLWIREXFERMSGSETV1Type }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetPROCDAYSOFF: IXMLString_List;
    function GetPROCENDTM: UnicodeString;
    function GetCANSCHED: UnicodeString;
    function GetDOMXFERFEE: UnicodeString;
    function GetINTLXFERFEE: UnicodeString;
    procedure SetPROCENDTM(Value: UnicodeString);
    procedure SetCANSCHED(Value: UnicodeString);
    procedure SetDOMXFERFEE(Value: UnicodeString);
    procedure SetINTLXFERFEE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBANKMSGSRQV1Type }

  TXMLBANKMSGSRQV1Type = class(TXMLNode, IXMLBANKMSGSRQV1Type)
  private
    FSTMTTRNRQ: IXMLSTMTTRNRQTypeList;
    FSTMTENDTRNRQ: IXMLSTMTENDTRNRQTypeList;
    FINTRATRNRQ: IXMLINTRATRNRQTypeList;
    FRECINTRATRNRQ: IXMLRECINTRATRNRQTypeList;
    FSTPCHKTRNRQ: IXMLSTPCHKTRNRQTypeList;
    FBANKMAILTRNRQ: IXMLBANKMAILTRNRQTypeList;
    FBANKMAILSYNCRQ: IXMLBANKMAILSYNCRQTypeList;
    FSTPCHKSYNCRQ: IXMLSTPCHKSYNCRQTypeList;
    FINTRASYNCRQ: IXMLINTRASYNCRQTypeList;
    FRECINTRASYNCRQ: IXMLRECINTRASYNCRQTypeList;
  protected
    { IXMLBANKMSGSRQV1Type }
    function GetSTMTTRNRQ: IXMLSTMTTRNRQTypeList;
    function GetSTMTENDTRNRQ: IXMLSTMTENDTRNRQTypeList;
    function GetINTRATRNRQ: IXMLINTRATRNRQTypeList;
    function GetRECINTRATRNRQ: IXMLRECINTRATRNRQTypeList;
    function GetSTPCHKTRNRQ: IXMLSTPCHKTRNRQTypeList;
    function GetBANKMAILTRNRQ: IXMLBANKMAILTRNRQTypeList;
    function GetBANKMAILSYNCRQ: IXMLBANKMAILSYNCRQTypeList;
    function GetSTPCHKSYNCRQ: IXMLSTPCHKSYNCRQTypeList;
    function GetINTRASYNCRQ: IXMLINTRASYNCRQTypeList;
    function GetRECINTRASYNCRQ: IXMLRECINTRASYNCRQTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSTMTTRNRQType }

  TXMLSTMTTRNRQType = class(TXMLNode, IXMLSTMTTRNRQType)
  protected
    { IXMLSTMTTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetSTMTRQ: IXMLSTMTRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSTMTTRNRQTypeList }

  TXMLSTMTTRNRQTypeList = class(TXMLNodeCollection, IXMLSTMTTRNRQTypeList)
  protected
    { IXMLSTMTTRNRQTypeList }
    function Add: IXMLSTMTTRNRQType;
    function Insert(const Index: Integer): IXMLSTMTTRNRQType;

    function GetItem(Index: Integer): IXMLSTMTTRNRQType;
  end;

{ TXMLSTMTRQType }

  TXMLSTMTRQType = class(TXMLNode, IXMLSTMTRQType)
  protected
    { IXMLSTMTRQType }
    function GetBANKACCTFROM: UnicodeString;
    function GetINCTRAN: IXMLINCTRANType;
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINCTRANType }

  TXMLINCTRANType = class(TXMLNode, IXMLINCTRANType)
  protected
    { IXMLINCTRANType }
    function GetDTSTART: UnicodeString;
    function GetDTEND: UnicodeString;
    function GetINCLUDE: UnicodeString;
    procedure SetDTSTART(Value: UnicodeString);
    procedure SetDTEND(Value: UnicodeString);
    procedure SetINCLUDE(Value: UnicodeString);
  end;

{ TXMLSTMTENDTRNRQType }

  TXMLSTMTENDTRNRQType = class(TXMLNode, IXMLSTMTENDTRNRQType)
  protected
    { IXMLSTMTENDTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetSTMTENDRQ: IXMLSTMTENDRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSTMTENDTRNRQTypeList }

  TXMLSTMTENDTRNRQTypeList = class(TXMLNodeCollection, IXMLSTMTENDTRNRQTypeList)
  protected
    { IXMLSTMTENDTRNRQTypeList }
    function Add: IXMLSTMTENDTRNRQType;
    function Insert(const Index: Integer): IXMLSTMTENDTRNRQType;

    function GetItem(Index: Integer): IXMLSTMTENDTRNRQType;
  end;

{ TXMLSTMTENDRQType }

  TXMLSTMTENDRQType = class(TXMLNode, IXMLSTMTENDRQType)
  protected
    { IXMLSTMTENDRQType }
    function GetBANKACCTFROM: UnicodeString;
    function GetDTSTART: UnicodeString;
    function GetDTEND: UnicodeString;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetDTSTART(Value: UnicodeString);
    procedure SetDTEND(Value: UnicodeString);
  end;

{ TXMLINTRATRNRQType }

  TXMLINTRATRNRQType = class(TXMLNode, IXMLINTRATRNRQType)
  protected
    { IXMLINTRATRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetINTRARQ: IXMLINTRARQType;
    function GetINTRAMODRQ: IXMLINTRAMODRQType;
    function GetINTRACANRQ: IXMLINTRACANRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTRATRNRQTypeList }

  TXMLINTRATRNRQTypeList = class(TXMLNodeCollection, IXMLINTRATRNRQTypeList)
  protected
    { IXMLINTRATRNRQTypeList }
    function Add: IXMLINTRATRNRQType;
    function Insert(const Index: Integer): IXMLINTRATRNRQType;

    function GetItem(Index: Integer): IXMLINTRATRNRQType;
  end;

{ TXMLINTRARQType }

  TXMLINTRARQType = class(TXMLNode, IXMLINTRARQType)
  protected
    { IXMLINTRARQType }
    function GetXFERINFO: IXMLXFERINFOType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLXFERINFOType }

  TXMLXFERINFOType = class(TXMLNode, IXMLXFERINFOType)
  protected
    { IXMLXFERINFOType }
    function GetBANKACCTFROM: UnicodeString;
    function GetCCACCTFROM: UnicodeString;
    function GetBANKACCTTO: UnicodeString;
    function GetCCACCTTO: UnicodeString;
    function GetTRNAMT: UnicodeString;
    function GetDTDUE: UnicodeString;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetCCACCTFROM(Value: UnicodeString);
    procedure SetBANKACCTTO(Value: UnicodeString);
    procedure SetCCACCTTO(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
    procedure SetDTDUE(Value: UnicodeString);
  end;

{ TXMLINTRAMODRQType }

  TXMLINTRAMODRQType = class(TXMLNode, IXMLINTRAMODRQType)
  protected
    { IXMLINTRAMODRQType }
    function GetSRVRTID: UnicodeString;
    function GetXFERINFO: IXMLXFERINFOType;
    procedure SetSRVRTID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTRACANRQType }

  TXMLINTRACANRQType = class(TXMLNode, IXMLINTRACANRQType)
  protected
    { IXMLINTRACANRQType }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
  end;

{ TXMLRECINTRATRNRQType }

  TXMLRECINTRATRNRQType = class(TXMLNode, IXMLRECINTRATRNRQType)
  protected
    { IXMLRECINTRATRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetRECINTRARQ: IXMLRECINTRARQType;
    function GetRECINTRAMODRQ: IXMLRECINTRAMODRQType;
    function GetRECINTRACANRQ: IXMLRECINTRACANRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECINTRATRNRQTypeList }

  TXMLRECINTRATRNRQTypeList = class(TXMLNodeCollection, IXMLRECINTRATRNRQTypeList)
  protected
    { IXMLRECINTRATRNRQTypeList }
    function Add: IXMLRECINTRATRNRQType;
    function Insert(const Index: Integer): IXMLRECINTRATRNRQType;

    function GetItem(Index: Integer): IXMLRECINTRATRNRQType;
  end;

{ TXMLRECINTRARQType }

  TXMLRECINTRARQType = class(TXMLNode, IXMLRECINTRARQType)
  protected
    { IXMLRECINTRARQType }
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetINTRARQ: IXMLINTRARQType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECURRINSTType }

  TXMLRECURRINSTType = class(TXMLNode, IXMLRECURRINSTType)
  protected
    { IXMLRECURRINSTType }
    function GetNINSTS: UnicodeString;
    function GetFREQ: UnicodeString;
    procedure SetNINSTS(Value: UnicodeString);
    procedure SetFREQ(Value: UnicodeString);
  end;

{ TXMLRECINTRAMODRQType }

  TXMLRECINTRAMODRQType = class(TXMLNode, IXMLRECINTRAMODRQType)
  protected
    { IXMLRECINTRAMODRQType }
    function GetRECSRVRTID: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetINTRARQ: IXMLINTRARQType;
    function GetMODPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetMODPENDING(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECINTRACANRQType }

  TXMLRECINTRACANRQType = class(TXMLNode, IXMLRECINTRACANRQType)
  protected
    { IXMLRECINTRACANRQType }
    function GetRECSRVRTID: UnicodeString;
    function GetCANPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetCANPENDING(Value: UnicodeString);
  end;

{ TXMLSTPCHKTRNRQType }

  TXMLSTPCHKTRNRQType = class(TXMLNode, IXMLSTPCHKTRNRQType)
  protected
    { IXMLSTPCHKTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetSTPCHKRQ: IXMLSTPCHKRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSTPCHKTRNRQTypeList }

  TXMLSTPCHKTRNRQTypeList = class(TXMLNodeCollection, IXMLSTPCHKTRNRQTypeList)
  protected
    { IXMLSTPCHKTRNRQTypeList }
    function Add: IXMLSTPCHKTRNRQType;
    function Insert(const Index: Integer): IXMLSTPCHKTRNRQType;

    function GetItem(Index: Integer): IXMLSTPCHKTRNRQType;
  end;

{ TXMLSTPCHKRQType }

  TXMLSTPCHKRQType = class(TXMLNode, IXMLSTPCHKRQType)
  protected
    { IXMLSTPCHKRQType }
    function GetBANKACCTFROM: UnicodeString;
    function GetCHKRANGE: IXMLCHKRANGEType;
    function GetCHKDESC: IXMLCHKDESCType;
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCHKRANGEType }

  TXMLCHKRANGEType = class(TXMLNode, IXMLCHKRANGEType)
  protected
    { IXMLCHKRANGEType }
    function GetCHKNUMSTART: UnicodeString;
    function GetCHKNUMEND: UnicodeString;
    procedure SetCHKNUMSTART(Value: UnicodeString);
    procedure SetCHKNUMEND(Value: UnicodeString);
  end;

{ TXMLCHKDESCType }

  TXMLCHKDESCType = class(TXMLNode, IXMLCHKDESCType)
  protected
    { IXMLCHKDESCType }
    function GetNAME: UnicodeString;
    function GetCHECKNUM: UnicodeString;
    function GetDTUSER: UnicodeString;
    function GetTRNAMT: UnicodeString;
    procedure SetNAME(Value: UnicodeString);
    procedure SetCHECKNUM(Value: UnicodeString);
    procedure SetDTUSER(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
  end;

{ TXMLBANKMAILTRNRQType }

  TXMLBANKMAILTRNRQType = class(TXMLNode, IXMLBANKMAILTRNRQType)
  protected
    { IXMLBANKMAILTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetBANKMAILRQ: IXMLBANKMAILRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBANKMAILTRNRQTypeList }

  TXMLBANKMAILTRNRQTypeList = class(TXMLNodeCollection, IXMLBANKMAILTRNRQTypeList)
  protected
    { IXMLBANKMAILTRNRQTypeList }
    function Add: IXMLBANKMAILTRNRQType;
    function Insert(const Index: Integer): IXMLBANKMAILTRNRQType;

    function GetItem(Index: Integer): IXMLBANKMAILTRNRQType;
  end;

{ TXMLBANKMAILRQType }

  TXMLBANKMAILRQType = class(TXMLNode, IXMLBANKMAILRQType)
  protected
    { IXMLBANKMAILRQType }
    function GetBANKACCTFROM: UnicodeString;
    function GetCCACCTFROM: UnicodeString;
    function GetMAIL: IXMLMAILType;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetCCACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMAILType }

  TXMLMAILType = class(TXMLNode, IXMLMAILType)
  protected
    { IXMLMAILType }
    function GetUSERID: UnicodeString;
    function GetDTCREATED: UnicodeString;
    function GetFROM: UnicodeString;
    function GetTO_: UnicodeString;
    function GetSUBJECT: UnicodeString;
    function GetMSGBODY: UnicodeString;
    function GetINCIMAGES: UnicodeString;
    function GetUSEHTML: UnicodeString;
    procedure SetUSERID(Value: UnicodeString);
    procedure SetDTCREATED(Value: UnicodeString);
    procedure SetFROM(Value: UnicodeString);
    procedure SetTO_(Value: UnicodeString);
    procedure SetSUBJECT(Value: UnicodeString);
    procedure SetMSGBODY(Value: UnicodeString);
    procedure SetINCIMAGES(Value: UnicodeString);
    procedure SetUSEHTML(Value: UnicodeString);
  end;

{ TXMLBANKMAILSYNCRQType }

  TXMLBANKMAILSYNCRQType = class(TXMLNode, IXMLBANKMAILSYNCRQType)
  private
    FBANKMAILTRNRQ: IXMLBANKMAILTRNRQTypeList;
  protected
    { IXMLBANKMAILSYNCRQType }
    function GetSYNCRQMACRO: UnicodeString;
    function GetINCIMAGES: UnicodeString;
    function GetUSEHTML: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetCCACCTFROM: UnicodeString;
    function GetBANKMAILTRNRQ: IXMLBANKMAILTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetINCIMAGES(Value: UnicodeString);
    procedure SetUSEHTML(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetCCACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBANKMAILSYNCRQTypeList }

  TXMLBANKMAILSYNCRQTypeList = class(TXMLNodeCollection, IXMLBANKMAILSYNCRQTypeList)
  protected
    { IXMLBANKMAILSYNCRQTypeList }
    function Add: IXMLBANKMAILSYNCRQType;
    function Insert(const Index: Integer): IXMLBANKMAILSYNCRQType;

    function GetItem(Index: Integer): IXMLBANKMAILSYNCRQType;
  end;

{ TXMLSTPCHKSYNCRQType }

  TXMLSTPCHKSYNCRQType = class(TXMLNode, IXMLSTPCHKSYNCRQType)
  private
    FSTPCHKTRNRQ: IXMLSTPCHKTRNRQTypeList;
  protected
    { IXMLSTPCHKSYNCRQType }
    function GetSYNCRQMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetSTPCHKTRNRQ: IXMLSTPCHKTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSTPCHKSYNCRQTypeList }

  TXMLSTPCHKSYNCRQTypeList = class(TXMLNodeCollection, IXMLSTPCHKSYNCRQTypeList)
  protected
    { IXMLSTPCHKSYNCRQTypeList }
    function Add: IXMLSTPCHKSYNCRQType;
    function Insert(const Index: Integer): IXMLSTPCHKSYNCRQType;

    function GetItem(Index: Integer): IXMLSTPCHKSYNCRQType;
  end;

{ TXMLINTRASYNCRQType }

  TXMLINTRASYNCRQType = class(TXMLNode, IXMLINTRASYNCRQType)
  private
    FINTRATRNRQ: IXMLINTRATRNRQTypeList;
  protected
    { IXMLINTRASYNCRQType }
    function GetSYNCRQMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetINTRATRNRQ: IXMLINTRATRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTRASYNCRQTypeList }

  TXMLINTRASYNCRQTypeList = class(TXMLNodeCollection, IXMLINTRASYNCRQTypeList)
  protected
    { IXMLINTRASYNCRQTypeList }
    function Add: IXMLINTRASYNCRQType;
    function Insert(const Index: Integer): IXMLINTRASYNCRQType;

    function GetItem(Index: Integer): IXMLINTRASYNCRQType;
  end;

{ TXMLRECINTRASYNCRQType }

  TXMLRECINTRASYNCRQType = class(TXMLNode, IXMLRECINTRASYNCRQType)
  private
    FRECINTRATRNRQ: IXMLRECINTRATRNRQTypeList;
  protected
    { IXMLRECINTRASYNCRQType }
    function GetSYNCRQMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetRECINTRATRNRQ: IXMLRECINTRATRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECINTRASYNCRQTypeList }

  TXMLRECINTRASYNCRQTypeList = class(TXMLNodeCollection, IXMLRECINTRASYNCRQTypeList)
  protected
    { IXMLRECINTRASYNCRQTypeList }
    function Add: IXMLRECINTRASYNCRQType;
    function Insert(const Index: Integer): IXMLRECINTRASYNCRQType;

    function GetItem(Index: Integer): IXMLRECINTRASYNCRQType;
  end;

{ TXMLCREDITCARDMSGSRQV1Type }

  TXMLCREDITCARDMSGSRQV1Type = class(TXMLNode, IXMLCREDITCARDMSGSRQV1Type)
  private
    FCCSTMTTRNRQ: IXMLCCSTMTTRNRQTypeList;
    FCCSTMTENDTRNRQ: IXMLCCSTMTENDTRNRQTypeList;
  protected
    { IXMLCREDITCARDMSGSRQV1Type }
    function GetCCSTMTTRNRQ: IXMLCCSTMTTRNRQTypeList;
    function GetCCSTMTENDTRNRQ: IXMLCCSTMTENDTRNRQTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCCSTMTTRNRQType }

  TXMLCCSTMTTRNRQType = class(TXMLNode, IXMLCCSTMTTRNRQType)
  protected
    { IXMLCCSTMTTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetCCSTMTRQ: IXMLCCSTMTRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCCSTMTTRNRQTypeList }

  TXMLCCSTMTTRNRQTypeList = class(TXMLNodeCollection, IXMLCCSTMTTRNRQTypeList)
  protected
    { IXMLCCSTMTTRNRQTypeList }
    function Add: IXMLCCSTMTTRNRQType;
    function Insert(const Index: Integer): IXMLCCSTMTTRNRQType;

    function GetItem(Index: Integer): IXMLCCSTMTTRNRQType;
  end;

{ TXMLCCSTMTRQType }

  TXMLCCSTMTRQType = class(TXMLNode, IXMLCCSTMTRQType)
  protected
    { IXMLCCSTMTRQType }
    function GetCCACCTFROM: UnicodeString;
    function GetINCTRAN: IXMLINCTRANType;
    procedure SetCCACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCCSTMTENDTRNRQType }

  TXMLCCSTMTENDTRNRQType = class(TXMLNode, IXMLCCSTMTENDTRNRQType)
  protected
    { IXMLCCSTMTENDTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetCCSTMTENDRQ: IXMLCCSTMTENDRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCCSTMTENDTRNRQTypeList }

  TXMLCCSTMTENDTRNRQTypeList = class(TXMLNodeCollection, IXMLCCSTMTENDTRNRQTypeList)
  protected
    { IXMLCCSTMTENDTRNRQTypeList }
    function Add: IXMLCCSTMTENDTRNRQType;
    function Insert(const Index: Integer): IXMLCCSTMTENDTRNRQType;

    function GetItem(Index: Integer): IXMLCCSTMTENDTRNRQType;
  end;

{ TXMLCCSTMTENDRQType }

  TXMLCCSTMTENDRQType = class(TXMLNode, IXMLCCSTMTENDRQType)
  protected
    { IXMLCCSTMTENDRQType }
    function GetCCACCTFROM: UnicodeString;
    function GetDTSTART: UnicodeString;
    function GetDTEND: UnicodeString;
    procedure SetCCACCTFROM(Value: UnicodeString);
    procedure SetDTSTART(Value: UnicodeString);
    procedure SetDTEND(Value: UnicodeString);
  end;

{ TXMLINTERXFERMSGSRQV1Type }

  TXMLINTERXFERMSGSRQV1Type = class(TXMLNode, IXMLINTERXFERMSGSRQV1Type)
  private
    FINTERTRNRQ: IXMLINTERTRNRQTypeList;
    FRECINTERTRNRQ: IXMLRECINTERTRNRQTypeList;
    FINTERSYNCRQ: IXMLINTERSYNCRQTypeList;
    FRECINTERSYNCRQ: IXMLRECINTERSYNCRQTypeList;
  protected
    { IXMLINTERXFERMSGSRQV1Type }
    function GetINTERTRNRQ: IXMLINTERTRNRQTypeList;
    function GetRECINTERTRNRQ: IXMLRECINTERTRNRQTypeList;
    function GetINTERSYNCRQ: IXMLINTERSYNCRQTypeList;
    function GetRECINTERSYNCRQ: IXMLRECINTERSYNCRQTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTERTRNRQType }

  TXMLINTERTRNRQType = class(TXMLNode, IXMLINTERTRNRQType)
  protected
    { IXMLINTERTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetINTERRQ: IXMLINTERRQType;
    function GetINTERMODRQ: IXMLINTERMODRQType;
    function GetINTERCANRQ: IXMLINTERCANRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTERTRNRQTypeList }

  TXMLINTERTRNRQTypeList = class(TXMLNodeCollection, IXMLINTERTRNRQTypeList)
  protected
    { IXMLINTERTRNRQTypeList }
    function Add: IXMLINTERTRNRQType;
    function Insert(const Index: Integer): IXMLINTERTRNRQType;

    function GetItem(Index: Integer): IXMLINTERTRNRQType;
  end;

{ TXMLINTERRQType }

  TXMLINTERRQType = class(TXMLNode, IXMLINTERRQType)
  protected
    { IXMLINTERRQType }
    function GetXFERINFO: IXMLXFERINFOType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTERMODRQType }

  TXMLINTERMODRQType = class(TXMLNode, IXMLINTERMODRQType)
  protected
    { IXMLINTERMODRQType }
    function GetSRVRTID: UnicodeString;
    function GetXFERINFO: IXMLXFERINFOType;
    procedure SetSRVRTID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTERCANRQType }

  TXMLINTERCANRQType = class(TXMLNode, IXMLINTERCANRQType)
  protected
    { IXMLINTERCANRQType }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
  end;

{ TXMLRECINTERTRNRQType }

  TXMLRECINTERTRNRQType = class(TXMLNode, IXMLRECINTERTRNRQType)
  protected
    { IXMLRECINTERTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetRECINTERRQ: IXMLRECINTERRQType;
    function GetRECINTERMODRQ: IXMLRECINTERMODRQType;
    function GetRECINTERCANRQ: IXMLRECINTERCANRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECINTERTRNRQTypeList }

  TXMLRECINTERTRNRQTypeList = class(TXMLNodeCollection, IXMLRECINTERTRNRQTypeList)
  protected
    { IXMLRECINTERTRNRQTypeList }
    function Add: IXMLRECINTERTRNRQType;
    function Insert(const Index: Integer): IXMLRECINTERTRNRQType;

    function GetItem(Index: Integer): IXMLRECINTERTRNRQType;
  end;

{ TXMLRECINTERRQType }

  TXMLRECINTERRQType = class(TXMLNode, IXMLRECINTERRQType)
  protected
    { IXMLRECINTERRQType }
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetINTERRQ: IXMLINTERRQType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECINTERMODRQType }

  TXMLRECINTERMODRQType = class(TXMLNode, IXMLRECINTERMODRQType)
  protected
    { IXMLRECINTERMODRQType }
    function GetRECSRVRTID: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetINTERRQ: IXMLINTERRQType;
    function GetMODPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetMODPENDING(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECINTERCANRQType }

  TXMLRECINTERCANRQType = class(TXMLNode, IXMLRECINTERCANRQType)
  protected
    { IXMLRECINTERCANRQType }
    function GetRECSRVRTID: UnicodeString;
    function GetCANPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetCANPENDING(Value: UnicodeString);
  end;

{ TXMLINTERSYNCRQType }

  TXMLINTERSYNCRQType = class(TXMLNode, IXMLINTERSYNCRQType)
  private
    FINTERTRNRQ: IXMLINTERTRNRQTypeList;
  protected
    { IXMLINTERSYNCRQType }
    function GetSYNCRQMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetINTERTRNRQ: IXMLINTERTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTERSYNCRQTypeList }

  TXMLINTERSYNCRQTypeList = class(TXMLNodeCollection, IXMLINTERSYNCRQTypeList)
  protected
    { IXMLINTERSYNCRQTypeList }
    function Add: IXMLINTERSYNCRQType;
    function Insert(const Index: Integer): IXMLINTERSYNCRQType;

    function GetItem(Index: Integer): IXMLINTERSYNCRQType;
  end;

{ TXMLRECINTERSYNCRQType }

  TXMLRECINTERSYNCRQType = class(TXMLNode, IXMLRECINTERSYNCRQType)
  private
    FRECINTERTRNRQ: IXMLRECINTERTRNRQTypeList;
  protected
    { IXMLRECINTERSYNCRQType }
    function GetSYNCRQMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetRECINTERTRNRQ: IXMLRECINTERTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECINTERSYNCRQTypeList }

  TXMLRECINTERSYNCRQTypeList = class(TXMLNodeCollection, IXMLRECINTERSYNCRQTypeList)
  protected
    { IXMLRECINTERSYNCRQTypeList }
    function Add: IXMLRECINTERSYNCRQType;
    function Insert(const Index: Integer): IXMLRECINTERSYNCRQType;

    function GetItem(Index: Integer): IXMLRECINTERSYNCRQType;
  end;

{ TXMLWIREXFERMSGSRQV1Type }

  TXMLWIREXFERMSGSRQV1Type = class(TXMLNode, IXMLWIREXFERMSGSRQV1Type)
  private
    FWIRETRNRQ: IXMLWIRETRNRQTypeList;
    FWIRESYNCRQ: IXMLWIRESYNCRQTypeList;
  protected
    { IXMLWIREXFERMSGSRQV1Type }
    function GetWIRETRNRQ: IXMLWIRETRNRQTypeList;
    function GetWIRESYNCRQ: IXMLWIRESYNCRQTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLWIRETRNRQType }

  TXMLWIRETRNRQType = class(TXMLNode, IXMLWIRETRNRQType)
  protected
    { IXMLWIRETRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetWIRERQ: IXMLWIRERQType;
    function GetWIRECANRQ: IXMLWIRECANRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLWIRETRNRQTypeList }

  TXMLWIRETRNRQTypeList = class(TXMLNodeCollection, IXMLWIRETRNRQTypeList)
  protected
    { IXMLWIRETRNRQTypeList }
    function Add: IXMLWIRETRNRQType;
    function Insert(const Index: Integer): IXMLWIRETRNRQType;

    function GetItem(Index: Integer): IXMLWIRETRNRQType;
  end;

{ TXMLWIRERQType }

  TXMLWIRERQType = class(TXMLNode, IXMLWIRERQType)
  protected
    { IXMLWIRERQType }
    function GetBANKACCTFROM: UnicodeString;
    function GetWIREBENEFICIARY: IXMLWIREBENEFICIARYType;
    function GetWIREDESTBANK: IXMLWIREDESTBANKType;
    function GetTRNAMT: UnicodeString;
    function GetDTDUE: UnicodeString;
    function GetPAYINSTRUCT: UnicodeString;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
    procedure SetDTDUE(Value: UnicodeString);
    procedure SetPAYINSTRUCT(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLWIREBENEFICIARYType }

  TXMLWIREBENEFICIARYType = class(TXMLNode, IXMLWIREBENEFICIARYType)
  protected
    { IXMLWIREBENEFICIARYType }
    function GetNAME: UnicodeString;
    function GetBANKACCTTO: UnicodeString;
    function GetMEMO: UnicodeString;
    procedure SetNAME(Value: UnicodeString);
    procedure SetBANKACCTTO(Value: UnicodeString);
    procedure SetMEMO(Value: UnicodeString);
  end;

{ TXMLWIREDESTBANKType }

  TXMLWIREDESTBANKType = class(TXMLNode, IXMLWIREDESTBANKType)
  protected
    { IXMLWIREDESTBANKType }
    function GetEXTBANKDESC: IXMLEXTBANKDESCType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLEXTBANKDESCType }

  TXMLEXTBANKDESCType = class(TXMLNode, IXMLEXTBANKDESCType)
  protected
    { IXMLEXTBANKDESCType }
    function GetNAME: UnicodeString;
    function GetBANKID: UnicodeString;
    function GetADDR1: UnicodeString;
    function GetADDR2: UnicodeString;
    function GetADDR3: UnicodeString;
    function GetCITY: UnicodeString;
    function GetSTATE: UnicodeString;
    function GetPOSTALCODE: UnicodeString;
    function GetCOUNTRY: UnicodeString;
    function GetPHONE: UnicodeString;
    procedure SetNAME(Value: UnicodeString);
    procedure SetBANKID(Value: UnicodeString);
    procedure SetADDR1(Value: UnicodeString);
    procedure SetADDR2(Value: UnicodeString);
    procedure SetADDR3(Value: UnicodeString);
    procedure SetCITY(Value: UnicodeString);
    procedure SetSTATE(Value: UnicodeString);
    procedure SetPOSTALCODE(Value: UnicodeString);
    procedure SetCOUNTRY(Value: UnicodeString);
    procedure SetPHONE(Value: UnicodeString);
  end;

{ TXMLWIRECANRQType }

  TXMLWIRECANRQType = class(TXMLNode, IXMLWIRECANRQType)
  protected
    { IXMLWIRECANRQType }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
  end;

{ TXMLWIRESYNCRQType }

  TXMLWIRESYNCRQType = class(TXMLNode, IXMLWIRESYNCRQType)
  private
    FWIRETRNRQ: IXMLWIRETRNRQTypeList;
  protected
    { IXMLWIRESYNCRQType }
    function GetSYNCRQMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetWIRETRNRQ: IXMLWIRETRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLWIRESYNCRQTypeList }

  TXMLWIRESYNCRQTypeList = class(TXMLNodeCollection, IXMLWIRESYNCRQTypeList)
  protected
    { IXMLWIRESYNCRQTypeList }
    function Add: IXMLWIRESYNCRQType;
    function Insert(const Index: Integer): IXMLWIRESYNCRQType;

    function GetItem(Index: Integer): IXMLWIRESYNCRQType;
  end;

{ TXMLBANKMSGSRSV1Type }

  TXMLBANKMSGSRSV1Type = class(TXMLNode, IXMLBANKMSGSRSV1Type)
  private
    FSTMTTRNRS: IXMLSTMTTRNRSTypeList;
    FSTMTENDTRNRS: IXMLSTMTENDTRNRSTypeList;
    FINTRATRNRS: IXMLINTRATRNRSTypeList;
    FRECINTRATRNRS: IXMLRECINTRATRNRSTypeList;
    FSTPCHKTRNRS: IXMLSTPCHKTRNRSTypeList;
    FBANKMAILTRNRS: IXMLBANKMAILTRNRSTypeList;
    FBANKMAILSYNCRS: IXMLBANKMAILSYNCRSTypeList;
    FSTPCHKSYNCRS: IXMLSTPCHKSYNCRSTypeList;
    FINTRASYNCRS: IXMLINTRASYNCRSTypeList;
    FRECINTRASYNCRS: IXMLRECINTRASYNCRSTypeList;
  protected
    { IXMLBANKMSGSRSV1Type }
    function GetSTMTTRNRS: IXMLSTMTTRNRSTypeList;
    function GetSTMTENDTRNRS: IXMLSTMTENDTRNRSTypeList;
    function GetINTRATRNRS: IXMLINTRATRNRSTypeList;
    function GetRECINTRATRNRS: IXMLRECINTRATRNRSTypeList;
    function GetSTPCHKTRNRS: IXMLSTPCHKTRNRSTypeList;
    function GetBANKMAILTRNRS: IXMLBANKMAILTRNRSTypeList;
    function GetBANKMAILSYNCRS: IXMLBANKMAILSYNCRSTypeList;
    function GetSTPCHKSYNCRS: IXMLSTPCHKSYNCRSTypeList;
    function GetINTRASYNCRS: IXMLINTRASYNCRSTypeList;
    function GetRECINTRASYNCRS: IXMLRECINTRASYNCRSTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSTMTTRNRSType }

  TXMLSTMTTRNRSType = class(TXMLNode, IXMLSTMTTRNRSType)
  protected
    { IXMLSTMTTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetSTMTRS: IXMLSTMTRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSTMTTRNRSTypeList }

  TXMLSTMTTRNRSTypeList = class(TXMLNodeCollection, IXMLSTMTTRNRSTypeList)
  protected
    { IXMLSTMTTRNRSTypeList }
    function Add: IXMLSTMTTRNRSType;
    function Insert(const Index: Integer): IXMLSTMTTRNRSType;

    function GetItem(Index: Integer): IXMLSTMTTRNRSType;
  end;

{ TXMLSTMTRSType }

  TXMLSTMTRSType = class(TXMLNode, IXMLSTMTRSType)
  protected
    { IXMLSTMTRSType }
    function GetCURDEF: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetBANKTRANLIST: IXMLBANKTRANLISTType;
    function GetLEDGERBAL: IXMLLEDGERBALType;
    function GetAVAILBAL: IXMLAVAILBALType;
    function GetMKTGINFO: UnicodeString;
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetMKTGINFO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBANKTRANLISTType }

  TXMLBANKTRANLISTType = class(TXMLNode, IXMLBANKTRANLISTType)
  private
    FSTMTTRN: IXMLSTMTTRNTypeList;
  protected
    { IXMLBANKTRANLISTType }
    function GetDTSTART: UnicodeString;
    function GetDTEND: UnicodeString;
    function GetSTMTTRN: IXMLSTMTTRNTypeList;
    procedure SetDTSTART(Value: UnicodeString);
    procedure SetDTEND(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSTMTTRNType }

  TXMLSTMTTRNType = class(TXMLNode, IXMLSTMTTRNType)
  protected
    { IXMLSTMTTRNType }
    function GetTRNTYPE: UnicodeString;
    function GetDTPOSTED: UnicodeString;
    function GetDTUSER: UnicodeString;
    function GetDTAVAIL: UnicodeString;
    function GetTRNAMT: UnicodeString;
    function GetFITID: UnicodeString;
    function GetCORRECTFITID: UnicodeString;
    function GetCORRECTACTION: UnicodeString;
    function GetSRVRTID: UnicodeString;
    function GetCHECKNUM: UnicodeString;
    function GetREFNUM: UnicodeString;
    function GetSIC: UnicodeString;
    function GetPAYEEID: UnicodeString;
    function GetNAME: UnicodeString;
    function GetPAYEE: IXMLPAYEEType;
    function GetBANKACCTTO: UnicodeString;
    function GetCCACCTTO: UnicodeString;
    function GetMEMO: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetTRNTYPE(Value: UnicodeString);
    procedure SetDTPOSTED(Value: UnicodeString);
    procedure SetDTUSER(Value: UnicodeString);
    procedure SetDTAVAIL(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
    procedure SetFITID(Value: UnicodeString);
    procedure SetCORRECTFITID(Value: UnicodeString);
    procedure SetCORRECTACTION(Value: UnicodeString);
    procedure SetSRVRTID(Value: UnicodeString);
    procedure SetCHECKNUM(Value: UnicodeString);
    procedure SetREFNUM(Value: UnicodeString);
    procedure SetSIC(Value: UnicodeString);
    procedure SetPAYEEID(Value: UnicodeString);
    procedure SetNAME(Value: UnicodeString);
    procedure SetBANKACCTTO(Value: UnicodeString);
    procedure SetCCACCTTO(Value: UnicodeString);
    procedure SetMEMO(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSTMTTRNTypeList }

  TXMLSTMTTRNTypeList = class(TXMLNodeCollection, IXMLSTMTTRNTypeList)
  protected
    { IXMLSTMTTRNTypeList }
    function Add: IXMLSTMTTRNType;
    function Insert(const Index: Integer): IXMLSTMTTRNType;

    function GetItem(Index: Integer): IXMLSTMTTRNType;
  end;

{ TXMLPAYEEType }

  TXMLPAYEEType = class(TXMLNode, IXMLPAYEEType)
  protected
    { IXMLPAYEEType }
    function GetNAME: UnicodeString;
    function GetADDR1: UnicodeString;
    function GetADDR2: UnicodeString;
    function GetADDR3: UnicodeString;
    function GetCITY: UnicodeString;
    function GetSTATE: UnicodeString;
    function GetPOSTALCODE: UnicodeString;
    function GetCOUNTRY: UnicodeString;
    function GetPHONE: UnicodeString;
    procedure SetNAME(Value: UnicodeString);
    procedure SetADDR1(Value: UnicodeString);
    procedure SetADDR2(Value: UnicodeString);
    procedure SetADDR3(Value: UnicodeString);
    procedure SetCITY(Value: UnicodeString);
    procedure SetSTATE(Value: UnicodeString);
    procedure SetPOSTALCODE(Value: UnicodeString);
    procedure SetCOUNTRY(Value: UnicodeString);
    procedure SetPHONE(Value: UnicodeString);
  end;

{ TXMLLEDGERBALType }

  TXMLLEDGERBALType = class(TXMLNode, IXMLLEDGERBALType)
  protected
    { IXMLLEDGERBALType }
    function GetBALAMT: UnicodeString;
    function GetDTASOF: UnicodeString;
    procedure SetBALAMT(Value: UnicodeString);
    procedure SetDTASOF(Value: UnicodeString);
  end;

{ TXMLAVAILBALType }

  TXMLAVAILBALType = class(TXMLNode, IXMLAVAILBALType)
  protected
    { IXMLAVAILBALType }
    function GetBALAMT: UnicodeString;
    function GetDTASOF: UnicodeString;
    procedure SetBALAMT(Value: UnicodeString);
    procedure SetDTASOF(Value: UnicodeString);
  end;

{ TXMLSTMTENDTRNRSType }

  TXMLSTMTENDTRNRSType = class(TXMLNode, IXMLSTMTENDTRNRSType)
  protected
    { IXMLSTMTENDTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetSTMTENDRS: IXMLSTMTENDRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSTMTENDTRNRSTypeList }

  TXMLSTMTENDTRNRSTypeList = class(TXMLNodeCollection, IXMLSTMTENDTRNRSTypeList)
  protected
    { IXMLSTMTENDTRNRSTypeList }
    function Add: IXMLSTMTENDTRNRSType;
    function Insert(const Index: Integer): IXMLSTMTENDTRNRSType;

    function GetItem(Index: Integer): IXMLSTMTENDTRNRSType;
  end;

{ TXMLSTMTENDRSType }

  TXMLSTMTENDRSType = class(TXMLNode, IXMLSTMTENDRSType)
  private
    FCLOSING: IXMLCLOSINGTypeList;
  protected
    { IXMLSTMTENDRSType }
    function GetCURDEF: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetCLOSING: IXMLCLOSINGTypeList;
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCLOSINGType }

  TXMLCLOSINGType = class(TXMLNode, IXMLCLOSINGType)
  protected
    { IXMLCLOSINGType }
    function GetFITID: UnicodeString;
    function GetDTOPEN: UnicodeString;
    function GetDTCLOSE: UnicodeString;
    function GetDTNEXT: UnicodeString;
    function GetBALOPEN: UnicodeString;
    function GetBALCLOSE: UnicodeString;
    function GetBALMIN: UnicodeString;
    function GetDEPANDCREDIT: UnicodeString;
    function GetCHKANDDEB: UnicodeString;
    function GetTOTALFEES: UnicodeString;
    function GetTOTALINT: UnicodeString;
    function GetDTPOSTSTART: UnicodeString;
    function GetDTPOSTEND: UnicodeString;
    function GetMKTGINFO: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetFITID(Value: UnicodeString);
    procedure SetDTOPEN(Value: UnicodeString);
    procedure SetDTCLOSE(Value: UnicodeString);
    procedure SetDTNEXT(Value: UnicodeString);
    procedure SetBALOPEN(Value: UnicodeString);
    procedure SetBALCLOSE(Value: UnicodeString);
    procedure SetBALMIN(Value: UnicodeString);
    procedure SetDEPANDCREDIT(Value: UnicodeString);
    procedure SetCHKANDDEB(Value: UnicodeString);
    procedure SetTOTALFEES(Value: UnicodeString);
    procedure SetTOTALINT(Value: UnicodeString);
    procedure SetDTPOSTSTART(Value: UnicodeString);
    procedure SetDTPOSTEND(Value: UnicodeString);
    procedure SetMKTGINFO(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
  end;

{ TXMLCLOSINGTypeList }

  TXMLCLOSINGTypeList = class(TXMLNodeCollection, IXMLCLOSINGTypeList)
  protected
    { IXMLCLOSINGTypeList }
    function Add: IXMLCLOSINGType;
    function Insert(const Index: Integer): IXMLCLOSINGType;

    function GetItem(Index: Integer): IXMLCLOSINGType;
  end;

{ TXMLINTRATRNRSType }

  TXMLINTRATRNRSType = class(TXMLNode, IXMLINTRATRNRSType)
  protected
    { IXMLINTRATRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetINTRARS: IXMLINTRARSType;
    function GetINTRAMODRS: IXMLINTRAMODRSType;
    function GetINTRACANRS: IXMLINTRACANRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTRATRNRSTypeList }

  TXMLINTRATRNRSTypeList = class(TXMLNodeCollection, IXMLINTRATRNRSTypeList)
  protected
    { IXMLINTRATRNRSTypeList }
    function Add: IXMLINTRATRNRSType;
    function Insert(const Index: Integer): IXMLINTRATRNRSType;

    function GetItem(Index: Integer): IXMLINTRATRNRSType;
  end;

{ TXMLINTRARSType }

  TXMLINTRARSType = class(TXMLNode, IXMLINTRARSType)
  protected
    { IXMLINTRARSType }
    function GetCURDEF: UnicodeString;
    function GetSRVRTID: UnicodeString;
    function GetXFERINFO: IXMLXFERINFOType;
    function GetDTXFERPRJ: UnicodeString;
    function GetDTPOSTED: UnicodeString;
    function GetRECSRVRTID: UnicodeString;
    function GetXFERPRCSTS: IXMLXFERPRCSTSType;
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetSRVRTID(Value: UnicodeString);
    procedure SetDTXFERPRJ(Value: UnicodeString);
    procedure SetDTPOSTED(Value: UnicodeString);
    procedure SetRECSRVRTID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLXFERPRCSTSType }

  TXMLXFERPRCSTSType = class(TXMLNode, IXMLXFERPRCSTSType)
  protected
    { IXMLXFERPRCSTSType }
    function GetXFERPRCCODE: UnicodeString;
    function GetDTXFERPRC: UnicodeString;
    procedure SetXFERPRCCODE(Value: UnicodeString);
    procedure SetDTXFERPRC(Value: UnicodeString);
  end;

{ TXMLINTRAMODRSType }

  TXMLINTRAMODRSType = class(TXMLNode, IXMLINTRAMODRSType)
  protected
    { IXMLINTRAMODRSType }
    function GetSRVRTID: UnicodeString;
    function GetXFERINFO: IXMLXFERINFOType;
    function GetXFERPRCSTS: IXMLXFERPRCSTSType;
    procedure SetSRVRTID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTRACANRSType }

  TXMLINTRACANRSType = class(TXMLNode, IXMLINTRACANRSType)
  protected
    { IXMLINTRACANRSType }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
  end;

{ TXMLRECINTRATRNRSType }

  TXMLRECINTRATRNRSType = class(TXMLNode, IXMLRECINTRATRNRSType)
  protected
    { IXMLRECINTRATRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetRECINTRARS: IXMLRECINTRARSType;
    function GetRECINTRAMODRS: IXMLRECINTRAMODRSType;
    function GetRECINTRACANRS: IXMLRECINTRACANRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECINTRATRNRSTypeList }

  TXMLRECINTRATRNRSTypeList = class(TXMLNodeCollection, IXMLRECINTRATRNRSTypeList)
  protected
    { IXMLRECINTRATRNRSTypeList }
    function Add: IXMLRECINTRATRNRSType;
    function Insert(const Index: Integer): IXMLRECINTRATRNRSType;

    function GetItem(Index: Integer): IXMLRECINTRATRNRSType;
  end;

{ TXMLRECINTRARSType }

  TXMLRECINTRARSType = class(TXMLNode, IXMLRECINTRARSType)
  protected
    { IXMLRECINTRARSType }
    function GetRECSRVRTID: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetINTRARS: IXMLINTRARSType;
    procedure SetRECSRVRTID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECINTRAMODRSType }

  TXMLRECINTRAMODRSType = class(TXMLNode, IXMLRECINTRAMODRSType)
  protected
    { IXMLRECINTRAMODRSType }
    function GetRECSRVRTID: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetINTRARS: IXMLINTRARSType;
    function GetMODPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetMODPENDING(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECINTRACANRSType }

  TXMLRECINTRACANRSType = class(TXMLNode, IXMLRECINTRACANRSType)
  protected
    { IXMLRECINTRACANRSType }
    function GetRECSRVRTID: UnicodeString;
    function GetCANPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetCANPENDING(Value: UnicodeString);
  end;

{ TXMLSTPCHKTRNRSType }

  TXMLSTPCHKTRNRSType = class(TXMLNode, IXMLSTPCHKTRNRSType)
  protected
    { IXMLSTPCHKTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetSTPCHKRS: IXMLSTPCHKRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSTPCHKTRNRSTypeList }

  TXMLSTPCHKTRNRSTypeList = class(TXMLNodeCollection, IXMLSTPCHKTRNRSTypeList)
  protected
    { IXMLSTPCHKTRNRSTypeList }
    function Add: IXMLSTPCHKTRNRSType;
    function Insert(const Index: Integer): IXMLSTPCHKTRNRSType;

    function GetItem(Index: Integer): IXMLSTPCHKTRNRSType;
  end;

{ TXMLSTPCHKRSType }

  TXMLSTPCHKRSType = class(TXMLNode, IXMLSTPCHKRSType)
  private
    FSTPCHKNUM: IXMLSTPCHKNUMTypeList;
  protected
    { IXMLSTPCHKRSType }
    function GetCURDEF: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetSTPCHKNUM: IXMLSTPCHKNUMTypeList;
    function GetFEE: UnicodeString;
    function GetFEEMSG: UnicodeString;
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetFEE(Value: UnicodeString);
    procedure SetFEEMSG(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSTPCHKNUMType }

  TXMLSTPCHKNUMType = class(TXMLNode, IXMLSTPCHKNUMType)
  protected
    { IXMLSTPCHKNUMType }
    function GetCHECKNUM: UnicodeString;
    function GetNAME: UnicodeString;
    function GetDTUSER: UnicodeString;
    function GetTRNAMT: UnicodeString;
    function GetCHKSTATUS: UnicodeString;
    function GetCHKERROR: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetCHECKNUM(Value: UnicodeString);
    procedure SetNAME(Value: UnicodeString);
    procedure SetDTUSER(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
    procedure SetCHKSTATUS(Value: UnicodeString);
    procedure SetCHKERROR(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
  end;

{ TXMLSTPCHKNUMTypeList }

  TXMLSTPCHKNUMTypeList = class(TXMLNodeCollection, IXMLSTPCHKNUMTypeList)
  protected
    { IXMLSTPCHKNUMTypeList }
    function Add: IXMLSTPCHKNUMType;
    function Insert(const Index: Integer): IXMLSTPCHKNUMType;

    function GetItem(Index: Integer): IXMLSTPCHKNUMType;
  end;

{ TXMLBANKMAILTRNRSType }

  TXMLBANKMAILTRNRSType = class(TXMLNode, IXMLBANKMAILTRNRSType)
  protected
    { IXMLBANKMAILTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetBANKMAILRS: IXMLBANKMAILRSType;
    function GetCHKMAILRS: IXMLCHKMAILRSType;
    function GetDEPMAILRS: IXMLDEPMAILRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBANKMAILTRNRSTypeList }

  TXMLBANKMAILTRNRSTypeList = class(TXMLNodeCollection, IXMLBANKMAILTRNRSTypeList)
  protected
    { IXMLBANKMAILTRNRSTypeList }
    function Add: IXMLBANKMAILTRNRSType;
    function Insert(const Index: Integer): IXMLBANKMAILTRNRSType;

    function GetItem(Index: Integer): IXMLBANKMAILTRNRSType;
  end;

{ TXMLBANKMAILRSType }

  TXMLBANKMAILRSType = class(TXMLNode, IXMLBANKMAILRSType)
  protected
    { IXMLBANKMAILRSType }
    function GetBANKACCTFROM: UnicodeString;
    function GetCCACCTFROM: UnicodeString;
    function GetMAIL: IXMLMAILType;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetCCACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCHKMAILRSType }

  TXMLCHKMAILRSType = class(TXMLNode, IXMLCHKMAILRSType)
  protected
    { IXMLCHKMAILRSType }
    function GetBANKACCTFROM: UnicodeString;
    function GetMAIL: IXMLMAILType;
    function GetCHECKNUM: UnicodeString;
    function GetTRNAMT: UnicodeString;
    function GetDTUSER: UnicodeString;
    function GetFEE: UnicodeString;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetCHECKNUM(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
    procedure SetDTUSER(Value: UnicodeString);
    procedure SetFEE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDEPMAILRSType }

  TXMLDEPMAILRSType = class(TXMLNode, IXMLDEPMAILRSType)
  protected
    { IXMLDEPMAILRSType }
    function GetBANKACCTFROM: UnicodeString;
    function GetMAIL: IXMLMAILType;
    function GetTRNAMT: UnicodeString;
    function GetDTUSER: UnicodeString;
    function GetFEE: UnicodeString;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
    procedure SetDTUSER(Value: UnicodeString);
    procedure SetFEE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBANKMAILSYNCRSType }

  TXMLBANKMAILSYNCRSType = class(TXMLNode, IXMLBANKMAILSYNCRSType)
  private
    FBANKMAILTRNRS: IXMLBANKMAILTRNRSTypeList;
  protected
    { IXMLBANKMAILSYNCRSType }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetCCACCTFROM: UnicodeString;
    function GetBANKMAILTRNRS: IXMLBANKMAILTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetCCACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBANKMAILSYNCRSTypeList }

  TXMLBANKMAILSYNCRSTypeList = class(TXMLNodeCollection, IXMLBANKMAILSYNCRSTypeList)
  protected
    { IXMLBANKMAILSYNCRSTypeList }
    function Add: IXMLBANKMAILSYNCRSType;
    function Insert(const Index: Integer): IXMLBANKMAILSYNCRSType;

    function GetItem(Index: Integer): IXMLBANKMAILSYNCRSType;
  end;

{ TXMLSTPCHKSYNCRSType }

  TXMLSTPCHKSYNCRSType = class(TXMLNode, IXMLSTPCHKSYNCRSType)
  private
    FSTPCHKTRNRS: IXMLSTPCHKTRNRSTypeList;
  protected
    { IXMLSTPCHKSYNCRSType }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetSTPCHKTRNRS: IXMLSTPCHKTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSTPCHKSYNCRSTypeList }

  TXMLSTPCHKSYNCRSTypeList = class(TXMLNodeCollection, IXMLSTPCHKSYNCRSTypeList)
  protected
    { IXMLSTPCHKSYNCRSTypeList }
    function Add: IXMLSTPCHKSYNCRSType;
    function Insert(const Index: Integer): IXMLSTPCHKSYNCRSType;

    function GetItem(Index: Integer): IXMLSTPCHKSYNCRSType;
  end;

{ TXMLINTRASYNCRSType }

  TXMLINTRASYNCRSType = class(TXMLNode, IXMLINTRASYNCRSType)
  private
    FINTRATRNRS: IXMLINTRATRNRSTypeList;
  protected
    { IXMLINTRASYNCRSType }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetINTRATRNRS: IXMLINTRATRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTRASYNCRSTypeList }

  TXMLINTRASYNCRSTypeList = class(TXMLNodeCollection, IXMLINTRASYNCRSTypeList)
  protected
    { IXMLINTRASYNCRSTypeList }
    function Add: IXMLINTRASYNCRSType;
    function Insert(const Index: Integer): IXMLINTRASYNCRSType;

    function GetItem(Index: Integer): IXMLINTRASYNCRSType;
  end;

{ TXMLRECINTRASYNCRSType }

  TXMLRECINTRASYNCRSType = class(TXMLNode, IXMLRECINTRASYNCRSType)
  private
    FRECINTRATRNRS: IXMLRECINTRATRNRSTypeList;
  protected
    { IXMLRECINTRASYNCRSType }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetRECINTRATRNRS: IXMLRECINTRATRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECINTRASYNCRSTypeList }

  TXMLRECINTRASYNCRSTypeList = class(TXMLNodeCollection, IXMLRECINTRASYNCRSTypeList)
  protected
    { IXMLRECINTRASYNCRSTypeList }
    function Add: IXMLRECINTRASYNCRSType;
    function Insert(const Index: Integer): IXMLRECINTRASYNCRSType;

    function GetItem(Index: Integer): IXMLRECINTRASYNCRSType;
  end;

{ TXMLCREDITCARDMSGSRSV1Type }

  TXMLCREDITCARDMSGSRSV1Type = class(TXMLNode, IXMLCREDITCARDMSGSRSV1Type)
  private
    FCCSTMTTRNRS: IXMLCCSTMTTRNRSTypeList;
    FCCSTMTENDTRNRS: IXMLCCSTMTENDTRNRSTypeList;
  protected
    { IXMLCREDITCARDMSGSRSV1Type }
    function GetCCSTMTTRNRS: IXMLCCSTMTTRNRSTypeList;
    function GetCCSTMTENDTRNRS: IXMLCCSTMTENDTRNRSTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCCSTMTTRNRSType }

  TXMLCCSTMTTRNRSType = class(TXMLNode, IXMLCCSTMTTRNRSType)
  protected
    { IXMLCCSTMTTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetCCSTMTRS: IXMLCCSTMTRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCCSTMTTRNRSTypeList }

  TXMLCCSTMTTRNRSTypeList = class(TXMLNodeCollection, IXMLCCSTMTTRNRSTypeList)
  protected
    { IXMLCCSTMTTRNRSTypeList }
    function Add: IXMLCCSTMTTRNRSType;
    function Insert(const Index: Integer): IXMLCCSTMTTRNRSType;

    function GetItem(Index: Integer): IXMLCCSTMTTRNRSType;
  end;

{ TXMLCCSTMTRSType }

  TXMLCCSTMTRSType = class(TXMLNode, IXMLCCSTMTRSType)
  protected
    { IXMLCCSTMTRSType }
    function GetCURDEF: UnicodeString;
    function GetCCACCTFROM: UnicodeString;
    function GetBANKTRANLIST: IXMLBANKTRANLISTType;
    function GetLEDGERBAL: IXMLLEDGERBALType;
    function GetAVAILBAL: IXMLAVAILBALType;
    function GetMKTGINFO: UnicodeString;
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetCCACCTFROM(Value: UnicodeString);
    procedure SetMKTGINFO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCCSTMTENDTRNRSType }

  TXMLCCSTMTENDTRNRSType = class(TXMLNode, IXMLCCSTMTENDTRNRSType)
  protected
    { IXMLCCSTMTENDTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetCCSTMTENDRS: IXMLCCSTMTENDRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCCSTMTENDTRNRSTypeList }

  TXMLCCSTMTENDTRNRSTypeList = class(TXMLNodeCollection, IXMLCCSTMTENDTRNRSTypeList)
  protected
    { IXMLCCSTMTENDTRNRSTypeList }
    function Add: IXMLCCSTMTENDTRNRSType;
    function Insert(const Index: Integer): IXMLCCSTMTENDTRNRSType;

    function GetItem(Index: Integer): IXMLCCSTMTENDTRNRSType;
  end;

{ TXMLCCSTMTENDRSType }

  TXMLCCSTMTENDRSType = class(TXMLNode, IXMLCCSTMTENDRSType)
  private
    FCCCLOSING: IXMLCCCLOSINGTypeList;
  protected
    { IXMLCCSTMTENDRSType }
    function GetCURDEF: UnicodeString;
    function GetCCACCTFROM: UnicodeString;
    function GetCCCLOSING: IXMLCCCLOSINGTypeList;
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetCCACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCCCLOSINGType }

  TXMLCCCLOSINGType = class(TXMLNode, IXMLCCCLOSINGType)
  protected
    { IXMLCCCLOSINGType }
    function GetFITID: UnicodeString;
    function GetDTOPEN: UnicodeString;
    function GetDTCLOSE: UnicodeString;
    function GetDTNEXT: UnicodeString;
    function GetBALOPEN: UnicodeString;
    function GetBALCLOSE: UnicodeString;
    function GetDTPMTDUE: UnicodeString;
    function GetMINPMTDUE: UnicodeString;
    function GetFINCHG: UnicodeString;
    function GetPAYANDCREDIT: UnicodeString;
    function GetPURANDADV: UnicodeString;
    function GetDEBADJ: UnicodeString;
    function GetCREDITLIMIT: UnicodeString;
    function GetDTPOSTSTART: UnicodeString;
    function GetDTPOSTEND: UnicodeString;
    function GetMKTGINFO: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetFITID(Value: UnicodeString);
    procedure SetDTOPEN(Value: UnicodeString);
    procedure SetDTCLOSE(Value: UnicodeString);
    procedure SetDTNEXT(Value: UnicodeString);
    procedure SetBALOPEN(Value: UnicodeString);
    procedure SetBALCLOSE(Value: UnicodeString);
    procedure SetDTPMTDUE(Value: UnicodeString);
    procedure SetMINPMTDUE(Value: UnicodeString);
    procedure SetFINCHG(Value: UnicodeString);
    procedure SetPAYANDCREDIT(Value: UnicodeString);
    procedure SetPURANDADV(Value: UnicodeString);
    procedure SetDEBADJ(Value: UnicodeString);
    procedure SetCREDITLIMIT(Value: UnicodeString);
    procedure SetDTPOSTSTART(Value: UnicodeString);
    procedure SetDTPOSTEND(Value: UnicodeString);
    procedure SetMKTGINFO(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
  end;

{ TXMLCCCLOSINGTypeList }

  TXMLCCCLOSINGTypeList = class(TXMLNodeCollection, IXMLCCCLOSINGTypeList)
  protected
    { IXMLCCCLOSINGTypeList }
    function Add: IXMLCCCLOSINGType;
    function Insert(const Index: Integer): IXMLCCCLOSINGType;

    function GetItem(Index: Integer): IXMLCCCLOSINGType;
  end;

{ TXMLINTERXFERMSGSRSV1Type }

  TXMLINTERXFERMSGSRSV1Type = class(TXMLNode, IXMLINTERXFERMSGSRSV1Type)
  private
    FINTERTRNRS: IXMLINTERTRNRSTypeList;
    FRECINTERTRNRS: IXMLRECINTERTRNRSTypeList;
    FINTERSYNCRS: IXMLINTERSYNCRSTypeList;
    FRECINTERSYNCRS: IXMLRECINTERSYNCRSTypeList;
  protected
    { IXMLINTERXFERMSGSRSV1Type }
    function GetINTERTRNRS: IXMLINTERTRNRSTypeList;
    function GetRECINTERTRNRS: IXMLRECINTERTRNRSTypeList;
    function GetINTERSYNCRS: IXMLINTERSYNCRSTypeList;
    function GetRECINTERSYNCRS: IXMLRECINTERSYNCRSTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTERTRNRSType }

  TXMLINTERTRNRSType = class(TXMLNode, IXMLINTERTRNRSType)
  protected
    { IXMLINTERTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetINTERRS: IXMLINTERRSType;
    function GetINTERMODRS: IXMLINTERMODRSType;
    function GetINTERCANRS: IXMLINTERCANRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTERTRNRSTypeList }

  TXMLINTERTRNRSTypeList = class(TXMLNodeCollection, IXMLINTERTRNRSTypeList)
  protected
    { IXMLINTERTRNRSTypeList }
    function Add: IXMLINTERTRNRSType;
    function Insert(const Index: Integer): IXMLINTERTRNRSType;

    function GetItem(Index: Integer): IXMLINTERTRNRSType;
  end;

{ TXMLINTERRSType }

  TXMLINTERRSType = class(TXMLNode, IXMLINTERRSType)
  protected
    { IXMLINTERRSType }
    function GetCURDEF: UnicodeString;
    function GetSRVRTID: UnicodeString;
    function GetXFERINFO: IXMLXFERINFOType;
    function GetDTXFERPRJ: UnicodeString;
    function GetDTPOSTED: UnicodeString;
    function GetREFNUM: UnicodeString;
    function GetRECSRVRTID: UnicodeString;
    function GetXFERPRCSTS: IXMLXFERPRCSTSType;
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetSRVRTID(Value: UnicodeString);
    procedure SetDTXFERPRJ(Value: UnicodeString);
    procedure SetDTPOSTED(Value: UnicodeString);
    procedure SetREFNUM(Value: UnicodeString);
    procedure SetRECSRVRTID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTERMODRSType }

  TXMLINTERMODRSType = class(TXMLNode, IXMLINTERMODRSType)
  protected
    { IXMLINTERMODRSType }
    function GetSRVRTID: UnicodeString;
    function GetXFERINFO: IXMLXFERINFOType;
    function GetXFERPRCSTS: IXMLXFERPRCSTSType;
    procedure SetSRVRTID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTERCANRSType }

  TXMLINTERCANRSType = class(TXMLNode, IXMLINTERCANRSType)
  protected
    { IXMLINTERCANRSType }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
  end;

{ TXMLRECINTERTRNRSType }

  TXMLRECINTERTRNRSType = class(TXMLNode, IXMLRECINTERTRNRSType)
  protected
    { IXMLRECINTERTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetRECINTERRS: IXMLRECINTERRSType;
    function GetRECINTERMODRS: IXMLRECINTERMODRSType;
    function GetRECINTERCANRS: IXMLRECINTERCANRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECINTERTRNRSTypeList }

  TXMLRECINTERTRNRSTypeList = class(TXMLNodeCollection, IXMLRECINTERTRNRSTypeList)
  protected
    { IXMLRECINTERTRNRSTypeList }
    function Add: IXMLRECINTERTRNRSType;
    function Insert(const Index: Integer): IXMLRECINTERTRNRSType;

    function GetItem(Index: Integer): IXMLRECINTERTRNRSType;
  end;

{ TXMLRECINTERRSType }

  TXMLRECINTERRSType = class(TXMLNode, IXMLRECINTERRSType)
  protected
    { IXMLRECINTERRSType }
    function GetRECSRVRTID: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetINTERRS: IXMLINTERRSType;
    procedure SetRECSRVRTID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECINTERMODRSType }

  TXMLRECINTERMODRSType = class(TXMLNode, IXMLRECINTERMODRSType)
  protected
    { IXMLRECINTERMODRSType }
    function GetRECSRVRTID: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetINTERRS: IXMLINTERRSType;
    function GetMODPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetMODPENDING(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECINTERCANRSType }

  TXMLRECINTERCANRSType = class(TXMLNode, IXMLRECINTERCANRSType)
  protected
    { IXMLRECINTERCANRSType }
    function GetRECSRVRTID: UnicodeString;
    function GetCANPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetCANPENDING(Value: UnicodeString);
  end;

{ TXMLINTERSYNCRSType }

  TXMLINTERSYNCRSType = class(TXMLNode, IXMLINTERSYNCRSType)
  private
    FINTERTRNRS: IXMLINTERTRNRSTypeList;
  protected
    { IXMLINTERSYNCRSType }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetINTERTRNRS: IXMLINTERTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINTERSYNCRSTypeList }

  TXMLINTERSYNCRSTypeList = class(TXMLNodeCollection, IXMLINTERSYNCRSTypeList)
  protected
    { IXMLINTERSYNCRSTypeList }
    function Add: IXMLINTERSYNCRSType;
    function Insert(const Index: Integer): IXMLINTERSYNCRSType;

    function GetItem(Index: Integer): IXMLINTERSYNCRSType;
  end;

{ TXMLRECINTERSYNCRSType }

  TXMLRECINTERSYNCRSType = class(TXMLNode, IXMLRECINTERSYNCRSType)
  private
    FRECINTERTRNRS: IXMLRECINTERTRNRSTypeList;
  protected
    { IXMLRECINTERSYNCRSType }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetRECINTERTRNRS: IXMLRECINTERTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECINTERSYNCRSTypeList }

  TXMLRECINTERSYNCRSTypeList = class(TXMLNodeCollection, IXMLRECINTERSYNCRSTypeList)
  protected
    { IXMLRECINTERSYNCRSTypeList }
    function Add: IXMLRECINTERSYNCRSType;
    function Insert(const Index: Integer): IXMLRECINTERSYNCRSType;

    function GetItem(Index: Integer): IXMLRECINTERSYNCRSType;
  end;

{ TXMLWIREXFERMSGSRSV1Type }

  TXMLWIREXFERMSGSRSV1Type = class(TXMLNode, IXMLWIREXFERMSGSRSV1Type)
  private
    FWIRETRNRS: IXMLWIRETRNRSTypeList;
    FWIRESYNCRS: IXMLWIRESYNCRSTypeList;
  protected
    { IXMLWIREXFERMSGSRSV1Type }
    function GetWIRETRNRS: IXMLWIRETRNRSTypeList;
    function GetWIRESYNCRS: IXMLWIRESYNCRSTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLWIRETRNRSType }

  TXMLWIRETRNRSType = class(TXMLNode, IXMLWIRETRNRSType)
  protected
    { IXMLWIRETRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetWIRERS: IXMLWIRERSType;
    function GetWIRECANRS: IXMLWIRECANRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLWIRETRNRSTypeList }

  TXMLWIRETRNRSTypeList = class(TXMLNodeCollection, IXMLWIRETRNRSTypeList)
  protected
    { IXMLWIRETRNRSTypeList }
    function Add: IXMLWIRETRNRSType;
    function Insert(const Index: Integer): IXMLWIRETRNRSType;

    function GetItem(Index: Integer): IXMLWIRETRNRSType;
  end;

{ TXMLWIRERSType }

  TXMLWIRERSType = class(TXMLNode, IXMLWIRERSType)
  protected
    { IXMLWIRERSType }
    function GetCURDEF: UnicodeString;
    function GetSRVRTID: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetWIREBENEFICIARY: IXMLWIREBENEFICIARYType;
    function GetWIREDESTBANK: IXMLWIREDESTBANKType;
    function GetTRNAMT: UnicodeString;
    function GetDTDUE: UnicodeString;
    function GetPAYINSTRUCT: UnicodeString;
    function GetDTXFERPRJ: UnicodeString;
    function GetDTPOSTED: UnicodeString;
    function GetFEE: UnicodeString;
    function GetCONFMSG: UnicodeString;
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetSRVRTID(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
    procedure SetDTDUE(Value: UnicodeString);
    procedure SetPAYINSTRUCT(Value: UnicodeString);
    procedure SetDTXFERPRJ(Value: UnicodeString);
    procedure SetDTPOSTED(Value: UnicodeString);
    procedure SetFEE(Value: UnicodeString);
    procedure SetCONFMSG(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLWIRECANRSType }

  TXMLWIRECANRSType = class(TXMLNode, IXMLWIRECANRSType)
  protected
    { IXMLWIRECANRSType }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
  end;

{ TXMLWIRESYNCRSType }

  TXMLWIRESYNCRSType = class(TXMLNode, IXMLWIRESYNCRSType)
  private
    FWIRETRNRS: IXMLWIRETRNRSTypeList;
  protected
    { IXMLWIRESYNCRSType }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetWIRETRNRS: IXMLWIRETRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLWIRESYNCRSTypeList }

  TXMLWIRESYNCRSTypeList = class(TXMLNodeCollection, IXMLWIRESYNCRSTypeList)
  protected
    { IXMLWIRESYNCRSTypeList }
    function Add: IXMLWIRESYNCRSType;
    function Insert(const Index: Integer): IXMLWIRESYNCRSType;

    function GetItem(Index: Integer): IXMLWIRESYNCRSType;
  end;

{ TXMLBANKACCTINFOType }

  TXMLBANKACCTINFOType = class(TXMLNode, IXMLBANKACCTINFOType)
  protected
    { IXMLBANKACCTINFOType }
    function GetBANKACCTFROM: UnicodeString;
    function GetSUPTXDL: UnicodeString;
    function GetXFERSRC: UnicodeString;
    function GetXFERDEST: UnicodeString;
    function GetSVCSTATUS: UnicodeString;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetSUPTXDL(Value: UnicodeString);
    procedure SetXFERSRC(Value: UnicodeString);
    procedure SetXFERDEST(Value: UnicodeString);
    procedure SetSVCSTATUS(Value: UnicodeString);
  end;

{ TXMLCCACCTINFOType }

  TXMLCCACCTINFOType = class(TXMLNode, IXMLCCACCTINFOType)
  protected
    { IXMLCCACCTINFOType }
    function GetCCACCTFROM: UnicodeString;
    function GetSUPTXDL: UnicodeString;
    function GetXFERSRC: UnicodeString;
    function GetXFERDEST: UnicodeString;
    function GetSVCSTATUS: UnicodeString;
    procedure SetCCACCTFROM(Value: UnicodeString);
    procedure SetSUPTXDL(Value: UnicodeString);
    procedure SetXFERSRC(Value: UnicodeString);
    procedure SetXFERDEST(Value: UnicodeString);
    procedure SetSVCSTATUS(Value: UnicodeString);
  end;

{ TXMLBILLPAYMSGSRQV1Type }

  TXMLBILLPAYMSGSRQV1Type = class(TXMLNode, IXMLBILLPAYMSGSRQV1Type)
  private
    FPAYEETRNRQ: IXMLPAYEETRNRQTypeList;
    FPAYEESYNCRQ: IXMLPAYEESYNCRQTypeList;
    FPMTTRNRQ: IXMLPMTTRNRQTypeList;
    FRECPMTTRNRQ: IXMLRECPMTTRNRQTypeList;
    FPMTINQTRNRQ: IXMLPMTINQTRNRQTypeList;
    FPMTMAILTRNRQ: IXMLPMTMAILTRNRQTypeList;
    FPMTSYNCRQ: IXMLPMTSYNCRQTypeList;
    FRECPMTSYNCRQ: IXMLRECPMTSYNCRQTypeList;
    FPMTMAILSYNCRQ: IXMLPMTMAILSYNCRQTypeList;
  protected
    { IXMLBILLPAYMSGSRQV1Type }
    function GetPAYEETRNRQ: IXMLPAYEETRNRQTypeList;
    function GetPAYEESYNCRQ: IXMLPAYEESYNCRQTypeList;
    function GetPMTTRNRQ: IXMLPMTTRNRQTypeList;
    function GetRECPMTTRNRQ: IXMLRECPMTTRNRQTypeList;
    function GetPMTINQTRNRQ: IXMLPMTINQTRNRQTypeList;
    function GetPMTMAILTRNRQ: IXMLPMTMAILTRNRQTypeList;
    function GetPMTSYNCRQ: IXMLPMTSYNCRQTypeList;
    function GetRECPMTSYNCRQ: IXMLRECPMTSYNCRQTypeList;
    function GetPMTMAILSYNCRQ: IXMLPMTMAILSYNCRQTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPAYEETRNRQType }

  TXMLPAYEETRNRQType = class(TXMLNode, IXMLPAYEETRNRQType)
  protected
    { IXMLPAYEETRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetPAYEERQ: IXMLPAYEERQType;
    function GetPAYEEMODRQ: IXMLPAYEEMODRQType;
    function GetPAYEEDELRQ: IXMLPAYEEDELRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPAYEETRNRQTypeList }

  TXMLPAYEETRNRQTypeList = class(TXMLNodeCollection, IXMLPAYEETRNRQTypeList)
  protected
    { IXMLPAYEETRNRQTypeList }
    function Add: IXMLPAYEETRNRQType;
    function Insert(const Index: Integer): IXMLPAYEETRNRQType;

    function GetItem(Index: Integer): IXMLPAYEETRNRQType;
  end;

{ TXMLPAYEERQType }

  TXMLPAYEERQType = class(TXMLNode, IXMLPAYEERQType)
  private
    FPAYACCT: IXMLString_List;
  protected
    { IXMLPAYEERQType }
    function GetPAYEEID: UnicodeString;
    function GetPAYEE: IXMLPAYEEType;
    function GetBANKACCTTO: UnicodeString;
    function GetPAYACCT: IXMLString_List;
    procedure SetPAYEEID(Value: UnicodeString);
    procedure SetBANKACCTTO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPAYEEMODRQType }

  TXMLPAYEEMODRQType = class(TXMLNode, IXMLPAYEEMODRQType)
  private
    FPAYACCT: IXMLString_List;
  protected
    { IXMLPAYEEMODRQType }
    function GetPAYEELSTID: UnicodeString;
    function GetPAYEE: IXMLPAYEEType;
    function GetBANKACCTTO: UnicodeString;
    function GetPAYACCT: IXMLString_List;
    procedure SetPAYEELSTID(Value: UnicodeString);
    procedure SetBANKACCTTO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPAYEEDELRQType }

  TXMLPAYEEDELRQType = class(TXMLNode, IXMLPAYEEDELRQType)
  protected
    { IXMLPAYEEDELRQType }
    function GetPAYEELSTID: UnicodeString;
    procedure SetPAYEELSTID(Value: UnicodeString);
  end;

{ TXMLPAYEESYNCRQType }

  TXMLPAYEESYNCRQType = class(TXMLNode, IXMLPAYEESYNCRQType)
  private
    FPAYEETRNRQ: IXMLPAYEETRNRQTypeList;
  protected
    { IXMLPAYEESYNCRQType }
    function GetSYNCRQMACRO: UnicodeString;
    function GetPAYEETRNRQ: IXMLPAYEETRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPAYEESYNCRQTypeList }

  TXMLPAYEESYNCRQTypeList = class(TXMLNodeCollection, IXMLPAYEESYNCRQTypeList)
  protected
    { IXMLPAYEESYNCRQTypeList }
    function Add: IXMLPAYEESYNCRQType;
    function Insert(const Index: Integer): IXMLPAYEESYNCRQType;

    function GetItem(Index: Integer): IXMLPAYEESYNCRQType;
  end;

{ TXMLPMTTRNRQType }

  TXMLPMTTRNRQType = class(TXMLNode, IXMLPMTTRNRQType)
  protected
    { IXMLPMTTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetPMTRQ: IXMLPMTRQType;
    function GetPMTMODRQ: IXMLPMTMODRQType;
    function GetPMTCANCRQ: IXMLPMTCANCRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPMTTRNRQTypeList }

  TXMLPMTTRNRQTypeList = class(TXMLNodeCollection, IXMLPMTTRNRQTypeList)
  protected
    { IXMLPMTTRNRQTypeList }
    function Add: IXMLPMTTRNRQType;
    function Insert(const Index: Integer): IXMLPMTTRNRQType;

    function GetItem(Index: Integer): IXMLPMTTRNRQType;
  end;

{ TXMLPMTRQType }

  TXMLPMTRQType = class(TXMLNode, IXMLPMTRQType)
  protected
    { IXMLPMTRQType }
    function GetPMTINFO: IXMLPMTINFOType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPMTINFOType }

  TXMLPMTINFOType = class(TXMLNode, IXMLPMTINFOType)
  private
    FEXTDPMT: IXMLEXTDPMTTypeList;
  protected
    { IXMLPMTINFOType }
    function GetBANKACCTFROM: UnicodeString;
    function GetTRNAMT: UnicodeString;
    function GetPAYEEID: UnicodeString;
    function GetPAYEE: IXMLPAYEEType;
    function GetPAYEELSTID: UnicodeString;
    function GetBANKACCTTO: UnicodeString;
    function GetEXTDPMT: IXMLEXTDPMTTypeList;
    function GetPAYACCT: UnicodeString;
    function GetDTDUE: UnicodeString;
    function GetMEMO: UnicodeString;
    function GetBILLREFINFO: UnicodeString;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetTRNAMT(Value: UnicodeString);
    procedure SetPAYEEID(Value: UnicodeString);
    procedure SetPAYEELSTID(Value: UnicodeString);
    procedure SetBANKACCTTO(Value: UnicodeString);
    procedure SetPAYACCT(Value: UnicodeString);
    procedure SetDTDUE(Value: UnicodeString);
    procedure SetMEMO(Value: UnicodeString);
    procedure SetBILLREFINFO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLEXTDPMTType }

  TXMLEXTDPMTType = class(TXMLNode, IXMLEXTDPMTType)
  protected
    { IXMLEXTDPMTType }
    function GetEXTDPMTFOR: UnicodeString;
    function GetEXTDPMTCHK: UnicodeString;
    function GetEXTDPMTDSC: UnicodeString;
    function GetEXTDPMTINV: IXMLEXTDPMTINVType;
    procedure SetEXTDPMTFOR(Value: UnicodeString);
    procedure SetEXTDPMTCHK(Value: UnicodeString);
    procedure SetEXTDPMTDSC(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLEXTDPMTTypeList }

  TXMLEXTDPMTTypeList = class(TXMLNodeCollection, IXMLEXTDPMTTypeList)
  protected
    { IXMLEXTDPMTTypeList }
    function Add: IXMLEXTDPMTType;
    function Insert(const Index: Integer): IXMLEXTDPMTType;

    function GetItem(Index: Integer): IXMLEXTDPMTType;
  end;

{ TXMLEXTDPMTINVType }

  TXMLEXTDPMTINVType = class(TXMLNodeCollection, IXMLEXTDPMTINVType)
  protected
    { IXMLEXTDPMTINVType }
    function GetINVOICE(Index: Integer): IXMLINVOICEType;
    function Add: IXMLINVOICEType;
    function Insert(const Index: Integer): IXMLINVOICEType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVOICEType }

  TXMLINVOICEType = class(TXMLNode, IXMLINVOICEType)
  private
    FLINEITEM: IXMLLINEITEMTypeList;
  protected
    { IXMLINVOICEType }
    function GetINVNO: UnicodeString;
    function GetINVTOTALAMT: UnicodeString;
    function GetINVPAIDAMT: UnicodeString;
    function GetINVDATE: UnicodeString;
    function GetINVDESC: UnicodeString;
    function GetDISCOUNT: IXMLDISCOUNTType;
    function GetADJUSTMENT: IXMLADJUSTMENTType;
    function GetLINEITEM: IXMLLINEITEMTypeList;
    procedure SetINVNO(Value: UnicodeString);
    procedure SetINVTOTALAMT(Value: UnicodeString);
    procedure SetINVPAIDAMT(Value: UnicodeString);
    procedure SetINVDATE(Value: UnicodeString);
    procedure SetINVDESC(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDISCOUNTType }

  TXMLDISCOUNTType = class(TXMLNode, IXMLDISCOUNTType)
  protected
    { IXMLDISCOUNTType }
    function GetDSCRATE: UnicodeString;
    function GetDSCAMT: UnicodeString;
    function GetDSCDATE: UnicodeString;
    function GetDSCDESC: UnicodeString;
    procedure SetDSCRATE(Value: UnicodeString);
    procedure SetDSCAMT(Value: UnicodeString);
    procedure SetDSCDATE(Value: UnicodeString);
    procedure SetDSCDESC(Value: UnicodeString);
  end;

{ TXMLADJUSTMENTType }

  TXMLADJUSTMENTType = class(TXMLNode, IXMLADJUSTMENTType)
  protected
    { IXMLADJUSTMENTType }
    function GetADJNO: UnicodeString;
    function GetADJDESC: UnicodeString;
    function GetADJAMT: UnicodeString;
    function GetADJDATE: UnicodeString;
    procedure SetADJNO(Value: UnicodeString);
    procedure SetADJDESC(Value: UnicodeString);
    procedure SetADJAMT(Value: UnicodeString);
    procedure SetADJDATE(Value: UnicodeString);
  end;

{ TXMLLINEITEMType }

  TXMLLINEITEMType = class(TXMLNode, IXMLLINEITEMType)
  protected
    { IXMLLINEITEMType }
    function GetLITMAMT: UnicodeString;
    function GetLITMDESC: UnicodeString;
    procedure SetLITMAMT(Value: UnicodeString);
    procedure SetLITMDESC(Value: UnicodeString);
  end;

{ TXMLLINEITEMTypeList }

  TXMLLINEITEMTypeList = class(TXMLNodeCollection, IXMLLINEITEMTypeList)
  protected
    { IXMLLINEITEMTypeList }
    function Add: IXMLLINEITEMType;
    function Insert(const Index: Integer): IXMLLINEITEMType;

    function GetItem(Index: Integer): IXMLLINEITEMType;
  end;

{ TXMLPMTMODRQType }

  TXMLPMTMODRQType = class(TXMLNode, IXMLPMTMODRQType)
  protected
    { IXMLPMTMODRQType }
    function GetSRVRTID: UnicodeString;
    function GetPMTINFO: IXMLPMTINFOType;
    procedure SetSRVRTID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPMTCANCRQType }

  TXMLPMTCANCRQType = class(TXMLNode, IXMLPMTCANCRQType)
  protected
    { IXMLPMTCANCRQType }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
  end;

{ TXMLRECPMTTRNRQType }

  TXMLRECPMTTRNRQType = class(TXMLNode, IXMLRECPMTTRNRQType)
  protected
    { IXMLRECPMTTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetRECPMTRQ: IXMLRECPMTRQType;
    function GetRECPMTMODRQ: IXMLRECPMTMODRQType;
    function GetRECPMTCANCRQ: IXMLRECPMTCANCRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECPMTTRNRQTypeList }

  TXMLRECPMTTRNRQTypeList = class(TXMLNodeCollection, IXMLRECPMTTRNRQTypeList)
  protected
    { IXMLRECPMTTRNRQTypeList }
    function Add: IXMLRECPMTTRNRQType;
    function Insert(const Index: Integer): IXMLRECPMTTRNRQType;

    function GetItem(Index: Integer): IXMLRECPMTTRNRQType;
  end;

{ TXMLRECPMTRQType }

  TXMLRECPMTRQType = class(TXMLNode, IXMLRECPMTRQType)
  protected
    { IXMLRECPMTRQType }
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetPMTINFO: IXMLPMTINFOType;
    function GetINITIALAMT: UnicodeString;
    function GetFINALAMT: UnicodeString;
    procedure SetINITIALAMT(Value: UnicodeString);
    procedure SetFINALAMT(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECPMTMODRQType }

  TXMLRECPMTMODRQType = class(TXMLNode, IXMLRECPMTMODRQType)
  protected
    { IXMLRECPMTMODRQType }
    function GetRECSRVRTID: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetPMTINFO: IXMLPMTINFOType;
    function GetINITIALAMT: UnicodeString;
    function GetFINALAMT: UnicodeString;
    function GetMODPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetINITIALAMT(Value: UnicodeString);
    procedure SetFINALAMT(Value: UnicodeString);
    procedure SetMODPENDING(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECPMTCANCRQType }

  TXMLRECPMTCANCRQType = class(TXMLNode, IXMLRECPMTCANCRQType)
  protected
    { IXMLRECPMTCANCRQType }
    function GetRECSRVRTID: UnicodeString;
    function GetCANPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetCANPENDING(Value: UnicodeString);
  end;

{ TXMLPMTINQTRNRQType }

  TXMLPMTINQTRNRQType = class(TXMLNode, IXMLPMTINQTRNRQType)
  protected
    { IXMLPMTINQTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetPMTINQRQ: IXMLPMTINQRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPMTINQTRNRQTypeList }

  TXMLPMTINQTRNRQTypeList = class(TXMLNodeCollection, IXMLPMTINQTRNRQTypeList)
  protected
    { IXMLPMTINQTRNRQTypeList }
    function Add: IXMLPMTINQTRNRQType;
    function Insert(const Index: Integer): IXMLPMTINQTRNRQType;

    function GetItem(Index: Integer): IXMLPMTINQTRNRQType;
  end;

{ TXMLPMTINQRQType }

  TXMLPMTINQRQType = class(TXMLNode, IXMLPMTINQRQType)
  protected
    { IXMLPMTINQRQType }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
  end;

{ TXMLPMTMAILTRNRQType }

  TXMLPMTMAILTRNRQType = class(TXMLNode, IXMLPMTMAILTRNRQType)
  protected
    { IXMLPMTMAILTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetPMTMAILRQ: IXMLPMTMAILRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPMTMAILTRNRQTypeList }

  TXMLPMTMAILTRNRQTypeList = class(TXMLNodeCollection, IXMLPMTMAILTRNRQTypeList)
  protected
    { IXMLPMTMAILTRNRQTypeList }
    function Add: IXMLPMTMAILTRNRQType;
    function Insert(const Index: Integer): IXMLPMTMAILTRNRQType;

    function GetItem(Index: Integer): IXMLPMTMAILTRNRQType;
  end;

{ TXMLPMTMAILRQType }

  TXMLPMTMAILRQType = class(TXMLNode, IXMLPMTMAILRQType)
  protected
    { IXMLPMTMAILRQType }
    function GetMAIL: IXMLMAILType;
    function GetSRVRTID: UnicodeString;
    function GetPMTINFO: IXMLPMTINFOType;
    procedure SetSRVRTID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPMTSYNCRQType }

  TXMLPMTSYNCRQType = class(TXMLNode, IXMLPMTSYNCRQType)
  private
    FPMTTRNRQ: IXMLPMTTRNRQTypeList;
  protected
    { IXMLPMTSYNCRQType }
    function GetSYNCRQMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetPMTTRNRQ: IXMLPMTTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPMTSYNCRQTypeList }

  TXMLPMTSYNCRQTypeList = class(TXMLNodeCollection, IXMLPMTSYNCRQTypeList)
  protected
    { IXMLPMTSYNCRQTypeList }
    function Add: IXMLPMTSYNCRQType;
    function Insert(const Index: Integer): IXMLPMTSYNCRQType;

    function GetItem(Index: Integer): IXMLPMTSYNCRQType;
  end;

{ TXMLRECPMTSYNCRQType }

  TXMLRECPMTSYNCRQType = class(TXMLNode, IXMLRECPMTSYNCRQType)
  private
    FRECPMTTRNRQ: IXMLRECPMTTRNRQTypeList;
  protected
    { IXMLRECPMTSYNCRQType }
    function GetSYNCRQMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetRECPMTTRNRQ: IXMLRECPMTTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECPMTSYNCRQTypeList }

  TXMLRECPMTSYNCRQTypeList = class(TXMLNodeCollection, IXMLRECPMTSYNCRQTypeList)
  protected
    { IXMLRECPMTSYNCRQTypeList }
    function Add: IXMLRECPMTSYNCRQType;
    function Insert(const Index: Integer): IXMLRECPMTSYNCRQType;

    function GetItem(Index: Integer): IXMLRECPMTSYNCRQType;
  end;

{ TXMLPMTMAILSYNCRQType }

  TXMLPMTMAILSYNCRQType = class(TXMLNode, IXMLPMTMAILSYNCRQType)
  private
    FPMTMAILTRNRQ: IXMLPMTMAILTRNRQTypeList;
  protected
    { IXMLPMTMAILSYNCRQType }
    function GetSYNCRQMACRO: UnicodeString;
    function GetINCIMAGES: UnicodeString;
    function GetUSEHTML: UnicodeString;
    function GetPMTMAILTRNRQ: IXMLPMTMAILTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetINCIMAGES(Value: UnicodeString);
    procedure SetUSEHTML(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPMTMAILSYNCRQTypeList }

  TXMLPMTMAILSYNCRQTypeList = class(TXMLNodeCollection, IXMLPMTMAILSYNCRQTypeList)
  protected
    { IXMLPMTMAILSYNCRQTypeList }
    function Add: IXMLPMTMAILSYNCRQType;
    function Insert(const Index: Integer): IXMLPMTMAILSYNCRQType;

    function GetItem(Index: Integer): IXMLPMTMAILSYNCRQType;
  end;

{ TXMLBILLPAYMSGSRSV1Type }

  TXMLBILLPAYMSGSRSV1Type = class(TXMLNode, IXMLBILLPAYMSGSRSV1Type)
  private
    FPAYEETRNRS: IXMLPAYEETRNRSTypeList;
    FPAYEESYNCRS: IXMLPAYEESYNCRSTypeList;
    FPMTTRNRS: IXMLPMTTRNRSTypeList;
    FRECPMTTRNRS: IXMLRECPMTTRNRSTypeList;
    FPMTINQTRNRS: IXMLPMTINQTRNRSTypeList;
    FPMTMAILTRNRS: IXMLPMTMAILTRNRSTypeList;
    FPMTSYNCRS: IXMLPMTSYNCRSTypeList;
    FRECPMTSYNCRS: IXMLRECPMTSYNCRSTypeList;
    FPMTMAILSYNCRS: IXMLPMTMAILSYNCRSTypeList;
  protected
    { IXMLBILLPAYMSGSRSV1Type }
    function GetPAYEETRNRS: IXMLPAYEETRNRSTypeList;
    function GetPAYEESYNCRS: IXMLPAYEESYNCRSTypeList;
    function GetPMTTRNRS: IXMLPMTTRNRSTypeList;
    function GetRECPMTTRNRS: IXMLRECPMTTRNRSTypeList;
    function GetPMTINQTRNRS: IXMLPMTINQTRNRSTypeList;
    function GetPMTMAILTRNRS: IXMLPMTMAILTRNRSTypeList;
    function GetPMTSYNCRS: IXMLPMTSYNCRSTypeList;
    function GetRECPMTSYNCRS: IXMLRECPMTSYNCRSTypeList;
    function GetPMTMAILSYNCRS: IXMLPMTMAILSYNCRSTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPAYEETRNRSType }

  TXMLPAYEETRNRSType = class(TXMLNode, IXMLPAYEETRNRSType)
  protected
    { IXMLPAYEETRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetPAYEERS: IXMLPAYEERSType;
    function GetPAYEEMODRS: IXMLPAYEEMODRSType;
    function GetPAYEEDELRS: IXMLPAYEEDELRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPAYEETRNRSTypeList }

  TXMLPAYEETRNRSTypeList = class(TXMLNodeCollection, IXMLPAYEETRNRSTypeList)
  protected
    { IXMLPAYEETRNRSTypeList }
    function Add: IXMLPAYEETRNRSType;
    function Insert(const Index: Integer): IXMLPAYEETRNRSType;

    function GetItem(Index: Integer): IXMLPAYEETRNRSType;
  end;

{ TXMLPAYEERSType }

  TXMLPAYEERSType = class(TXMLNode, IXMLPAYEERSType)
  private
    FPAYACCT: IXMLString_List;
  protected
    { IXMLPAYEERSType }
    function GetPAYEELSTID: UnicodeString;
    function GetPAYEE: IXMLPAYEEType;
    function GetBANKACCTTO: UnicodeString;
    function GetEXTDPAYEE: IXMLEXTDPAYEEType;
    function GetPAYACCT: IXMLString_List;
    procedure SetPAYEELSTID(Value: UnicodeString);
    procedure SetBANKACCTTO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLEXTDPAYEEType }

  TXMLEXTDPAYEEType = class(TXMLNode, IXMLEXTDPAYEEType)
  protected
    { IXMLEXTDPAYEEType }
    function GetPAYEEID: UnicodeString;
    function GetIDSCOPE: UnicodeString;
    function GetNAME: UnicodeString;
    function GetDAYSTOPAY: UnicodeString;
    procedure SetPAYEEID(Value: UnicodeString);
    procedure SetIDSCOPE(Value: UnicodeString);
    procedure SetNAME(Value: UnicodeString);
    procedure SetDAYSTOPAY(Value: UnicodeString);
  end;

{ TXMLPAYEEMODRSType }

  TXMLPAYEEMODRSType = class(TXMLNode, IXMLPAYEEMODRSType)
  private
    FPAYACCT: IXMLString_List;
  protected
    { IXMLPAYEEMODRSType }
    function GetPAYEELSTID: UnicodeString;
    function GetPAYEE: IXMLPAYEEType;
    function GetBANKACCTTO: UnicodeString;
    function GetPAYACCT: IXMLString_List;
    function GetEXTDPAYEE: IXMLEXTDPAYEEType;
    procedure SetPAYEELSTID(Value: UnicodeString);
    procedure SetBANKACCTTO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPAYEEDELRSType }

  TXMLPAYEEDELRSType = class(TXMLNode, IXMLPAYEEDELRSType)
  protected
    { IXMLPAYEEDELRSType }
    function GetPAYEELSTID: UnicodeString;
    procedure SetPAYEELSTID(Value: UnicodeString);
  end;

{ TXMLPAYEESYNCRSType }

  TXMLPAYEESYNCRSType = class(TXMLNode, IXMLPAYEESYNCRSType)
  private
    FPAYEETRNRS: IXMLPAYEETRNRSTypeList;
  protected
    { IXMLPAYEESYNCRSType }
    function GetSYNCRSMACRO: UnicodeString;
    function GetPAYEETRNRS: IXMLPAYEETRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPAYEESYNCRSTypeList }

  TXMLPAYEESYNCRSTypeList = class(TXMLNodeCollection, IXMLPAYEESYNCRSTypeList)
  protected
    { IXMLPAYEESYNCRSTypeList }
    function Add: IXMLPAYEESYNCRSType;
    function Insert(const Index: Integer): IXMLPAYEESYNCRSType;

    function GetItem(Index: Integer): IXMLPAYEESYNCRSType;
  end;

{ TXMLPMTTRNRSType }

  TXMLPMTTRNRSType = class(TXMLNode, IXMLPMTTRNRSType)
  protected
    { IXMLPMTTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetPMTRS: IXMLPMTRSType;
    function GetPMTMODRS: IXMLPMTMODRSType;
    function GetPMTCANCRS: IXMLPMTCANCRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPMTTRNRSTypeList }

  TXMLPMTTRNRSTypeList = class(TXMLNodeCollection, IXMLPMTTRNRSTypeList)
  protected
    { IXMLPMTTRNRSTypeList }
    function Add: IXMLPMTTRNRSType;
    function Insert(const Index: Integer): IXMLPMTTRNRSType;

    function GetItem(Index: Integer): IXMLPMTTRNRSType;
  end;

{ TXMLPMTRSType }

  TXMLPMTRSType = class(TXMLNode, IXMLPMTRSType)
  protected
    { IXMLPMTRSType }
    function GetSRVRTID: UnicodeString;
    function GetPAYEELSTID: UnicodeString;
    function GetCURDEF: UnicodeString;
    function GetPMTINFO: IXMLPMTINFOType;
    function GetEXTDPAYEE: IXMLEXTDPAYEEType;
    function GetCHECKNUM: UnicodeString;
    function GetPMTPRCSTS: IXMLPMTPRCSTSType;
    function GetRECSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
    procedure SetPAYEELSTID(Value: UnicodeString);
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetCHECKNUM(Value: UnicodeString);
    procedure SetRECSRVRTID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPMTPRCSTSType }

  TXMLPMTPRCSTSType = class(TXMLNode, IXMLPMTPRCSTSType)
  protected
    { IXMLPMTPRCSTSType }
    function GetPMTPRCCODE: UnicodeString;
    function GetDTPMTPRC: UnicodeString;
    procedure SetPMTPRCCODE(Value: UnicodeString);
    procedure SetDTPMTPRC(Value: UnicodeString);
  end;

{ TXMLPMTMODRSType }

  TXMLPMTMODRSType = class(TXMLNode, IXMLPMTMODRSType)
  protected
    { IXMLPMTMODRSType }
    function GetSRVRTID: UnicodeString;
    function GetPMTINFO: IXMLPMTINFOType;
    function GetPMTPRCSTS: IXMLPMTPRCSTSType;
    procedure SetSRVRTID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPMTCANCRSType }

  TXMLPMTCANCRSType = class(TXMLNode, IXMLPMTCANCRSType)
  protected
    { IXMLPMTCANCRSType }
    function GetSRVRTID: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
  end;

{ TXMLRECPMTTRNRSType }

  TXMLRECPMTTRNRSType = class(TXMLNode, IXMLRECPMTTRNRSType)
  protected
    { IXMLRECPMTTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetRECPMTRS: IXMLRECPMTRSType;
    function GetRECPMTMODRS: IXMLRECPMTMODRSType;
    function GetRECPMTCANCRS: IXMLRECPMTCANCRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECPMTTRNRSTypeList }

  TXMLRECPMTTRNRSTypeList = class(TXMLNodeCollection, IXMLRECPMTTRNRSTypeList)
  protected
    { IXMLRECPMTTRNRSTypeList }
    function Add: IXMLRECPMTTRNRSType;
    function Insert(const Index: Integer): IXMLRECPMTTRNRSType;

    function GetItem(Index: Integer): IXMLRECPMTTRNRSType;
  end;

{ TXMLRECPMTRSType }

  TXMLRECPMTRSType = class(TXMLNode, IXMLRECPMTRSType)
  protected
    { IXMLRECPMTRSType }
    function GetRECSRVRTID: UnicodeString;
    function GetPAYEELSTID: UnicodeString;
    function GetCURDEF: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetPMTINFO: IXMLPMTINFOType;
    function GetINITIALAMT: UnicodeString;
    function GetFINALAMT: UnicodeString;
    function GetEXTDPAYEE: IXMLEXTDPAYEEType;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetPAYEELSTID(Value: UnicodeString);
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetINITIALAMT(Value: UnicodeString);
    procedure SetFINALAMT(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECPMTMODRSType }

  TXMLRECPMTMODRSType = class(TXMLNode, IXMLRECPMTMODRSType)
  protected
    { IXMLRECPMTMODRSType }
    function GetRECSRVRTID: UnicodeString;
    function GetRECURRINST: IXMLRECURRINSTType;
    function GetPMTINFO: IXMLPMTINFOType;
    function GetINITIALAMT: UnicodeString;
    function GetFINALAMT: UnicodeString;
    function GetMODPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetINITIALAMT(Value: UnicodeString);
    procedure SetFINALAMT(Value: UnicodeString);
    procedure SetMODPENDING(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECPMTCANCRSType }

  TXMLRECPMTCANCRSType = class(TXMLNode, IXMLRECPMTCANCRSType)
  protected
    { IXMLRECPMTCANCRSType }
    function GetRECSRVRTID: UnicodeString;
    function GetCANPENDING: UnicodeString;
    procedure SetRECSRVRTID(Value: UnicodeString);
    procedure SetCANPENDING(Value: UnicodeString);
  end;

{ TXMLPMTINQTRNRSType }

  TXMLPMTINQTRNRSType = class(TXMLNode, IXMLPMTINQTRNRSType)
  protected
    { IXMLPMTINQTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetPMTINQRS: IXMLPMTINQRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPMTINQTRNRSTypeList }

  TXMLPMTINQTRNRSTypeList = class(TXMLNodeCollection, IXMLPMTINQTRNRSTypeList)
  protected
    { IXMLPMTINQTRNRSTypeList }
    function Add: IXMLPMTINQTRNRSType;
    function Insert(const Index: Integer): IXMLPMTINQTRNRSType;

    function GetItem(Index: Integer): IXMLPMTINQTRNRSType;
  end;

{ TXMLPMTINQRSType }

  TXMLPMTINQRSType = class(TXMLNode, IXMLPMTINQRSType)
  protected
    { IXMLPMTINQRSType }
    function GetSRVRTID: UnicodeString;
    function GetPMTPRCSTS: IXMLPMTPRCSTSType;
    function GetCHECKNUM: UnicodeString;
    procedure SetSRVRTID(Value: UnicodeString);
    procedure SetCHECKNUM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPMTMAILTRNRSType }

  TXMLPMTMAILTRNRSType = class(TXMLNode, IXMLPMTMAILTRNRSType)
  protected
    { IXMLPMTMAILTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetPMTMAILRS: IXMLPMTMAILRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPMTMAILTRNRSTypeList }

  TXMLPMTMAILTRNRSTypeList = class(TXMLNodeCollection, IXMLPMTMAILTRNRSTypeList)
  protected
    { IXMLPMTMAILTRNRSTypeList }
    function Add: IXMLPMTMAILTRNRSType;
    function Insert(const Index: Integer): IXMLPMTMAILTRNRSType;

    function GetItem(Index: Integer): IXMLPMTMAILTRNRSType;
  end;

{ TXMLPMTMAILRSType }

  TXMLPMTMAILRSType = class(TXMLNode, IXMLPMTMAILRSType)
  protected
    { IXMLPMTMAILRSType }
    function GetMAIL: IXMLMAILType;
    function GetSRVRTID: UnicodeString;
    function GetPMTINFO: IXMLPMTINFOType;
    procedure SetSRVRTID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPMTSYNCRSType }

  TXMLPMTSYNCRSType = class(TXMLNode, IXMLPMTSYNCRSType)
  private
    FPMTTRNRS: IXMLPMTTRNRSTypeList;
  protected
    { IXMLPMTSYNCRSType }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetPMTTRNRS: IXMLPMTTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPMTSYNCRSTypeList }

  TXMLPMTSYNCRSTypeList = class(TXMLNodeCollection, IXMLPMTSYNCRSTypeList)
  protected
    { IXMLPMTSYNCRSTypeList }
    function Add: IXMLPMTSYNCRSType;
    function Insert(const Index: Integer): IXMLPMTSYNCRSType;

    function GetItem(Index: Integer): IXMLPMTSYNCRSType;
  end;

{ TXMLRECPMTSYNCRSType }

  TXMLRECPMTSYNCRSType = class(TXMLNode, IXMLRECPMTSYNCRSType)
  private
    FRECPMTTRNRS: IXMLRECPMTTRNRSTypeList;
  protected
    { IXMLRECPMTSYNCRSType }
    function GetSYNCRSMACRO: UnicodeString;
    function GetBANKACCTFROM: UnicodeString;
    function GetRECPMTTRNRS: IXMLRECPMTTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
    procedure SetBANKACCTFROM(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRECPMTSYNCRSTypeList }

  TXMLRECPMTSYNCRSTypeList = class(TXMLNodeCollection, IXMLRECPMTSYNCRSTypeList)
  protected
    { IXMLRECPMTSYNCRSTypeList }
    function Add: IXMLRECPMTSYNCRSType;
    function Insert(const Index: Integer): IXMLRECPMTSYNCRSType;

    function GetItem(Index: Integer): IXMLRECPMTSYNCRSType;
  end;

{ TXMLPMTMAILSYNCRSType }

  TXMLPMTMAILSYNCRSType = class(TXMLNode, IXMLPMTMAILSYNCRSType)
  private
    FPMTMAILTRNRS: IXMLPMTMAILTRNRSTypeList;
  protected
    { IXMLPMTMAILSYNCRSType }
    function GetSYNCRSMACRO: UnicodeString;
    function GetPMTMAILTRNRS: IXMLPMTMAILTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPMTMAILSYNCRSTypeList }

  TXMLPMTMAILSYNCRSTypeList = class(TXMLNodeCollection, IXMLPMTMAILSYNCRSTypeList)
  protected
    { IXMLPMTMAILSYNCRSTypeList }
    function Add: IXMLPMTMAILSYNCRSType;
    function Insert(const Index: Integer): IXMLPMTMAILSYNCRSType;

    function GetItem(Index: Integer): IXMLPMTMAILSYNCRSType;
  end;

{ TXMLBILLPAYMSGSETType }

  TXMLBILLPAYMSGSETType = class(TXMLNode, IXMLBILLPAYMSGSETType)
  protected
    { IXMLBILLPAYMSGSETType }
    function GetBILLPAYMSGSETV1: IXMLBILLPAYMSGSETV1Type;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBILLPAYMSGSETV1Type }

  TXMLBILLPAYMSGSETV1Type = class(TXMLNode, IXMLBILLPAYMSGSETV1Type)
  private
    FPROCDAYSOFF: IXMLString_List;
  protected
    { IXMLBILLPAYMSGSETV1Type }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetDAYSWITH: UnicodeString;
    function GetDFLTDAYSTOPAY: UnicodeString;
    function GetXFERDAYSWITH: UnicodeString;
    function GetXFERDFLTDAYSTOPAY: UnicodeString;
    function GetPROCDAYSOFF: IXMLString_List;
    function GetPROCENDTM: UnicodeString;
    function GetMODELWND: UnicodeString;
    function GetPOSTPROCWND: UnicodeString;
    function GetSTSVIAMODS: UnicodeString;
    function GetPMTBYADDR: UnicodeString;
    function GetPMTBYXFER: UnicodeString;
    function GetPMTBYPAYEEID: UnicodeString;
    function GetCANADDPAYEE: UnicodeString;
    function GetHASEXTDPMT: UnicodeString;
    function GetCANMODPMTS: UnicodeString;
    function GetCANMODMDLS: UnicodeString;
    function GetDIFFFIRSTPMT: UnicodeString;
    function GetDIFFLASTPMT: UnicodeString;
    procedure SetDAYSWITH(Value: UnicodeString);
    procedure SetDFLTDAYSTOPAY(Value: UnicodeString);
    procedure SetXFERDAYSWITH(Value: UnicodeString);
    procedure SetXFERDFLTDAYSTOPAY(Value: UnicodeString);
    procedure SetPROCENDTM(Value: UnicodeString);
    procedure SetMODELWND(Value: UnicodeString);
    procedure SetPOSTPROCWND(Value: UnicodeString);
    procedure SetSTSVIAMODS(Value: UnicodeString);
    procedure SetPMTBYADDR(Value: UnicodeString);
    procedure SetPMTBYXFER(Value: UnicodeString);
    procedure SetPMTBYPAYEEID(Value: UnicodeString);
    procedure SetCANADDPAYEE(Value: UnicodeString);
    procedure SetHASEXTDPMT(Value: UnicodeString);
    procedure SetCANMODPMTS(Value: UnicodeString);
    procedure SetCANMODMDLS(Value: UnicodeString);
    procedure SetDIFFFIRSTPMT(Value: UnicodeString);
    procedure SetDIFFLASTPMT(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBPACCTINFOType }

  TXMLBPACCTINFOType = class(TXMLNode, IXMLBPACCTINFOType)
  protected
    { IXMLBPACCTINFOType }
    function GetBANKACCTFROM: UnicodeString;
    function GetSVCSTATUS: UnicodeString;
    procedure SetBANKACCTFROM(Value: UnicodeString);
    procedure SetSVCSTATUS(Value: UnicodeString);
  end;

{ TXMLSIGNUPMSGSRQV1Type }

  TXMLSIGNUPMSGSRQV1Type = class(TXMLNode, IXMLSIGNUPMSGSRQV1Type)
  private
    FENROLLTRNRQ: IXMLENROLLTRNRQTypeList;
    FACCTINFOTRNRQ: IXMLACCTINFOTRNRQTypeList;
    FCHGUSERINFOTRNRQ: IXMLCHGUSERINFOTRNRQTypeList;
    FCHGUSERINFOSYNCRQ: IXMLCHGUSERINFOSYNCRQTypeList;
    FACCTTRNRQ: IXMLACCTTRNRQTypeList;
    FACCTSYNCRQ: IXMLACCTSYNCRQTypeList;
  protected
    { IXMLSIGNUPMSGSRQV1Type }
    function GetENROLLTRNRQ: IXMLENROLLTRNRQTypeList;
    function GetACCTINFOTRNRQ: IXMLACCTINFOTRNRQTypeList;
    function GetCHGUSERINFOTRNRQ: IXMLCHGUSERINFOTRNRQTypeList;
    function GetCHGUSERINFOSYNCRQ: IXMLCHGUSERINFOSYNCRQTypeList;
    function GetACCTTRNRQ: IXMLACCTTRNRQTypeList;
    function GetACCTSYNCRQ: IXMLACCTSYNCRQTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLENROLLTRNRQType }

  TXMLENROLLTRNRQType = class(TXMLNode, IXMLENROLLTRNRQType)
  protected
    { IXMLENROLLTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetENROLLRQ: IXMLENROLLRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLENROLLTRNRQTypeList }

  TXMLENROLLTRNRQTypeList = class(TXMLNodeCollection, IXMLENROLLTRNRQTypeList)
  protected
    { IXMLENROLLTRNRQTypeList }
    function Add: IXMLENROLLTRNRQType;
    function Insert(const Index: Integer): IXMLENROLLTRNRQType;

    function GetItem(Index: Integer): IXMLENROLLTRNRQType;
  end;

{ TXMLENROLLRQType }

  TXMLENROLLRQType = class(TXMLNode, IXMLENROLLRQType)
  protected
    { IXMLENROLLRQType }
    function GetFIRSTNAME: UnicodeString;
    function GetMIDDLENAME: UnicodeString;
    function GetLASTNAME: UnicodeString;
    function GetADDR1: UnicodeString;
    function GetADDR2: UnicodeString;
    function GetADDR3: UnicodeString;
    function GetCITY: UnicodeString;
    function GetSTATE: UnicodeString;
    function GetPOSTALCODE: UnicodeString;
    function GetCOUNTRY: UnicodeString;
    function GetDAYPHONE: UnicodeString;
    function GetEVEPHONE: UnicodeString;
    function GetEMAIL: UnicodeString;
    function GetUSERID: UnicodeString;
    function GetTAXID: UnicodeString;
    function GetSECURITYNAME: UnicodeString;
    function GetDATEBIRTH: UnicodeString;
    function GetACCTFROMMACRO: UnicodeString;
    procedure SetFIRSTNAME(Value: UnicodeString);
    procedure SetMIDDLENAME(Value: UnicodeString);
    procedure SetLASTNAME(Value: UnicodeString);
    procedure SetADDR1(Value: UnicodeString);
    procedure SetADDR2(Value: UnicodeString);
    procedure SetADDR3(Value: UnicodeString);
    procedure SetCITY(Value: UnicodeString);
    procedure SetSTATE(Value: UnicodeString);
    procedure SetPOSTALCODE(Value: UnicodeString);
    procedure SetCOUNTRY(Value: UnicodeString);
    procedure SetDAYPHONE(Value: UnicodeString);
    procedure SetEVEPHONE(Value: UnicodeString);
    procedure SetEMAIL(Value: UnicodeString);
    procedure SetUSERID(Value: UnicodeString);
    procedure SetTAXID(Value: UnicodeString);
    procedure SetSECURITYNAME(Value: UnicodeString);
    procedure SetDATEBIRTH(Value: UnicodeString);
    procedure SetACCTFROMMACRO(Value: UnicodeString);
  end;

{ TXMLACCTINFOTRNRQType }

  TXMLACCTINFOTRNRQType = class(TXMLNode, IXMLACCTINFOTRNRQType)
  protected
    { IXMLACCTINFOTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetACCTINFORQ: IXMLACCTINFORQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLACCTINFOTRNRQTypeList }

  TXMLACCTINFOTRNRQTypeList = class(TXMLNodeCollection, IXMLACCTINFOTRNRQTypeList)
  protected
    { IXMLACCTINFOTRNRQTypeList }
    function Add: IXMLACCTINFOTRNRQType;
    function Insert(const Index: Integer): IXMLACCTINFOTRNRQType;

    function GetItem(Index: Integer): IXMLACCTINFOTRNRQType;
  end;

{ TXMLACCTINFORQType }

  TXMLACCTINFORQType = class(TXMLNode, IXMLACCTINFORQType)
  protected
    { IXMLACCTINFORQType }
    function GetDTACCTUP: UnicodeString;
    procedure SetDTACCTUP(Value: UnicodeString);
  end;

{ TXMLCHGUSERINFOTRNRQType }

  TXMLCHGUSERINFOTRNRQType = class(TXMLNode, IXMLCHGUSERINFOTRNRQType)
  protected
    { IXMLCHGUSERINFOTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetCHGUSERINFORQ: IXMLCHGUSERINFORQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCHGUSERINFOTRNRQTypeList }

  TXMLCHGUSERINFOTRNRQTypeList = class(TXMLNodeCollection, IXMLCHGUSERINFOTRNRQTypeList)
  protected
    { IXMLCHGUSERINFOTRNRQTypeList }
    function Add: IXMLCHGUSERINFOTRNRQType;
    function Insert(const Index: Integer): IXMLCHGUSERINFOTRNRQType;

    function GetItem(Index: Integer): IXMLCHGUSERINFOTRNRQType;
  end;

{ TXMLCHGUSERINFORQType }

  TXMLCHGUSERINFORQType = class(TXMLNode, IXMLCHGUSERINFORQType)
  protected
    { IXMLCHGUSERINFORQType }
    function GetFIRSTNAME: UnicodeString;
    function GetMIDDLENAME: UnicodeString;
    function GetLASTNAME: UnicodeString;
    function GetADDR1: UnicodeString;
    function GetADDR2: UnicodeString;
    function GetADDR3: UnicodeString;
    function GetCITY: UnicodeString;
    function GetSTATE: UnicodeString;
    function GetPOSTALCODE: UnicodeString;
    function GetCOUNTRY: UnicodeString;
    function GetDAYPHONE: UnicodeString;
    function GetEVEPHONE: UnicodeString;
    function GetEMAIL: UnicodeString;
    procedure SetFIRSTNAME(Value: UnicodeString);
    procedure SetMIDDLENAME(Value: UnicodeString);
    procedure SetLASTNAME(Value: UnicodeString);
    procedure SetADDR1(Value: UnicodeString);
    procedure SetADDR2(Value: UnicodeString);
    procedure SetADDR3(Value: UnicodeString);
    procedure SetCITY(Value: UnicodeString);
    procedure SetSTATE(Value: UnicodeString);
    procedure SetPOSTALCODE(Value: UnicodeString);
    procedure SetCOUNTRY(Value: UnicodeString);
    procedure SetDAYPHONE(Value: UnicodeString);
    procedure SetEVEPHONE(Value: UnicodeString);
    procedure SetEMAIL(Value: UnicodeString);
  end;

{ TXMLCHGUSERINFOSYNCRQType }

  TXMLCHGUSERINFOSYNCRQType = class(TXMLNode, IXMLCHGUSERINFOSYNCRQType)
  private
    FCHGUSERINFOTRNRQ: IXMLCHGUSERINFOTRNRQTypeList;
  protected
    { IXMLCHGUSERINFOSYNCRQType }
    function GetSYNCRQMACRO: UnicodeString;
    function GetCHGUSERINFOTRNRQ: IXMLCHGUSERINFOTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCHGUSERINFOSYNCRQTypeList }

  TXMLCHGUSERINFOSYNCRQTypeList = class(TXMLNodeCollection, IXMLCHGUSERINFOSYNCRQTypeList)
  protected
    { IXMLCHGUSERINFOSYNCRQTypeList }
    function Add: IXMLCHGUSERINFOSYNCRQType;
    function Insert(const Index: Integer): IXMLCHGUSERINFOSYNCRQType;

    function GetItem(Index: Integer): IXMLCHGUSERINFOSYNCRQType;
  end;

{ TXMLACCTTRNRQType }

  TXMLACCTTRNRQType = class(TXMLNode, IXMLACCTTRNRQType)
  protected
    { IXMLACCTTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetACCTRQ: IXMLACCTRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLACCTTRNRQTypeList }

  TXMLACCTTRNRQTypeList = class(TXMLNodeCollection, IXMLACCTTRNRQTypeList)
  protected
    { IXMLACCTTRNRQTypeList }
    function Add: IXMLACCTTRNRQType;
    function Insert(const Index: Integer): IXMLACCTTRNRQType;

    function GetItem(Index: Integer): IXMLACCTTRNRQType;
  end;

{ TXMLACCTRQType }

  TXMLACCTRQType = class(TXMLNode, IXMLACCTRQType)
  protected
    { IXMLACCTRQType }
    function GetSVCADD: IXMLSVCADDType;
    function GetSVCCHG: IXMLSVCCHGType;
    function GetSVCDEL: IXMLSVCDELType;
    function GetSVC: UnicodeString;
    procedure SetSVC(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSVCADDType }

  TXMLSVCADDType = class(TXMLNode, IXMLSVCADDType)
  protected
    { IXMLSVCADDType }
    function GetACCTTOMACRO: UnicodeString;
    procedure SetACCTTOMACRO(Value: UnicodeString);
  end;

{ TXMLSVCCHGType }

  TXMLSVCCHGType = class(TXMLNode, IXMLSVCCHGType)
  protected
    { IXMLSVCCHGType }
    function GetACCTFROMMACRO: UnicodeString;
    function GetACCTTOMACRO: UnicodeString;
    procedure SetACCTFROMMACRO(Value: UnicodeString);
    procedure SetACCTTOMACRO(Value: UnicodeString);
  end;

{ TXMLSVCDELType }

  TXMLSVCDELType = class(TXMLNode, IXMLSVCDELType)
  protected
    { IXMLSVCDELType }
    function GetACCTFROMMACRO: UnicodeString;
    procedure SetACCTFROMMACRO(Value: UnicodeString);
  end;

{ TXMLACCTSYNCRQType }

  TXMLACCTSYNCRQType = class(TXMLNode, IXMLACCTSYNCRQType)
  private
    FACCTTRNRQ: IXMLACCTTRNRQTypeList;
  protected
    { IXMLACCTSYNCRQType }
    function GetSYNCRQMACRO: UnicodeString;
    function GetACCTTRNRQ: IXMLACCTTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLACCTSYNCRQTypeList }

  TXMLACCTSYNCRQTypeList = class(TXMLNodeCollection, IXMLACCTSYNCRQTypeList)
  protected
    { IXMLACCTSYNCRQTypeList }
    function Add: IXMLACCTSYNCRQType;
    function Insert(const Index: Integer): IXMLACCTSYNCRQType;

    function GetItem(Index: Integer): IXMLACCTSYNCRQType;
  end;

{ TXMLSIGNUPMSGSRSV1Type }

  TXMLSIGNUPMSGSRSV1Type = class(TXMLNode, IXMLSIGNUPMSGSRSV1Type)
  private
    FENROLLTRNRS: IXMLENROLLTRNRSTypeList;
    FACCTINFOTRNRS: IXMLACCTINFOTRNRSTypeList;
    FCHGUSERINFOTRNRS: IXMLCHGUSERINFOTRNRSTypeList;
    FCHGUSERINFOSYNCRS: IXMLCHGUSERINFOSYNCRSTypeList;
    FACCTTRNRS: IXMLACCTTRNRSTypeList;
    FACCTSYNCRS: IXMLACCTSYNCRSTypeList;
  protected
    { IXMLSIGNUPMSGSRSV1Type }
    function GetENROLLTRNRS: IXMLENROLLTRNRSTypeList;
    function GetACCTINFOTRNRS: IXMLACCTINFOTRNRSTypeList;
    function GetCHGUSERINFOTRNRS: IXMLCHGUSERINFOTRNRSTypeList;
    function GetCHGUSERINFOSYNCRS: IXMLCHGUSERINFOSYNCRSTypeList;
    function GetACCTTRNRS: IXMLACCTTRNRSTypeList;
    function GetACCTSYNCRS: IXMLACCTSYNCRSTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLENROLLTRNRSType }

  TXMLENROLLTRNRSType = class(TXMLNode, IXMLENROLLTRNRSType)
  protected
    { IXMLENROLLTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetENROLLRS: IXMLENROLLRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLENROLLTRNRSTypeList }

  TXMLENROLLTRNRSTypeList = class(TXMLNodeCollection, IXMLENROLLTRNRSTypeList)
  protected
    { IXMLENROLLTRNRSTypeList }
    function Add: IXMLENROLLTRNRSType;
    function Insert(const Index: Integer): IXMLENROLLTRNRSType;

    function GetItem(Index: Integer): IXMLENROLLTRNRSType;
  end;

{ TXMLENROLLRSType }

  TXMLENROLLRSType = class(TXMLNode, IXMLENROLLRSType)
  protected
    { IXMLENROLLRSType }
    function GetTEMPPASS: UnicodeString;
    function GetUSERID: UnicodeString;
    function GetDTEXPIRE: UnicodeString;
    procedure SetTEMPPASS(Value: UnicodeString);
    procedure SetUSERID(Value: UnicodeString);
    procedure SetDTEXPIRE(Value: UnicodeString);
  end;

{ TXMLACCTINFOTRNRSType }

  TXMLACCTINFOTRNRSType = class(TXMLNode, IXMLACCTINFOTRNRSType)
  protected
    { IXMLACCTINFOTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetACCTINFORS: IXMLACCTINFORSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLACCTINFOTRNRSTypeList }

  TXMLACCTINFOTRNRSTypeList = class(TXMLNodeCollection, IXMLACCTINFOTRNRSTypeList)
  protected
    { IXMLACCTINFOTRNRSTypeList }
    function Add: IXMLACCTINFOTRNRSType;
    function Insert(const Index: Integer): IXMLACCTINFOTRNRSType;

    function GetItem(Index: Integer): IXMLACCTINFOTRNRSType;
  end;

{ TXMLACCTINFORSType }

  TXMLACCTINFORSType = class(TXMLNode, IXMLACCTINFORSType)
  private
    FACCTINFO: IXMLACCTINFOTypeList;
  protected
    { IXMLACCTINFORSType }
    function GetDTACCTUP: UnicodeString;
    function GetACCTINFO: IXMLACCTINFOTypeList;
    procedure SetDTACCTUP(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLACCTINFOType }

  TXMLACCTINFOType = class(TXMLNode, IXMLACCTINFOType)
  private
    FACCTINFOMACRO: IXMLString_List;
  protected
    { IXMLACCTINFOType }
    function GetDESC: UnicodeString;
    function GetPHONE: UnicodeString;
    function GetACCTINFOMACRO: IXMLString_List;
    procedure SetDESC(Value: UnicodeString);
    procedure SetPHONE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLACCTINFOTypeList }

  TXMLACCTINFOTypeList = class(TXMLNodeCollection, IXMLACCTINFOTypeList)
  protected
    { IXMLACCTINFOTypeList }
    function Add: IXMLACCTINFOType;
    function Insert(const Index: Integer): IXMLACCTINFOType;

    function GetItem(Index: Integer): IXMLACCTINFOType;
  end;

{ TXMLCHGUSERINFOTRNRSType }

  TXMLCHGUSERINFOTRNRSType = class(TXMLNode, IXMLCHGUSERINFOTRNRSType)
  protected
    { IXMLCHGUSERINFOTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetCHGUSERINFORS: IXMLCHGUSERINFORSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCHGUSERINFOTRNRSTypeList }

  TXMLCHGUSERINFOTRNRSTypeList = class(TXMLNodeCollection, IXMLCHGUSERINFOTRNRSTypeList)
  protected
    { IXMLCHGUSERINFOTRNRSTypeList }
    function Add: IXMLCHGUSERINFOTRNRSType;
    function Insert(const Index: Integer): IXMLCHGUSERINFOTRNRSType;

    function GetItem(Index: Integer): IXMLCHGUSERINFOTRNRSType;
  end;

{ TXMLCHGUSERINFORSType }

  TXMLCHGUSERINFORSType = class(TXMLNode, IXMLCHGUSERINFORSType)
  protected
    { IXMLCHGUSERINFORSType }
    function GetFIRSTNAME: UnicodeString;
    function GetMIDDLENAME: UnicodeString;
    function GetLASTNAME: UnicodeString;
    function GetADDR1: UnicodeString;
    function GetADDR2: UnicodeString;
    function GetADDR3: UnicodeString;
    function GetCITY: UnicodeString;
    function GetSTATE: UnicodeString;
    function GetPOSTALCODE: UnicodeString;
    function GetCOUNTRY: UnicodeString;
    function GetDAYPHONE: UnicodeString;
    function GetEVEPHONE: UnicodeString;
    function GetEMAIL: UnicodeString;
    function GetDTINFOCHG: UnicodeString;
    procedure SetFIRSTNAME(Value: UnicodeString);
    procedure SetMIDDLENAME(Value: UnicodeString);
    procedure SetLASTNAME(Value: UnicodeString);
    procedure SetADDR1(Value: UnicodeString);
    procedure SetADDR2(Value: UnicodeString);
    procedure SetADDR3(Value: UnicodeString);
    procedure SetCITY(Value: UnicodeString);
    procedure SetSTATE(Value: UnicodeString);
    procedure SetPOSTALCODE(Value: UnicodeString);
    procedure SetCOUNTRY(Value: UnicodeString);
    procedure SetDAYPHONE(Value: UnicodeString);
    procedure SetEVEPHONE(Value: UnicodeString);
    procedure SetEMAIL(Value: UnicodeString);
    procedure SetDTINFOCHG(Value: UnicodeString);
  end;

{ TXMLCHGUSERINFOSYNCRSType }

  TXMLCHGUSERINFOSYNCRSType = class(TXMLNode, IXMLCHGUSERINFOSYNCRSType)
  private
    FCHGUSERINFOTRNRS: IXMLCHGUSERINFOTRNRSTypeList;
  protected
    { IXMLCHGUSERINFOSYNCRSType }
    function GetSYNCRSMACRO: UnicodeString;
    function GetCHGUSERINFOTRNRS: IXMLCHGUSERINFOTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCHGUSERINFOSYNCRSTypeList }

  TXMLCHGUSERINFOSYNCRSTypeList = class(TXMLNodeCollection, IXMLCHGUSERINFOSYNCRSTypeList)
  protected
    { IXMLCHGUSERINFOSYNCRSTypeList }
    function Add: IXMLCHGUSERINFOSYNCRSType;
    function Insert(const Index: Integer): IXMLCHGUSERINFOSYNCRSType;

    function GetItem(Index: Integer): IXMLCHGUSERINFOSYNCRSType;
  end;

{ TXMLACCTTRNRSType }

  TXMLACCTTRNRSType = class(TXMLNode, IXMLACCTTRNRSType)
  protected
    { IXMLACCTTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetACCTRS: IXMLACCTRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLACCTTRNRSTypeList }

  TXMLACCTTRNRSTypeList = class(TXMLNodeCollection, IXMLACCTTRNRSTypeList)
  protected
    { IXMLACCTTRNRSTypeList }
    function Add: IXMLACCTTRNRSType;
    function Insert(const Index: Integer): IXMLACCTTRNRSType;

    function GetItem(Index: Integer): IXMLACCTTRNRSType;
  end;

{ TXMLACCTRSType }

  TXMLACCTRSType = class(TXMLNode, IXMLACCTRSType)
  protected
    { IXMLACCTRSType }
    function GetSVCADD: IXMLSVCADDType;
    function GetSVCCHG: IXMLSVCCHGType;
    function GetSVCDEL: IXMLSVCDELType;
    function GetSVC: UnicodeString;
    function GetSVCSTATUS: UnicodeString;
    procedure SetSVC(Value: UnicodeString);
    procedure SetSVCSTATUS(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLACCTSYNCRSType }

  TXMLACCTSYNCRSType = class(TXMLNode, IXMLACCTSYNCRSType)
  private
    FACCTTRNRS: IXMLACCTTRNRSTypeList;
  protected
    { IXMLACCTSYNCRSType }
    function GetSYNCRSMACRO: UnicodeString;
    function GetACCTTRNRS: IXMLACCTTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLACCTSYNCRSTypeList }

  TXMLACCTSYNCRSTypeList = class(TXMLNodeCollection, IXMLACCTSYNCRSTypeList)
  protected
    { IXMLACCTSYNCRSTypeList }
    function Add: IXMLACCTSYNCRSType;
    function Insert(const Index: Integer): IXMLACCTSYNCRSType;

    function GetItem(Index: Integer): IXMLACCTSYNCRSType;
  end;

{ TXMLSIGNUPMSGSETType }

  TXMLSIGNUPMSGSETType = class(TXMLNode, IXMLSIGNUPMSGSETType)
  protected
    { IXMLSIGNUPMSGSETType }
    function GetSIGNUPMSGSETV1: IXMLSIGNUPMSGSETV1Type;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSIGNUPMSGSETV1Type }

  TXMLSIGNUPMSGSETV1Type = class(TXMLNode, IXMLSIGNUPMSGSETV1Type)
  protected
    { IXMLSIGNUPMSGSETV1Type }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetCLIENTENROLL: IXMLCLIENTENROLLType;
    function GetWEBENROLL: IXMLWEBENROLLType;
    function GetOTHERENROLL: IXMLOTHERENROLLType;
    function GetCHGUSERINFO: UnicodeString;
    function GetAVAILACCTS: UnicodeString;
    function GetCLIENTACTREQ: UnicodeString;
    procedure SetCHGUSERINFO(Value: UnicodeString);
    procedure SetAVAILACCTS(Value: UnicodeString);
    procedure SetCLIENTACTREQ(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCLIENTENROLLType }

  TXMLCLIENTENROLLType = class(TXMLNode, IXMLCLIENTENROLLType)
  protected
    { IXMLCLIENTENROLLType }
    function GetACCTREQUIRED: UnicodeString;
    procedure SetACCTREQUIRED(Value: UnicodeString);
  end;

{ TXMLWEBENROLLType }

  TXMLWEBENROLLType = class(TXMLNode, IXMLWEBENROLLType)
  protected
    { IXMLWEBENROLLType }
    function GetURL: UnicodeString;
    procedure SetURL(Value: UnicodeString);
  end;

{ TXMLOTHERENROLLType }

  TXMLOTHERENROLLType = class(TXMLNode, IXMLOTHERENROLLType)
  protected
    { IXMLOTHERENROLLType }
    function GetMESSAGE: UnicodeString;
    procedure SetMESSAGE(Value: UnicodeString);
  end;

{ TXMLINVSTMTMSGSRQV1Type }

  TXMLINVSTMTMSGSRQV1Type = class(TXMLNode, IXMLINVSTMTMSGSRQV1Type)
  private
    FINVSTMTTRNRQ: IXMLINVSTMTTRNRQType;
    FINVMAILTRNRQ: IXMLINVMAILTRNRQTypeList;
    FINVMAILSYNCRQ: IXMLINVMAILSYNCRQTypeList;
  protected
    { IXMLINVSTMTMSGSRQV1Type }
    function GetINVSTMTTRNRQ: IXMLINVSTMTTRNRQType;
    function GetINVMAILTRNRQ: IXMLINVMAILTRNRQTypeList;
    function GetINVMAILSYNCRQ: IXMLINVMAILSYNCRQTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVSTMTTRNRQType }

  TXMLINVSTMTTRNRQType = class(TXMLNode, IXMLINVSTMTTRNRQType)
  protected
    { IXMLINVSTMTTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetINVSTMTRQ: IXMLINVSTMTRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVSTMTRQType }

  TXMLINVSTMTRQType = class(TXMLNode, IXMLINVSTMTRQType)
  protected
    { IXMLINVSTMTRQType }
    function GetINVACCTFROM: IXMLINVACCTFROMType;
    function GetINCTRAN: IXMLINCTRANType;
    function GetINCOO: UnicodeString;
    function GetINCPOS: IXMLINCPOSType;
    function GetINCBAL: UnicodeString;
    procedure SetINCOO(Value: UnicodeString);
    procedure SetINCBAL(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVACCTFROMType }

  TXMLINVACCTFROMType = class(TXMLNode, IXMLINVACCTFROMType)
  protected
    { IXMLINVACCTFROMType }
    function GetBROKERID: UnicodeString;
    function GetACCTID: UnicodeString;
    procedure SetBROKERID(Value: UnicodeString);
    procedure SetACCTID(Value: UnicodeString);
  end;

{ TXMLINCPOSType }

  TXMLINCPOSType = class(TXMLNode, IXMLINCPOSType)
  protected
    { IXMLINCPOSType }
    function GetDTASOF: UnicodeString;
    function GetINCLUDE: UnicodeString;
    procedure SetDTASOF(Value: UnicodeString);
    procedure SetINCLUDE(Value: UnicodeString);
  end;

{ TXMLINVMAILTRNRQType }

  TXMLINVMAILTRNRQType = class(TXMLNode, IXMLINVMAILTRNRQType)
  protected
    { IXMLINVMAILTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetINVMAILRQ: IXMLINVMAILRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVMAILTRNRQTypeList }

  TXMLINVMAILTRNRQTypeList = class(TXMLNodeCollection, IXMLINVMAILTRNRQTypeList)
  protected
    { IXMLINVMAILTRNRQTypeList }
    function Add: IXMLINVMAILTRNRQType;
    function Insert(const Index: Integer): IXMLINVMAILTRNRQType;

    function GetItem(Index: Integer): IXMLINVMAILTRNRQType;
  end;

{ TXMLINVMAILRQType }

  TXMLINVMAILRQType = class(TXMLNode, IXMLINVMAILRQType)
  protected
    { IXMLINVMAILRQType }
    function GetINVACCTFROM: IXMLINVACCTFROMType;
    function GetMAIL: IXMLMAILType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVMAILSYNCRQType }

  TXMLINVMAILSYNCRQType = class(TXMLNode, IXMLINVMAILSYNCRQType)
  private
    FINVMAILTRNRQ: IXMLINVMAILTRNRQTypeList;
  protected
    { IXMLINVMAILSYNCRQType }
    function GetSYNCRQMACRO: UnicodeString;
    function GetINCIMAGES: UnicodeString;
    function GetUSEHTML: UnicodeString;
    function GetINVACCTFROM: IXMLINVACCTFROMType;
    function GetINVMAILTRNRQ: IXMLINVMAILTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetINCIMAGES(Value: UnicodeString);
    procedure SetUSEHTML(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVMAILSYNCRQTypeList }

  TXMLINVMAILSYNCRQTypeList = class(TXMLNodeCollection, IXMLINVMAILSYNCRQTypeList)
  protected
    { IXMLINVMAILSYNCRQTypeList }
    function Add: IXMLINVMAILSYNCRQType;
    function Insert(const Index: Integer): IXMLINVMAILSYNCRQType;

    function GetItem(Index: Integer): IXMLINVMAILSYNCRQType;
  end;

{ TXMLINVSTMTMSGSRSV1Type }

  TXMLINVSTMTMSGSRSV1Type = class(TXMLNode, IXMLINVSTMTMSGSRSV1Type)
  private
    FINVSTMTTRNRS: IXMLINVSTMTTRNRSTypeList;
    FINVMAILTRNRS: IXMLINVMAILTRNRSTypeList;
    FINVMAILSYNCRS: IXMLINVMAILSYNCRSTypeList;
  protected
    { IXMLINVSTMTMSGSRSV1Type }
    function GetINVSTMTTRNRS: IXMLINVSTMTTRNRSTypeList;
    function GetINVMAILTRNRS: IXMLINVMAILTRNRSTypeList;
    function GetINVMAILSYNCRS: IXMLINVMAILSYNCRSTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVSTMTTRNRSType }

  TXMLINVSTMTTRNRSType = class(TXMLNode, IXMLINVSTMTTRNRSType)
  protected
    { IXMLINVSTMTTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetINVSTMTRS: IXMLINVSTMTRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVSTMTTRNRSTypeList }

  TXMLINVSTMTTRNRSTypeList = class(TXMLNodeCollection, IXMLINVSTMTTRNRSTypeList)
  protected
    { IXMLINVSTMTTRNRSTypeList }
    function Add: IXMLINVSTMTTRNRSType;
    function Insert(const Index: Integer): IXMLINVSTMTTRNRSType;

    function GetItem(Index: Integer): IXMLINVSTMTTRNRSType;
  end;

{ TXMLINVSTMTRSType }

  TXMLINVSTMTRSType = class(TXMLNode, IXMLINVSTMTRSType)
  protected
    { IXMLINVSTMTRSType }
    function GetDTASOF: UnicodeString;
    function GetCURDEF: UnicodeString;
    function GetINVACCTFROM: IXMLINVACCTFROMType;
    function GetINVTRANLIST: IXMLINVTRANLISTType;
    function GetINVPOSLIST: IXMLINVPOSLISTType;
    function GetINVBAL: IXMLINVBALType;
    function GetINVOOLIST: IXMLINVOOLISTType;
    function GetMKTGINFO: UnicodeString;
    procedure SetDTASOF(Value: UnicodeString);
    procedure SetCURDEF(Value: UnicodeString);
    procedure SetMKTGINFO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVTRANLISTType }

  TXMLINVTRANLISTType = class(TXMLNode, IXMLINVTRANLISTType)
  private
    FBUYDEBT: IXMLBUYDEBTTypeList;
    FBUYMF: IXMLBUYMFTypeList;
    FBUYOPT: IXMLBUYOPTTypeList;
    FBUYOTHER: IXMLBUYOTHERTypeList;
    FBUYSTOCK: IXMLBUYSTOCKTypeList;
    FCLOSUREOPT: IXMLCLOSUREOPTTypeList;
    FINCOME: IXMLINCOMETypeList;
    FINVEXPENSE: IXMLINVEXPENSETypeList;
    FJRNLFUND: IXMLJRNLFUNDTypeList;
    FJRNLSEC: IXMLJRNLSECTypeList;
    FMARGININTEREST: IXMLMARGININTERESTTypeList;
    FREINVEST: IXMLREINVESTTypeList;
    FRETOFCAP: IXMLRETOFCAPTypeList;
    FSELLDEBT: IXMLSELLDEBTTypeList;
    FSELLMF: IXMLSELLMFTypeList;
    FSELLOPT: IXMLSELLOPTTypeList;
    FSELLOTHER: IXMLSELLOTHERTypeList;
    FSELLSTOCK: IXMLSELLSTOCKTypeList;
    FSPLIT: IXMLSPLITTypeList;
    FTRANSFER: IXMLTRANSFERTypeList;
    FINVBANKTRAN: IXMLINVBANKTRANTypeList;
  protected
    { IXMLINVTRANLISTType }
    function GetDTSTART: UnicodeString;
    function GetDTEND: UnicodeString;
    function GetBUYDEBT: IXMLBUYDEBTTypeList;
    function GetBUYMF: IXMLBUYMFTypeList;
    function GetBUYOPT: IXMLBUYOPTTypeList;
    function GetBUYOTHER: IXMLBUYOTHERTypeList;
    function GetBUYSTOCK: IXMLBUYSTOCKTypeList;
    function GetCLOSUREOPT: IXMLCLOSUREOPTTypeList;
    function GetINCOME: IXMLINCOMETypeList;
    function GetINVEXPENSE: IXMLINVEXPENSETypeList;
    function GetJRNLFUND: IXMLJRNLFUNDTypeList;
    function GetJRNLSEC: IXMLJRNLSECTypeList;
    function GetMARGININTEREST: IXMLMARGININTERESTTypeList;
    function GetREINVEST: IXMLREINVESTTypeList;
    function GetRETOFCAP: IXMLRETOFCAPTypeList;
    function GetSELLDEBT: IXMLSELLDEBTTypeList;
    function GetSELLMF: IXMLSELLMFTypeList;
    function GetSELLOPT: IXMLSELLOPTTypeList;
    function GetSELLOTHER: IXMLSELLOTHERTypeList;
    function GetSELLSTOCK: IXMLSELLSTOCKTypeList;
    function GetSPLIT: IXMLSPLITTypeList;
    function GetTRANSFER: IXMLTRANSFERTypeList;
    function GetINVBANKTRAN: IXMLINVBANKTRANTypeList;
    procedure SetDTSTART(Value: UnicodeString);
    procedure SetDTEND(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBUYDEBTType }

  TXMLBUYDEBTType = class(TXMLNode, IXMLBUYDEBTType)
  protected
    { IXMLBUYDEBTType }
    function GetINVBUY: IXMLINVBUYType;
    function GetACCRDINT: UnicodeString;
    procedure SetACCRDINT(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBUYDEBTTypeList }

  TXMLBUYDEBTTypeList = class(TXMLNodeCollection, IXMLBUYDEBTTypeList)
  protected
    { IXMLBUYDEBTTypeList }
    function Add: IXMLBUYDEBTType;
    function Insert(const Index: Integer): IXMLBUYDEBTType;

    function GetItem(Index: Integer): IXMLBUYDEBTType;
  end;

{ TXMLINVBUYType }

  TXMLINVBUYType = class(TXMLNode, IXMLINVBUYType)
  protected
    { IXMLINVBUYType }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetUNITS: UnicodeString;
    function GetUNITPRICE: UnicodeString;
    function GetMARKUP: UnicodeString;
    function GetCOMMISSION: UnicodeString;
    function GetTAXES: UnicodeString;
    function GetFEES: UnicodeString;
    function GetLOAD: UnicodeString;
    function GetTOTAL: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    function GetSUBACCTSEC: UnicodeString;
    function GetSUBACCTFUND: IXMLSUBACCTFUNDType;
    procedure SetUNITS(Value: UnicodeString);
    procedure SetUNITPRICE(Value: UnicodeString);
    procedure SetMARKUP(Value: UnicodeString);
    procedure SetCOMMISSION(Value: UnicodeString);
    procedure SetTAXES(Value: UnicodeString);
    procedure SetFEES(Value: UnicodeString);
    procedure SetLOAD(Value: UnicodeString);
    procedure SetTOTAL(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
    procedure SetSUBACCTSEC(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVTRANType }

  TXMLINVTRANType = class(TXMLNode, IXMLINVTRANType)
  protected
    { IXMLINVTRANType }
    function GetFITID: UnicodeString;
    function GetSRVRTID: UnicodeString;
    function GetDTTRADE: UnicodeString;
    function GetDTSETTLE: UnicodeString;
    function GetMEMO: UnicodeString;
    procedure SetFITID(Value: UnicodeString);
    procedure SetSRVRTID(Value: UnicodeString);
    procedure SetDTTRADE(Value: UnicodeString);
    procedure SetDTSETTLE(Value: UnicodeString);
    procedure SetMEMO(Value: UnicodeString);
  end;

{ TXMLSECIDType }

  TXMLSECIDType = class(TXMLNode, IXMLSECIDType)
  protected
    { IXMLSECIDType }
    function GetUNIQUEID: UnicodeString;
    function GetUNIQUEIDTYPE: UnicodeString;
    procedure SetUNIQUEID(Value: UnicodeString);
    procedure SetUNIQUEIDTYPE(Value: UnicodeString);
  end;

{ TXMLSUBACCTFUNDType }

  TXMLSUBACCTFUNDType = class(TXMLNode, IXMLSUBACCTFUNDType)
  protected
    { IXMLSUBACCTFUNDType }
    function GetSTRTYPE: UnicodeString;
    procedure SetSTRTYPE(Value: UnicodeString);
  end;

{ TXMLBUYMFType }

  TXMLBUYMFType = class(TXMLNode, IXMLBUYMFType)
  protected
    { IXMLBUYMFType }
    function GetINVBUY: IXMLINVBUYType;
    function GetBUYTYPE: UnicodeString;
    function GetRELFITID: UnicodeString;
    procedure SetBUYTYPE(Value: UnicodeString);
    procedure SetRELFITID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBUYMFTypeList }

  TXMLBUYMFTypeList = class(TXMLNodeCollection, IXMLBUYMFTypeList)
  protected
    { IXMLBUYMFTypeList }
    function Add: IXMLBUYMFType;
    function Insert(const Index: Integer): IXMLBUYMFType;

    function GetItem(Index: Integer): IXMLBUYMFType;
  end;

{ TXMLBUYOPTType }

  TXMLBUYOPTType = class(TXMLNode, IXMLBUYOPTType)
  protected
    { IXMLBUYOPTType }
    function GetINVBUY: IXMLINVBUYType;
    function GetOPTBUYTYPE: UnicodeString;
    function GetSHPERCTRCT: UnicodeString;
    procedure SetOPTBUYTYPE(Value: UnicodeString);
    procedure SetSHPERCTRCT(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBUYOPTTypeList }

  TXMLBUYOPTTypeList = class(TXMLNodeCollection, IXMLBUYOPTTypeList)
  protected
    { IXMLBUYOPTTypeList }
    function Add: IXMLBUYOPTType;
    function Insert(const Index: Integer): IXMLBUYOPTType;

    function GetItem(Index: Integer): IXMLBUYOPTType;
  end;

{ TXMLBUYOTHERType }

  TXMLBUYOTHERType = class(TXMLNode, IXMLBUYOTHERType)
  protected
    { IXMLBUYOTHERType }
    function GetINVBUY: IXMLINVBUYType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBUYOTHERTypeList }

  TXMLBUYOTHERTypeList = class(TXMLNodeCollection, IXMLBUYOTHERTypeList)
  protected
    { IXMLBUYOTHERTypeList }
    function Add: IXMLBUYOTHERType;
    function Insert(const Index: Integer): IXMLBUYOTHERType;

    function GetItem(Index: Integer): IXMLBUYOTHERType;
  end;

{ TXMLBUYSTOCKType }

  TXMLBUYSTOCKType = class(TXMLNode, IXMLBUYSTOCKType)
  protected
    { IXMLBUYSTOCKType }
    function GetINVBUY: IXMLINVBUYType;
    function GetBUYTYPE: UnicodeString;
    procedure SetBUYTYPE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBUYSTOCKTypeList }

  TXMLBUYSTOCKTypeList = class(TXMLNodeCollection, IXMLBUYSTOCKTypeList)
  protected
    { IXMLBUYSTOCKTypeList }
    function Add: IXMLBUYSTOCKType;
    function Insert(const Index: Integer): IXMLBUYSTOCKType;

    function GetItem(Index: Integer): IXMLBUYSTOCKType;
  end;

{ TXMLCLOSUREOPTType }

  TXMLCLOSUREOPTType = class(TXMLNode, IXMLCLOSUREOPTType)
  protected
    { IXMLCLOSUREOPTType }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetOPTACTION: UnicodeString;
    function GetUNITS: UnicodeString;
    function GetSHPERCTRCT: UnicodeString;
    function GetSUBACCTSEC: UnicodeString;
    function GetRELFITID: UnicodeString;
    function GetGAIN: UnicodeString;
    procedure SetOPTACTION(Value: UnicodeString);
    procedure SetUNITS(Value: UnicodeString);
    procedure SetSHPERCTRCT(Value: UnicodeString);
    procedure SetSUBACCTSEC(Value: UnicodeString);
    procedure SetRELFITID(Value: UnicodeString);
    procedure SetGAIN(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCLOSUREOPTTypeList }

  TXMLCLOSUREOPTTypeList = class(TXMLNodeCollection, IXMLCLOSUREOPTTypeList)
  protected
    { IXMLCLOSUREOPTTypeList }
    function Add: IXMLCLOSUREOPTType;
    function Insert(const Index: Integer): IXMLCLOSUREOPTType;

    function GetItem(Index: Integer): IXMLCLOSUREOPTType;
  end;

{ TXMLINCOMEType }

  TXMLINCOMEType = class(TXMLNode, IXMLINCOMEType)
  protected
    { IXMLINCOMEType }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetINCOMETYPE: UnicodeString;
    function GetTOTAL: UnicodeString;
    function GetSUBACCTSEC: UnicodeString;
    function GetSUBACCTFUND: IXMLSUBACCTFUNDType;
    function GetTAXEXEMPT: UnicodeString;
    function GetWITHHOLDING: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetINCOMETYPE(Value: UnicodeString);
    procedure SetTOTAL(Value: UnicodeString);
    procedure SetSUBACCTSEC(Value: UnicodeString);
    procedure SetTAXEXEMPT(Value: UnicodeString);
    procedure SetWITHHOLDING(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINCOMETypeList }

  TXMLINCOMETypeList = class(TXMLNodeCollection, IXMLINCOMETypeList)
  protected
    { IXMLINCOMETypeList }
    function Add: IXMLINCOMEType;
    function Insert(const Index: Integer): IXMLINCOMEType;

    function GetItem(Index: Integer): IXMLINCOMEType;
  end;

{ TXMLINVEXPENSEType }

  TXMLINVEXPENSEType = class(TXMLNode, IXMLINVEXPENSEType)
  protected
    { IXMLINVEXPENSEType }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetTOTAL: UnicodeString;
    function GetSUBACCTSEC: UnicodeString;
    function GetSUBACCTFUND: IXMLSUBACCTFUNDType;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetTOTAL(Value: UnicodeString);
    procedure SetSUBACCTSEC(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVEXPENSETypeList }

  TXMLINVEXPENSETypeList = class(TXMLNodeCollection, IXMLINVEXPENSETypeList)
  protected
    { IXMLINVEXPENSETypeList }
    function Add: IXMLINVEXPENSEType;
    function Insert(const Index: Integer): IXMLINVEXPENSEType;

    function GetItem(Index: Integer): IXMLINVEXPENSEType;
  end;

{ TXMLJRNLFUNDType }

  TXMLJRNLFUNDType = class(TXMLNode, IXMLJRNLFUNDType)
  protected
    { IXMLJRNLFUNDType }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSUBACCTTO: UnicodeString;
    function GetSUBACCTFROM: UnicodeString;
    function GetTOTAL: UnicodeString;
    procedure SetSUBACCTTO(Value: UnicodeString);
    procedure SetSUBACCTFROM(Value: UnicodeString);
    procedure SetTOTAL(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLJRNLFUNDTypeList }

  TXMLJRNLFUNDTypeList = class(TXMLNodeCollection, IXMLJRNLFUNDTypeList)
  protected
    { IXMLJRNLFUNDTypeList }
    function Add: IXMLJRNLFUNDType;
    function Insert(const Index: Integer): IXMLJRNLFUNDType;

    function GetItem(Index: Integer): IXMLJRNLFUNDType;
  end;

{ TXMLJRNLSECType }

  TXMLJRNLSECType = class(TXMLNode, IXMLJRNLSECType)
  protected
    { IXMLJRNLSECType }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetSUBACCTTO: UnicodeString;
    function GetSUBACCTFROM: UnicodeString;
    function GetUNITS: UnicodeString;
    procedure SetSUBACCTTO(Value: UnicodeString);
    procedure SetSUBACCTFROM(Value: UnicodeString);
    procedure SetUNITS(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLJRNLSECTypeList }

  TXMLJRNLSECTypeList = class(TXMLNodeCollection, IXMLJRNLSECTypeList)
  protected
    { IXMLJRNLSECTypeList }
    function Add: IXMLJRNLSECType;
    function Insert(const Index: Integer): IXMLJRNLSECType;

    function GetItem(Index: Integer): IXMLJRNLSECType;
  end;

{ TXMLMARGININTERESTType }

  TXMLMARGININTERESTType = class(TXMLNode, IXMLMARGININTERESTType)
  protected
    { IXMLMARGININTERESTType }
    function GetINVTRAN: IXMLINVTRANType;
    function GetTOTAL: UnicodeString;
    function GetSUBACCTFUND: IXMLSUBACCTFUNDType;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetTOTAL(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMARGININTERESTTypeList }

  TXMLMARGININTERESTTypeList = class(TXMLNodeCollection, IXMLMARGININTERESTTypeList)
  protected
    { IXMLMARGININTERESTTypeList }
    function Add: IXMLMARGININTERESTType;
    function Insert(const Index: Integer): IXMLMARGININTERESTType;

    function GetItem(Index: Integer): IXMLMARGININTERESTType;
  end;

{ TXMLREINVESTType }

  TXMLREINVESTType = class(TXMLNode, IXMLREINVESTType)
  protected
    { IXMLREINVESTType }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetINCOMETYPE: UnicodeString;
    function GetTOTAL: UnicodeString;
    function GetSUBACCTSEC: UnicodeString;
    function GetUNITS: UnicodeString;
    function GetUNITPRICE: UnicodeString;
    function GetCOMMISSION: UnicodeString;
    function GetTAXES: UnicodeString;
    function GetFEES: UnicodeString;
    function GetLOAD: UnicodeString;
    function GetTAXEXEMPT: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetINCOMETYPE(Value: UnicodeString);
    procedure SetTOTAL(Value: UnicodeString);
    procedure SetSUBACCTSEC(Value: UnicodeString);
    procedure SetUNITS(Value: UnicodeString);
    procedure SetUNITPRICE(Value: UnicodeString);
    procedure SetCOMMISSION(Value: UnicodeString);
    procedure SetTAXES(Value: UnicodeString);
    procedure SetFEES(Value: UnicodeString);
    procedure SetLOAD(Value: UnicodeString);
    procedure SetTAXEXEMPT(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLREINVESTTypeList }

  TXMLREINVESTTypeList = class(TXMLNodeCollection, IXMLREINVESTTypeList)
  protected
    { IXMLREINVESTTypeList }
    function Add: IXMLREINVESTType;
    function Insert(const Index: Integer): IXMLREINVESTType;

    function GetItem(Index: Integer): IXMLREINVESTType;
  end;

{ TXMLRETOFCAPType }

  TXMLRETOFCAPType = class(TXMLNode, IXMLRETOFCAPType)
  protected
    { IXMLRETOFCAPType }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetTOTAL: UnicodeString;
    function GetSUBACCTSEC: UnicodeString;
    function GetSUBACCTFUND: IXMLSUBACCTFUNDType;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    procedure SetTOTAL(Value: UnicodeString);
    procedure SetSUBACCTSEC(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRETOFCAPTypeList }

  TXMLRETOFCAPTypeList = class(TXMLNodeCollection, IXMLRETOFCAPTypeList)
  protected
    { IXMLRETOFCAPTypeList }
    function Add: IXMLRETOFCAPType;
    function Insert(const Index: Integer): IXMLRETOFCAPType;

    function GetItem(Index: Integer): IXMLRETOFCAPType;
  end;

{ TXMLSELLDEBTType }

  TXMLSELLDEBTType = class(TXMLNode, IXMLSELLDEBTType)
  protected
    { IXMLSELLDEBTType }
    function GetINVSELL: IXMLINVSELLType;
    function GetSELLREASON: UnicodeString;
    function GetACCRDINT: UnicodeString;
    procedure SetSELLREASON(Value: UnicodeString);
    procedure SetACCRDINT(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSELLDEBTTypeList }

  TXMLSELLDEBTTypeList = class(TXMLNodeCollection, IXMLSELLDEBTTypeList)
  protected
    { IXMLSELLDEBTTypeList }
    function Add: IXMLSELLDEBTType;
    function Insert(const Index: Integer): IXMLSELLDEBTType;

    function GetItem(Index: Integer): IXMLSELLDEBTType;
  end;

{ TXMLINVSELLType }

  TXMLINVSELLType = class(TXMLNode, IXMLINVSELLType)
  protected
    { IXMLINVSELLType }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetUNITS: UnicodeString;
    function GetUNITPRICE: UnicodeString;
    function GetMARKDOWN: UnicodeString;
    function GetCOMMISSION: UnicodeString;
    function GetTAXES: UnicodeString;
    function GetFEES: UnicodeString;
    function GetLOAD: UnicodeString;
    function GetWITHHOLDING: UnicodeString;
    function GetTAXEXEMPT: UnicodeString;
    function GetTOTAL: UnicodeString;
    function GetGAIN: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    function GetSUBACCTSEC: UnicodeString;
    function GetSUBACCTFUND: IXMLSUBACCTFUNDType;
    procedure SetUNITS(Value: UnicodeString);
    procedure SetUNITPRICE(Value: UnicodeString);
    procedure SetMARKDOWN(Value: UnicodeString);
    procedure SetCOMMISSION(Value: UnicodeString);
    procedure SetTAXES(Value: UnicodeString);
    procedure SetFEES(Value: UnicodeString);
    procedure SetLOAD(Value: UnicodeString);
    procedure SetWITHHOLDING(Value: UnicodeString);
    procedure SetTAXEXEMPT(Value: UnicodeString);
    procedure SetTOTAL(Value: UnicodeString);
    procedure SetGAIN(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
    procedure SetSUBACCTSEC(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSELLMFType }

  TXMLSELLMFType = class(TXMLNode, IXMLSELLMFType)
  protected
    { IXMLSELLMFType }
    function GetINVSELL: IXMLINVSELLType;
    function GetSELLTYPE: UnicodeString;
    function GetAVGCOSTBASIS: UnicodeString;
    function GetRELFITID: UnicodeString;
    procedure SetSELLTYPE(Value: UnicodeString);
    procedure SetAVGCOSTBASIS(Value: UnicodeString);
    procedure SetRELFITID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSELLMFTypeList }

  TXMLSELLMFTypeList = class(TXMLNodeCollection, IXMLSELLMFTypeList)
  protected
    { IXMLSELLMFTypeList }
    function Add: IXMLSELLMFType;
    function Insert(const Index: Integer): IXMLSELLMFType;

    function GetItem(Index: Integer): IXMLSELLMFType;
  end;

{ TXMLSELLOPTType }

  TXMLSELLOPTType = class(TXMLNode, IXMLSELLOPTType)
  protected
    { IXMLSELLOPTType }
    function GetINVSELL: IXMLINVSELLType;
    function GetOPTSELLTYPE: UnicodeString;
    function GetSHPERCTRCT: UnicodeString;
    function GetRELFITID: UnicodeString;
    function GetRELTYPE: UnicodeString;
    function GetSECURED: UnicodeString;
    procedure SetOPTSELLTYPE(Value: UnicodeString);
    procedure SetSHPERCTRCT(Value: UnicodeString);
    procedure SetRELFITID(Value: UnicodeString);
    procedure SetRELTYPE(Value: UnicodeString);
    procedure SetSECURED(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSELLOPTTypeList }

  TXMLSELLOPTTypeList = class(TXMLNodeCollection, IXMLSELLOPTTypeList)
  protected
    { IXMLSELLOPTTypeList }
    function Add: IXMLSELLOPTType;
    function Insert(const Index: Integer): IXMLSELLOPTType;

    function GetItem(Index: Integer): IXMLSELLOPTType;
  end;

{ TXMLSELLOTHERType }

  TXMLSELLOTHERType = class(TXMLNode, IXMLSELLOTHERType)
  protected
    { IXMLSELLOTHERType }
    function GetINVSELL: IXMLINVSELLType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSELLOTHERTypeList }

  TXMLSELLOTHERTypeList = class(TXMLNodeCollection, IXMLSELLOTHERTypeList)
  protected
    { IXMLSELLOTHERTypeList }
    function Add: IXMLSELLOTHERType;
    function Insert(const Index: Integer): IXMLSELLOTHERType;

    function GetItem(Index: Integer): IXMLSELLOTHERType;
  end;

{ TXMLSELLSTOCKType }

  TXMLSELLSTOCKType = class(TXMLNode, IXMLSELLSTOCKType)
  protected
    { IXMLSELLSTOCKType }
    function GetINVSELL: IXMLINVSELLType;
    function GetSELLTYPE: UnicodeString;
    procedure SetSELLTYPE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSELLSTOCKTypeList }

  TXMLSELLSTOCKTypeList = class(TXMLNodeCollection, IXMLSELLSTOCKTypeList)
  protected
    { IXMLSELLSTOCKTypeList }
    function Add: IXMLSELLSTOCKType;
    function Insert(const Index: Integer): IXMLSELLSTOCKType;

    function GetItem(Index: Integer): IXMLSELLSTOCKType;
  end;

{ TXMLSPLITType }

  TXMLSPLITType = class(TXMLNode, IXMLSPLITType)
  protected
    { IXMLSPLITType }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetSUBACCTSEC: UnicodeString;
    function GetOLDUNITS: UnicodeString;
    function GetNEWUNITS: UnicodeString;
    function GetNUMERATOR: UnicodeString;
    function GetDENOMINATOR: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetORIGCURRENCY: UnicodeString;
    function GetFRACCASH: UnicodeString;
    function GetSUBACCTFUND: IXMLSUBACCTFUNDType;
    procedure SetSUBACCTSEC(Value: UnicodeString);
    procedure SetOLDUNITS(Value: UnicodeString);
    procedure SetNEWUNITS(Value: UnicodeString);
    procedure SetNUMERATOR(Value: UnicodeString);
    procedure SetDENOMINATOR(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetORIGCURRENCY(Value: UnicodeString);
    procedure SetFRACCASH(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSPLITTypeList }

  TXMLSPLITTypeList = class(TXMLNodeCollection, IXMLSPLITTypeList)
  protected
    { IXMLSPLITTypeList }
    function Add: IXMLSPLITType;
    function Insert(const Index: Integer): IXMLSPLITType;

    function GetItem(Index: Integer): IXMLSPLITType;
  end;

{ TXMLTRANSFERType }

  TXMLTRANSFERType = class(TXMLNode, IXMLTRANSFERType)
  protected
    { IXMLTRANSFERType }
    function GetINVTRAN: IXMLINVTRANType;
    function GetSECID: IXMLSECIDType;
    function GetSUBACCTSEC: UnicodeString;
    function GetUNITS: UnicodeString;
    function GetTFERACTION: UnicodeString;
    function GetPOSTYPE: UnicodeString;
    function GetINVACCTFROM: IXMLINVACCTFROMType;
    function GetAVGCOSTBASIS: UnicodeString;
    function GetUNITPRICE: UnicodeString;
    function GetDTPURCHASE: UnicodeString;
    procedure SetSUBACCTSEC(Value: UnicodeString);
    procedure SetUNITS(Value: UnicodeString);
    procedure SetTFERACTION(Value: UnicodeString);
    procedure SetPOSTYPE(Value: UnicodeString);
    procedure SetAVGCOSTBASIS(Value: UnicodeString);
    procedure SetUNITPRICE(Value: UnicodeString);
    procedure SetDTPURCHASE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTRANSFERTypeList }

  TXMLTRANSFERTypeList = class(TXMLNodeCollection, IXMLTRANSFERTypeList)
  protected
    { IXMLTRANSFERTypeList }
    function Add: IXMLTRANSFERType;
    function Insert(const Index: Integer): IXMLTRANSFERType;

    function GetItem(Index: Integer): IXMLTRANSFERType;
  end;

{ TXMLINVBANKTRANType }

  TXMLINVBANKTRANType = class(TXMLNode, IXMLINVBANKTRANType)
  protected
    { IXMLINVBANKTRANType }
    function GetSTMTTRN: IXMLSTMTTRNType;
    function GetSUBACCTFUND: IXMLSUBACCTFUNDType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVBANKTRANTypeList }

  TXMLINVBANKTRANTypeList = class(TXMLNodeCollection, IXMLINVBANKTRANTypeList)
  protected
    { IXMLINVBANKTRANTypeList }
    function Add: IXMLINVBANKTRANType;
    function Insert(const Index: Integer): IXMLINVBANKTRANType;

    function GetItem(Index: Integer): IXMLINVBANKTRANType;
  end;

{ TXMLINVPOSLISTType }

  TXMLINVPOSLISTType = class(TXMLNode, IXMLINVPOSLISTType)
  private
    FPOSMF: IXMLPOSMFTypeList;
    FPOSSTOCK: IXMLPOSSTOCKTypeList;
    FPOSDEBT: IXMLPOSDEBTTypeList;
    FPOSOPT: IXMLPOSOPTTypeList;
    FPOSOTHER: IXMLPOSOTHERTypeList;
  protected
    { IXMLINVPOSLISTType }
    function GetPOSMF: IXMLPOSMFTypeList;
    function GetPOSSTOCK: IXMLPOSSTOCKTypeList;
    function GetPOSDEBT: IXMLPOSDEBTTypeList;
    function GetPOSOPT: IXMLPOSOPTTypeList;
    function GetPOSOTHER: IXMLPOSOTHERTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPOSMFType }

  TXMLPOSMFType = class(TXMLNode, IXMLPOSMFType)
  protected
    { IXMLPOSMFType }
    function GetINVPOS: IXMLINVPOSType;
    function GetUNITSSTREET: UnicodeString;
    function GetUNITSUSER: UnicodeString;
    function GetREINVDIV: UnicodeString;
    function GetREINVCG: UnicodeString;
    procedure SetUNITSSTREET(Value: UnicodeString);
    procedure SetUNITSUSER(Value: UnicodeString);
    procedure SetREINVDIV(Value: UnicodeString);
    procedure SetREINVCG(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPOSMFTypeList }

  TXMLPOSMFTypeList = class(TXMLNodeCollection, IXMLPOSMFTypeList)
  protected
    { IXMLPOSMFTypeList }
    function Add: IXMLPOSMFType;
    function Insert(const Index: Integer): IXMLPOSMFType;

    function GetItem(Index: Integer): IXMLPOSMFType;
  end;

{ TXMLINVPOSType }

  TXMLINVPOSType = class(TXMLNode, IXMLINVPOSType)
  protected
    { IXMLINVPOSType }
    function GetSECID: IXMLSECIDType;
    function GetHELDINACCT: UnicodeString;
    function GetPOSTYPE: UnicodeString;
    function GetUNITS: UnicodeString;
    function GetUNITPRICE: UnicodeString;
    function GetMKTVAL: UnicodeString;
    function GetDTPRICEASOF: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetMEMO: UnicodeString;
    procedure SetHELDINACCT(Value: UnicodeString);
    procedure SetPOSTYPE(Value: UnicodeString);
    procedure SetUNITS(Value: UnicodeString);
    procedure SetUNITPRICE(Value: UnicodeString);
    procedure SetMKTVAL(Value: UnicodeString);
    procedure SetDTPRICEASOF(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetMEMO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPOSSTOCKType }

  TXMLPOSSTOCKType = class(TXMLNode, IXMLPOSSTOCKType)
  protected
    { IXMLPOSSTOCKType }
    function GetINVPOS: IXMLINVPOSType;
    function GetUNITSSTREET: UnicodeString;
    function GetUNITSUSER: UnicodeString;
    function GetREINVDIV: UnicodeString;
    procedure SetUNITSSTREET(Value: UnicodeString);
    procedure SetUNITSUSER(Value: UnicodeString);
    procedure SetREINVDIV(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPOSSTOCKTypeList }

  TXMLPOSSTOCKTypeList = class(TXMLNodeCollection, IXMLPOSSTOCKTypeList)
  protected
    { IXMLPOSSTOCKTypeList }
    function Add: IXMLPOSSTOCKType;
    function Insert(const Index: Integer): IXMLPOSSTOCKType;

    function GetItem(Index: Integer): IXMLPOSSTOCKType;
  end;

{ TXMLPOSDEBTType }

  TXMLPOSDEBTType = class(TXMLNode, IXMLPOSDEBTType)
  protected
    { IXMLPOSDEBTType }
    function GetINVPOS: IXMLINVPOSType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPOSDEBTTypeList }

  TXMLPOSDEBTTypeList = class(TXMLNodeCollection, IXMLPOSDEBTTypeList)
  protected
    { IXMLPOSDEBTTypeList }
    function Add: IXMLPOSDEBTType;
    function Insert(const Index: Integer): IXMLPOSDEBTType;

    function GetItem(Index: Integer): IXMLPOSDEBTType;
  end;

{ TXMLPOSOPTType }

  TXMLPOSOPTType = class(TXMLNode, IXMLPOSOPTType)
  protected
    { IXMLPOSOPTType }
    function GetINVPOS: IXMLINVPOSType;
    function GetSECURED: UnicodeString;
    procedure SetSECURED(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPOSOPTTypeList }

  TXMLPOSOPTTypeList = class(TXMLNodeCollection, IXMLPOSOPTTypeList)
  protected
    { IXMLPOSOPTTypeList }
    function Add: IXMLPOSOPTType;
    function Insert(const Index: Integer): IXMLPOSOPTType;

    function GetItem(Index: Integer): IXMLPOSOPTType;
  end;

{ TXMLPOSOTHERType }

  TXMLPOSOTHERType = class(TXMLNode, IXMLPOSOTHERType)
  protected
    { IXMLPOSOTHERType }
    function GetINVPOS: IXMLINVPOSType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPOSOTHERTypeList }

  TXMLPOSOTHERTypeList = class(TXMLNodeCollection, IXMLPOSOTHERTypeList)
  protected
    { IXMLPOSOTHERTypeList }
    function Add: IXMLPOSOTHERType;
    function Insert(const Index: Integer): IXMLPOSOTHERType;

    function GetItem(Index: Integer): IXMLPOSOTHERType;
  end;

{ TXMLINVBALType }

  TXMLINVBALType = class(TXMLNode, IXMLINVBALType)
  protected
    { IXMLINVBALType }
    function GetAVAILCASH: UnicodeString;
    function GetMARGINBALANCE: UnicodeString;
    function GetSHORTBALANCE: UnicodeString;
    function GetBUYPOWER: UnicodeString;
    function GetBALLIST: IXMLBALLISTType;
    procedure SetAVAILCASH(Value: UnicodeString);
    procedure SetMARGINBALANCE(Value: UnicodeString);
    procedure SetSHORTBALANCE(Value: UnicodeString);
    procedure SetBUYPOWER(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBALLISTType }

  TXMLBALLISTType = class(TXMLNodeCollection, IXMLBALLISTType)
  protected
    { IXMLBALLISTType }
    function GetBAL(Index: Integer): IXMLBALType;
    function Add: IXMLBALType;
    function Insert(const Index: Integer): IXMLBALType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBALType }

  TXMLBALType = class(TXMLNode, IXMLBALType)
  protected
    { IXMLBALType }
    function GetNAME: UnicodeString;
    function GetDESC: UnicodeString;
    function GetBALTYPE: UnicodeString;
    function GetVALUE: UnicodeString;
    function GetDTASOF: UnicodeString;
    function GetCURRENCY: UnicodeString;
    procedure SetNAME(Value: UnicodeString);
    procedure SetDESC(Value: UnicodeString);
    procedure SetBALTYPE(Value: UnicodeString);
    procedure SetVALUE(Value: UnicodeString);
    procedure SetDTASOF(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
  end;

{ TXMLINVOOLISTType }

  TXMLINVOOLISTType = class(TXMLNode, IXMLINVOOLISTType)
  private
    FOOBUYDEBT: IXMLOOBUYDEBTTypeList;
    FOOBUYMF: IXMLOOBUYMFTypeList;
    FOOBUYOPT: IXMLOOBUYOPTTypeList;
    FOOBUYOTHER: IXMLOOBUYOTHERTypeList;
    FOOBUYSTOCK: IXMLOOBUYSTOCKTypeList;
    FOOSELLDEBT: IXMLOOSELLDEBTTypeList;
    FOOSELLMF: IXMLOOSELLMFTypeList;
    FOOSELLOPT: IXMLOOSELLOPTTypeList;
    FOOSELLOTHER: IXMLOOSELLOTHERTypeList;
    FOOSELLSTOCK: IXMLOOSELLSTOCKTypeList;
    FOOSWITCHMF: IXMLOOSWITCHMFTypeList;
  protected
    { IXMLINVOOLISTType }
    function GetOOBUYDEBT: IXMLOOBUYDEBTTypeList;
    function GetOOBUYMF: IXMLOOBUYMFTypeList;
    function GetOOBUYOPT: IXMLOOBUYOPTTypeList;
    function GetOOBUYOTHER: IXMLOOBUYOTHERTypeList;
    function GetOOBUYSTOCK: IXMLOOBUYSTOCKTypeList;
    function GetOOSELLDEBT: IXMLOOSELLDEBTTypeList;
    function GetOOSELLMF: IXMLOOSELLMFTypeList;
    function GetOOSELLOPT: IXMLOOSELLOPTTypeList;
    function GetOOSELLOTHER: IXMLOOSELLOTHERTypeList;
    function GetOOSELLSTOCK: IXMLOOSELLSTOCKTypeList;
    function GetOOSWITCHMF: IXMLOOSWITCHMFTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOOBUYDEBTType }

  TXMLOOBUYDEBTType = class(TXMLNode, IXMLOOBUYDEBTType)
  protected
    { IXMLOOBUYDEBTType }
    function GetOO: IXMLOOType;
    function GetAUCTION: UnicodeString;
    function GetDTAUCTION: UnicodeString;
    procedure SetAUCTION(Value: UnicodeString);
    procedure SetDTAUCTION(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOOBUYDEBTTypeList }

  TXMLOOBUYDEBTTypeList = class(TXMLNodeCollection, IXMLOOBUYDEBTTypeList)
  protected
    { IXMLOOBUYDEBTTypeList }
    function Add: IXMLOOBUYDEBTType;
    function Insert(const Index: Integer): IXMLOOBUYDEBTType;

    function GetItem(Index: Integer): IXMLOOBUYDEBTType;
  end;

{ TXMLOOType }

  TXMLOOType = class(TXMLNode, IXMLOOType)
  protected
    { IXMLOOType }
    function GetFITID: UnicodeString;
    function GetSRVRTID: UnicodeString;
    function GetSECID: IXMLSECIDType;
    function GetDTPLACED: UnicodeString;
    function GetUNITS: UnicodeString;
    function GetSUBACCT: UnicodeString;
    function GetDURATION: UnicodeString;
    function GetRESTRICTION: UnicodeString;
    function GetMINUNITS: UnicodeString;
    function GetLIMITPRICE: UnicodeString;
    function GetSTOPPRICE: UnicodeString;
    function GetMEMO: UnicodeString;
    function GetCURRENCY: UnicodeString;
    procedure SetFITID(Value: UnicodeString);
    procedure SetSRVRTID(Value: UnicodeString);
    procedure SetDTPLACED(Value: UnicodeString);
    procedure SetUNITS(Value: UnicodeString);
    procedure SetSUBACCT(Value: UnicodeString);
    procedure SetDURATION(Value: UnicodeString);
    procedure SetRESTRICTION(Value: UnicodeString);
    procedure SetMINUNITS(Value: UnicodeString);
    procedure SetLIMITPRICE(Value: UnicodeString);
    procedure SetSTOPPRICE(Value: UnicodeString);
    procedure SetMEMO(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOOBUYMFType }

  TXMLOOBUYMFType = class(TXMLNode, IXMLOOBUYMFType)
  protected
    { IXMLOOBUYMFType }
    function GetOO: IXMLOOType;
    function GetBUYTYPE: UnicodeString;
    function GetUNITTYPE: UnicodeString;
    procedure SetBUYTYPE(Value: UnicodeString);
    procedure SetUNITTYPE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOOBUYMFTypeList }

  TXMLOOBUYMFTypeList = class(TXMLNodeCollection, IXMLOOBUYMFTypeList)
  protected
    { IXMLOOBUYMFTypeList }
    function Add: IXMLOOBUYMFType;
    function Insert(const Index: Integer): IXMLOOBUYMFType;

    function GetItem(Index: Integer): IXMLOOBUYMFType;
  end;

{ TXMLOOBUYOPTType }

  TXMLOOBUYOPTType = class(TXMLNode, IXMLOOBUYOPTType)
  protected
    { IXMLOOBUYOPTType }
    function GetOO: IXMLOOType;
    function GetOPTBUYTYPE: UnicodeString;
    procedure SetOPTBUYTYPE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOOBUYOPTTypeList }

  TXMLOOBUYOPTTypeList = class(TXMLNodeCollection, IXMLOOBUYOPTTypeList)
  protected
    { IXMLOOBUYOPTTypeList }
    function Add: IXMLOOBUYOPTType;
    function Insert(const Index: Integer): IXMLOOBUYOPTType;

    function GetItem(Index: Integer): IXMLOOBUYOPTType;
  end;

{ TXMLOOBUYOTHERType }

  TXMLOOBUYOTHERType = class(TXMLNode, IXMLOOBUYOTHERType)
  protected
    { IXMLOOBUYOTHERType }
    function GetOO: IXMLOOType;
    function GetUNITTYPE: UnicodeString;
    procedure SetUNITTYPE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOOBUYOTHERTypeList }

  TXMLOOBUYOTHERTypeList = class(TXMLNodeCollection, IXMLOOBUYOTHERTypeList)
  protected
    { IXMLOOBUYOTHERTypeList }
    function Add: IXMLOOBUYOTHERType;
    function Insert(const Index: Integer): IXMLOOBUYOTHERType;

    function GetItem(Index: Integer): IXMLOOBUYOTHERType;
  end;

{ TXMLOOBUYSTOCKType }

  TXMLOOBUYSTOCKType = class(TXMLNode, IXMLOOBUYSTOCKType)
  protected
    { IXMLOOBUYSTOCKType }
    function GetOO: IXMLOOType;
    function GetBUYTYPE: UnicodeString;
    procedure SetBUYTYPE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOOBUYSTOCKTypeList }

  TXMLOOBUYSTOCKTypeList = class(TXMLNodeCollection, IXMLOOBUYSTOCKTypeList)
  protected
    { IXMLOOBUYSTOCKTypeList }
    function Add: IXMLOOBUYSTOCKType;
    function Insert(const Index: Integer): IXMLOOBUYSTOCKType;

    function GetItem(Index: Integer): IXMLOOBUYSTOCKType;
  end;

{ TXMLOOSELLDEBTType }

  TXMLOOSELLDEBTType = class(TXMLNode, IXMLOOSELLDEBTType)
  protected
    { IXMLOOSELLDEBTType }
    function GetOO: IXMLOOType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOOSELLDEBTTypeList }

  TXMLOOSELLDEBTTypeList = class(TXMLNodeCollection, IXMLOOSELLDEBTTypeList)
  protected
    { IXMLOOSELLDEBTTypeList }
    function Add: IXMLOOSELLDEBTType;
    function Insert(const Index: Integer): IXMLOOSELLDEBTType;

    function GetItem(Index: Integer): IXMLOOSELLDEBTType;
  end;

{ TXMLOOSELLMFType }

  TXMLOOSELLMFType = class(TXMLNode, IXMLOOSELLMFType)
  protected
    { IXMLOOSELLMFType }
    function GetOO: IXMLOOType;
    function GetSELLTYPE: UnicodeString;
    function GetUNITTYPE: UnicodeString;
    function GetSELLALL: UnicodeString;
    procedure SetSELLTYPE(Value: UnicodeString);
    procedure SetUNITTYPE(Value: UnicodeString);
    procedure SetSELLALL(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOOSELLMFTypeList }

  TXMLOOSELLMFTypeList = class(TXMLNodeCollection, IXMLOOSELLMFTypeList)
  protected
    { IXMLOOSELLMFTypeList }
    function Add: IXMLOOSELLMFType;
    function Insert(const Index: Integer): IXMLOOSELLMFType;

    function GetItem(Index: Integer): IXMLOOSELLMFType;
  end;

{ TXMLOOSELLOPTType }

  TXMLOOSELLOPTType = class(TXMLNode, IXMLOOSELLOPTType)
  protected
    { IXMLOOSELLOPTType }
    function GetOO: IXMLOOType;
    function GetOPTSELLTYPE: UnicodeString;
    procedure SetOPTSELLTYPE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOOSELLOPTTypeList }

  TXMLOOSELLOPTTypeList = class(TXMLNodeCollection, IXMLOOSELLOPTTypeList)
  protected
    { IXMLOOSELLOPTTypeList }
    function Add: IXMLOOSELLOPTType;
    function Insert(const Index: Integer): IXMLOOSELLOPTType;

    function GetItem(Index: Integer): IXMLOOSELLOPTType;
  end;

{ TXMLOOSELLOTHERType }

  TXMLOOSELLOTHERType = class(TXMLNode, IXMLOOSELLOTHERType)
  protected
    { IXMLOOSELLOTHERType }
    function GetOO: IXMLOOType;
    function GetUNITTYPE: UnicodeString;
    procedure SetUNITTYPE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOOSELLOTHERTypeList }

  TXMLOOSELLOTHERTypeList = class(TXMLNodeCollection, IXMLOOSELLOTHERTypeList)
  protected
    { IXMLOOSELLOTHERTypeList }
    function Add: IXMLOOSELLOTHERType;
    function Insert(const Index: Integer): IXMLOOSELLOTHERType;

    function GetItem(Index: Integer): IXMLOOSELLOTHERType;
  end;

{ TXMLOOSELLSTOCKType }

  TXMLOOSELLSTOCKType = class(TXMLNode, IXMLOOSELLSTOCKType)
  protected
    { IXMLOOSELLSTOCKType }
    function GetOO: IXMLOOType;
    function GetSELLTYPE: UnicodeString;
    procedure SetSELLTYPE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOOSELLSTOCKTypeList }

  TXMLOOSELLSTOCKTypeList = class(TXMLNodeCollection, IXMLOOSELLSTOCKTypeList)
  protected
    { IXMLOOSELLSTOCKTypeList }
    function Add: IXMLOOSELLSTOCKType;
    function Insert(const Index: Integer): IXMLOOSELLSTOCKType;

    function GetItem(Index: Integer): IXMLOOSELLSTOCKType;
  end;

{ TXMLOOSWITCHMFType }

  TXMLOOSWITCHMFType = class(TXMLNode, IXMLOOSWITCHMFType)
  protected
    { IXMLOOSWITCHMFType }
    function GetOO: IXMLOOType;
    function GetSECID: IXMLSECIDType;
    function GetUNITTYPE: UnicodeString;
    function GetSWITCHALL: UnicodeString;
    procedure SetUNITTYPE(Value: UnicodeString);
    procedure SetSWITCHALL(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOOSWITCHMFTypeList }

  TXMLOOSWITCHMFTypeList = class(TXMLNodeCollection, IXMLOOSWITCHMFTypeList)
  protected
    { IXMLOOSWITCHMFTypeList }
    function Add: IXMLOOSWITCHMFType;
    function Insert(const Index: Integer): IXMLOOSWITCHMFType;

    function GetItem(Index: Integer): IXMLOOSWITCHMFType;
  end;

{ TXMLINVMAILTRNRSType }

  TXMLINVMAILTRNRSType = class(TXMLNode, IXMLINVMAILTRNRSType)
  protected
    { IXMLINVMAILTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetINVMAILRS: IXMLINVMAILRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVMAILTRNRSTypeList }

  TXMLINVMAILTRNRSTypeList = class(TXMLNodeCollection, IXMLINVMAILTRNRSTypeList)
  protected
    { IXMLINVMAILTRNRSTypeList }
    function Add: IXMLINVMAILTRNRSType;
    function Insert(const Index: Integer): IXMLINVMAILTRNRSType;

    function GetItem(Index: Integer): IXMLINVMAILTRNRSType;
  end;

{ TXMLINVMAILRSType }

  TXMLINVMAILRSType = class(TXMLNode, IXMLINVMAILRSType)
  protected
    { IXMLINVMAILRSType }
    function GetINVACCTFROM: IXMLINVACCTFROMType;
    function GetMAIL: IXMLMAILType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVMAILSYNCRSType }

  TXMLINVMAILSYNCRSType = class(TXMLNode, IXMLINVMAILSYNCRSType)
  private
    FINVMAILTRNRS: IXMLINVMAILTRNRSTypeList;
  protected
    { IXMLINVMAILSYNCRSType }
    function GetSYNCRSMACRO: UnicodeString;
    function GetINVACCTFROM: IXMLINVACCTFROMType;
    function GetINVMAILTRNRS: IXMLINVMAILTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVMAILSYNCRSTypeList }

  TXMLINVMAILSYNCRSTypeList = class(TXMLNodeCollection, IXMLINVMAILSYNCRSTypeList)
  protected
    { IXMLINVMAILSYNCRSTypeList }
    function Add: IXMLINVMAILSYNCRSType;
    function Insert(const Index: Integer): IXMLINVMAILSYNCRSType;

    function GetItem(Index: Integer): IXMLINVMAILSYNCRSType;
  end;

{ TXMLSECLISTMSGSRQV1Type }

  TXMLSECLISTMSGSRQV1Type = class(TXMLNodeCollection, IXMLSECLISTMSGSRQV1Type)
  protected
    { IXMLSECLISTMSGSRQV1Type }
    function GetSECLISTTRNRQ(Index: Integer): IXMLSECLISTTRNRQType;
    function Add: IXMLSECLISTTRNRQType;
    function Insert(const Index: Integer): IXMLSECLISTTRNRQType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSECLISTTRNRQType }

  TXMLSECLISTTRNRQType = class(TXMLNode, IXMLSECLISTTRNRQType)
  protected
    { IXMLSECLISTTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetSECLISTRQ: IXMLSECLISTRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSECLISTRQType }

  TXMLSECLISTRQType = class(TXMLNodeCollection, IXMLSECLISTRQType)
  protected
    { IXMLSECLISTRQType }
    function GetSECRQ(Index: Integer): IXMLSECRQType;
    function Add: IXMLSECRQType;
    function Insert(const Index: Integer): IXMLSECRQType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSECRQType }

  TXMLSECRQType = class(TXMLNode, IXMLSECRQType)
  protected
    { IXMLSECRQType }
    function GetSECID: IXMLSECIDType;
    function GetTICKER: UnicodeString;
    function GetFIID: UnicodeString;
    procedure SetTICKER(Value: UnicodeString);
    procedure SetFIID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSECLISTMSGSRSV1Type }

  TXMLSECLISTMSGSRSV1Type = class(TXMLNode, IXMLSECLISTMSGSRSV1Type)
  private
    FSECLISTTRNRS: IXMLSECLISTTRNRSTypeList;
  protected
    { IXMLSECLISTMSGSRSV1Type }
    function GetSECLISTTRNRS: IXMLSECLISTTRNRSTypeList;
    function GetSECLIST: IXMLSECLISTType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSECLISTTRNRSType }

  TXMLSECLISTTRNRSType = class(TXMLNode, IXMLSECLISTTRNRSType)
  protected
    { IXMLSECLISTTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetSECLISTRS: UnicodeString;
    procedure SetTRNRSMACRO(Value: UnicodeString);
    procedure SetSECLISTRS(Value: UnicodeString);
  end;

{ TXMLSECLISTTRNRSTypeList }

  TXMLSECLISTTRNRSTypeList = class(TXMLNodeCollection, IXMLSECLISTTRNRSTypeList)
  protected
    { IXMLSECLISTTRNRSTypeList }
    function Add: IXMLSECLISTTRNRSType;
    function Insert(const Index: Integer): IXMLSECLISTTRNRSType;

    function GetItem(Index: Integer): IXMLSECLISTTRNRSType;
  end;

{ TXMLSECLISTType }

  TXMLSECLISTType = class(TXMLNode, IXMLSECLISTType)
  private
    FMFINFO: IXMLMFINFOTypeList;
    FSTOCKINFO: IXMLSTOCKINFOTypeList;
    FOPTINFO: IXMLOPTINFOTypeList;
    FDEBTINFO: IXMLDEBTINFOTypeList;
    FOTHERINFO: IXMLOTHERINFOTypeList;
  protected
    { IXMLSECLISTType }
    function GetMFINFO: IXMLMFINFOTypeList;
    function GetSTOCKINFO: IXMLSTOCKINFOTypeList;
    function GetOPTINFO: IXMLOPTINFOTypeList;
    function GetDEBTINFO: IXMLDEBTINFOTypeList;
    function GetOTHERINFO: IXMLOTHERINFOTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMFINFOType }

  TXMLMFINFOType = class(TXMLNode, IXMLMFINFOType)
  protected
    { IXMLMFINFOType }
    function GetSECINFO: IXMLSECINFOType;
    function GetMFTYPE: UnicodeString;
    function GetYIELD: UnicodeString;
    function GetDTYIELDASOF: UnicodeString;
    function GetMFASSETCLASS: IXMLMFASSETCLASSType;
    function GetFIMFASSETCLASS: IXMLFIMFASSETCLASSType;
    procedure SetMFTYPE(Value: UnicodeString);
    procedure SetYIELD(Value: UnicodeString);
    procedure SetDTYIELDASOF(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMFINFOTypeList }

  TXMLMFINFOTypeList = class(TXMLNodeCollection, IXMLMFINFOTypeList)
  protected
    { IXMLMFINFOTypeList }
    function Add: IXMLMFINFOType;
    function Insert(const Index: Integer): IXMLMFINFOType;

    function GetItem(Index: Integer): IXMLMFINFOType;
  end;

{ TXMLSECINFOType }

  TXMLSECINFOType = class(TXMLNode, IXMLSECINFOType)
  protected
    { IXMLSECINFOType }
    function GetSECID: IXMLSECIDType;
    function GetSECNAME: UnicodeString;
    function GetTICKER: UnicodeString;
    function GetFIID: UnicodeString;
    function GetRATING: UnicodeString;
    function GetUNITPRICE: UnicodeString;
    function GetDTASOF: UnicodeString;
    function GetCURRENCY: UnicodeString;
    function GetMEMO: UnicodeString;
    procedure SetSECNAME(Value: UnicodeString);
    procedure SetTICKER(Value: UnicodeString);
    procedure SetFIID(Value: UnicodeString);
    procedure SetRATING(Value: UnicodeString);
    procedure SetUNITPRICE(Value: UnicodeString);
    procedure SetDTASOF(Value: UnicodeString);
    procedure SetCURRENCY(Value: UnicodeString);
    procedure SetMEMO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMFASSETCLASSType }

  TXMLMFASSETCLASSType = class(TXMLNodeCollection, IXMLMFASSETCLASSType)
  protected
    { IXMLMFASSETCLASSType }
    function GetPORTION(Index: Integer): IXMLPORTIONType;
    function Add: IXMLPORTIONType;
    function Insert(const Index: Integer): IXMLPORTIONType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPORTIONType }

  TXMLPORTIONType = class(TXMLNode, IXMLPORTIONType)
  protected
    { IXMLPORTIONType }
    function GetASSETCLASS: UnicodeString;
    function GetPERCENT: UnicodeString;
    procedure SetASSETCLASS(Value: UnicodeString);
    procedure SetPERCENT(Value: UnicodeString);
  end;

{ TXMLFIMFASSETCLASSType }

  TXMLFIMFASSETCLASSType = class(TXMLNodeCollection, IXMLFIMFASSETCLASSType)
  protected
    { IXMLFIMFASSETCLASSType }
    function GetFIPORTION(Index: Integer): IXMLFIPORTIONType;
    function Add: IXMLFIPORTIONType;
    function Insert(const Index: Integer): IXMLFIPORTIONType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLFIPORTIONType }

  TXMLFIPORTIONType = class(TXMLNode, IXMLFIPORTIONType)
  protected
    { IXMLFIPORTIONType }
    function GetFIASSETCLASS: UnicodeString;
    function GetPERCENT: UnicodeString;
    procedure SetFIASSETCLASS(Value: UnicodeString);
    procedure SetPERCENT(Value: UnicodeString);
  end;

{ TXMLSTOCKINFOType }

  TXMLSTOCKINFOType = class(TXMLNode, IXMLSTOCKINFOType)
  protected
    { IXMLSTOCKINFOType }
    function GetSECINFO: IXMLSECINFOType;
    function GetSTOCKTYPE: UnicodeString;
    function GetYIELD: UnicodeString;
    function GetDTYIELDASOF: UnicodeString;
    function GetASSETCLASS: UnicodeString;
    function GetFIASSETCLASS: UnicodeString;
    procedure SetSTOCKTYPE(Value: UnicodeString);
    procedure SetYIELD(Value: UnicodeString);
    procedure SetDTYIELDASOF(Value: UnicodeString);
    procedure SetASSETCLASS(Value: UnicodeString);
    procedure SetFIASSETCLASS(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSTOCKINFOTypeList }

  TXMLSTOCKINFOTypeList = class(TXMLNodeCollection, IXMLSTOCKINFOTypeList)
  protected
    { IXMLSTOCKINFOTypeList }
    function Add: IXMLSTOCKINFOType;
    function Insert(const Index: Integer): IXMLSTOCKINFOType;

    function GetItem(Index: Integer): IXMLSTOCKINFOType;
  end;

{ TXMLOPTINFOType }

  TXMLOPTINFOType = class(TXMLNode, IXMLOPTINFOType)
  protected
    { IXMLOPTINFOType }
    function GetSECINFO: IXMLSECINFOType;
    function GetOPTTYPE: UnicodeString;
    function GetSTRIKEPRICE: UnicodeString;
    function GetDTEXPIRE: UnicodeString;
    function GetSHPERCTRCT: UnicodeString;
    function GetSECID: IXMLSECIDType;
    function GetASSETCLASS: UnicodeString;
    function GetFIASSETCLASS: UnicodeString;
    procedure SetOPTTYPE(Value: UnicodeString);
    procedure SetSTRIKEPRICE(Value: UnicodeString);
    procedure SetDTEXPIRE(Value: UnicodeString);
    procedure SetSHPERCTRCT(Value: UnicodeString);
    procedure SetASSETCLASS(Value: UnicodeString);
    procedure SetFIASSETCLASS(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOPTINFOTypeList }

  TXMLOPTINFOTypeList = class(TXMLNodeCollection, IXMLOPTINFOTypeList)
  protected
    { IXMLOPTINFOTypeList }
    function Add: IXMLOPTINFOType;
    function Insert(const Index: Integer): IXMLOPTINFOType;

    function GetItem(Index: Integer): IXMLOPTINFOType;
  end;

{ TXMLDEBTINFOType }

  TXMLDEBTINFOType = class(TXMLNode, IXMLDEBTINFOType)
  protected
    { IXMLDEBTINFOType }
    function GetSECINFO: IXMLSECINFOType;
    function GetPARVALUE: UnicodeString;
    function GetDEBTTYPE: UnicodeString;
    function GetDEBTCLASS: UnicodeString;
    function GetCOUPONRT: UnicodeString;
    function GetDTCOUPON: UnicodeString;
    function GetCOUPONFREQ: UnicodeString;
    function GetCALLPRICE: UnicodeString;
    function GetYIELDTOCALL: UnicodeString;
    function GetDTCALL: UnicodeString;
    function GetCALLTYPE: UnicodeString;
    function GetYIELDTOMAT: UnicodeString;
    function GetDTMAT: UnicodeString;
    function GetASSETCLASS: UnicodeString;
    function GetFIASSETCLASS: UnicodeString;
    procedure SetPARVALUE(Value: UnicodeString);
    procedure SetDEBTTYPE(Value: UnicodeString);
    procedure SetDEBTCLASS(Value: UnicodeString);
    procedure SetCOUPONRT(Value: UnicodeString);
    procedure SetDTCOUPON(Value: UnicodeString);
    procedure SetCOUPONFREQ(Value: UnicodeString);
    procedure SetCALLPRICE(Value: UnicodeString);
    procedure SetYIELDTOCALL(Value: UnicodeString);
    procedure SetDTCALL(Value: UnicodeString);
    procedure SetCALLTYPE(Value: UnicodeString);
    procedure SetYIELDTOMAT(Value: UnicodeString);
    procedure SetDTMAT(Value: UnicodeString);
    procedure SetASSETCLASS(Value: UnicodeString);
    procedure SetFIASSETCLASS(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDEBTINFOTypeList }

  TXMLDEBTINFOTypeList = class(TXMLNodeCollection, IXMLDEBTINFOTypeList)
  protected
    { IXMLDEBTINFOTypeList }
    function Add: IXMLDEBTINFOType;
    function Insert(const Index: Integer): IXMLDEBTINFOType;

    function GetItem(Index: Integer): IXMLDEBTINFOType;
  end;

{ TXMLOTHERINFOType }

  TXMLOTHERINFOType = class(TXMLNode, IXMLOTHERINFOType)
  protected
    { IXMLOTHERINFOType }
    function GetSECINFO: IXMLSECINFOType;
    function GetTYPEDESC: UnicodeString;
    function GetASSETCLASS: UnicodeString;
    function GetFIASSETCLASS: UnicodeString;
    procedure SetTYPEDESC(Value: UnicodeString);
    procedure SetASSETCLASS(Value: UnicodeString);
    procedure SetFIASSETCLASS(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOTHERINFOTypeList }

  TXMLOTHERINFOTypeList = class(TXMLNodeCollection, IXMLOTHERINFOTypeList)
  protected
    { IXMLOTHERINFOTypeList }
    function Add: IXMLOTHERINFOType;
    function Insert(const Index: Integer): IXMLOTHERINFOType;

    function GetItem(Index: Integer): IXMLOTHERINFOType;
  end;

{ TXMLINVACCTTOType }

  TXMLINVACCTTOType = class(TXMLNode, IXMLINVACCTTOType)
  protected
    { IXMLINVACCTTOType }
    function GetBROKERID: UnicodeString;
    function GetACCTID: UnicodeString;
    procedure SetBROKERID(Value: UnicodeString);
    procedure SetACCTID(Value: UnicodeString);
  end;

{ TXMLINVACCTINFOType }

  TXMLINVACCTINFOType = class(TXMLNode, IXMLINVACCTINFOType)
  protected
    { IXMLINVACCTINFOType }
    function GetINVACCTFROM: IXMLINVACCTFROMType;
    function GetUSPRODUCTTYPE: UnicodeString;
    function GetCHECKING: UnicodeString;
    function GetSVCSTATUS: UnicodeString;
    function GetINVACCTTYPE: UnicodeString;
    function GetOPTIONLEVEL: UnicodeString;
    procedure SetUSPRODUCTTYPE(Value: UnicodeString);
    procedure SetCHECKING(Value: UnicodeString);
    procedure SetSVCSTATUS(Value: UnicodeString);
    procedure SetINVACCTTYPE(Value: UnicodeString);
    procedure SetOPTIONLEVEL(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVSTMTMSGSETType }

  TXMLINVSTMTMSGSETType = class(TXMLNode, IXMLINVSTMTMSGSETType)
  protected
    { IXMLINVSTMTMSGSETType }
    function GetINVSTMTMSGSETV1: IXMLINVSTMTMSGSETV1Type;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLINVSTMTMSGSETV1Type }

  TXMLINVSTMTMSGSETV1Type = class(TXMLNode, IXMLINVSTMTMSGSETV1Type)
  protected
    { IXMLINVSTMTMSGSETV1Type }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetTRANDNLD: UnicodeString;
    function GetOODNLD: UnicodeString;
    function GetPOSDNLD: UnicodeString;
    function GetBALDNLD: UnicodeString;
    function GetCANEMAIL: UnicodeString;
    procedure SetTRANDNLD(Value: UnicodeString);
    procedure SetOODNLD(Value: UnicodeString);
    procedure SetPOSDNLD(Value: UnicodeString);
    procedure SetBALDNLD(Value: UnicodeString);
    procedure SetCANEMAIL(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSECLISTMSGSETType }

  TXMLSECLISTMSGSETType = class(TXMLNode, IXMLSECLISTMSGSETType)
  protected
    { IXMLSECLISTMSGSETType }
    function GetSECLISTMSGSETV1: IXMLSECLISTMSGSETV1Type;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSECLISTMSGSETV1Type }

  TXMLSECLISTMSGSETV1Type = class(TXMLNode, IXMLSECLISTMSGSETV1Type)
  protected
    { IXMLSECLISTMSGSETV1Type }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetSECLISTRQDNLD: UnicodeString;
    procedure SetSECLISTRQDNLD(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLEMAILMSGSRQV1Type }

  TXMLEMAILMSGSRQV1Type = class(TXMLNode, IXMLEMAILMSGSRQV1Type)
  private
    FMAILTRNRQ: IXMLMAILTRNRQTypeList;
    FMAILSYNCRQ: IXMLMAILSYNCRQTypeList;
    FGETMIMETRNRQ: IXMLGETMIMETRNRQTypeList;
  protected
    { IXMLEMAILMSGSRQV1Type }
    function GetMAILTRNRQ: IXMLMAILTRNRQTypeList;
    function GetMAILSYNCRQ: IXMLMAILSYNCRQTypeList;
    function GetGETMIMETRNRQ: IXMLGETMIMETRNRQTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMAILTRNRQType }

  TXMLMAILTRNRQType = class(TXMLNode, IXMLMAILTRNRQType)
  protected
    { IXMLMAILTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetMAILRQ: IXMLMAILRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMAILTRNRQTypeList }

  TXMLMAILTRNRQTypeList = class(TXMLNodeCollection, IXMLMAILTRNRQTypeList)
  protected
    { IXMLMAILTRNRQTypeList }
    function Add: IXMLMAILTRNRQType;
    function Insert(const Index: Integer): IXMLMAILTRNRQType;

    function GetItem(Index: Integer): IXMLMAILTRNRQType;
  end;

{ TXMLMAILRQType }

  TXMLMAILRQType = class(TXMLNode, IXMLMAILRQType)
  protected
    { IXMLMAILRQType }
    function GetMAIL: IXMLMAILType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMAILSYNCRQType }

  TXMLMAILSYNCRQType = class(TXMLNode, IXMLMAILSYNCRQType)
  private
    FMAILTRNRQ: IXMLMAILTRNRQTypeList;
  protected
    { IXMLMAILSYNCRQType }
    function GetSYNCRQMACRO: UnicodeString;
    function GetINCIMAGES: UnicodeString;
    function GetUSEHTML: UnicodeString;
    function GetMAILTRNRQ: IXMLMAILTRNRQTypeList;
    procedure SetSYNCRQMACRO(Value: UnicodeString);
    procedure SetINCIMAGES(Value: UnicodeString);
    procedure SetUSEHTML(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMAILSYNCRQTypeList }

  TXMLMAILSYNCRQTypeList = class(TXMLNodeCollection, IXMLMAILSYNCRQTypeList)
  protected
    { IXMLMAILSYNCRQTypeList }
    function Add: IXMLMAILSYNCRQType;
    function Insert(const Index: Integer): IXMLMAILSYNCRQType;

    function GetItem(Index: Integer): IXMLMAILSYNCRQType;
  end;

{ TXMLGETMIMETRNRQType }

  TXMLGETMIMETRNRQType = class(TXMLNode, IXMLGETMIMETRNRQType)
  protected
    { IXMLGETMIMETRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetGETMIMERQ: IXMLGETMIMERQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLGETMIMETRNRQTypeList }

  TXMLGETMIMETRNRQTypeList = class(TXMLNodeCollection, IXMLGETMIMETRNRQTypeList)
  protected
    { IXMLGETMIMETRNRQTypeList }
    function Add: IXMLGETMIMETRNRQType;
    function Insert(const Index: Integer): IXMLGETMIMETRNRQType;

    function GetItem(Index: Integer): IXMLGETMIMETRNRQType;
  end;

{ TXMLGETMIMERQType }

  TXMLGETMIMERQType = class(TXMLNode, IXMLGETMIMERQType)
  protected
    { IXMLGETMIMERQType }
    function GetURL: UnicodeString;
    procedure SetURL(Value: UnicodeString);
  end;

{ TXMLEMAILMSGSRSV1Type }

  TXMLEMAILMSGSRSV1Type = class(TXMLNode, IXMLEMAILMSGSRSV1Type)
  private
    FMAILTRNRS: IXMLMAILTRNRSTypeList;
    FMAILSYNCRS: IXMLMAILSYNCRSTypeList;
    FGETMIMETRNRS: IXMLGETMIMETRNRSTypeList;
  protected
    { IXMLEMAILMSGSRSV1Type }
    function GetMAILTRNRS: IXMLMAILTRNRSTypeList;
    function GetMAILSYNCRS: IXMLMAILSYNCRSTypeList;
    function GetGETMIMETRNRS: IXMLGETMIMETRNRSTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMAILTRNRSType }

  TXMLMAILTRNRSType = class(TXMLNode, IXMLMAILTRNRSType)
  protected
    { IXMLMAILTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetMAILRS: IXMLMAILRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMAILTRNRSTypeList }

  TXMLMAILTRNRSTypeList = class(TXMLNodeCollection, IXMLMAILTRNRSTypeList)
  protected
    { IXMLMAILTRNRSTypeList }
    function Add: IXMLMAILTRNRSType;
    function Insert(const Index: Integer): IXMLMAILTRNRSType;

    function GetItem(Index: Integer): IXMLMAILTRNRSType;
  end;

{ TXMLMAILRSType }

  TXMLMAILRSType = class(TXMLNode, IXMLMAILRSType)
  protected
    { IXMLMAILRSType }
    function GetMAIL: IXMLMAILType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMAILSYNCRSType }

  TXMLMAILSYNCRSType = class(TXMLNode, IXMLMAILSYNCRSType)
  private
    FMAILTRNRS: IXMLMAILTRNRSTypeList;
  protected
    { IXMLMAILSYNCRSType }
    function GetSYNCRSMACRO: UnicodeString;
    function GetMAILTRNRS: IXMLMAILTRNRSTypeList;
    procedure SetSYNCRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMAILSYNCRSTypeList }

  TXMLMAILSYNCRSTypeList = class(TXMLNodeCollection, IXMLMAILSYNCRSTypeList)
  protected
    { IXMLMAILSYNCRSTypeList }
    function Add: IXMLMAILSYNCRSType;
    function Insert(const Index: Integer): IXMLMAILSYNCRSType;

    function GetItem(Index: Integer): IXMLMAILSYNCRSType;
  end;

{ TXMLGETMIMETRNRSType }

  TXMLGETMIMETRNRSType = class(TXMLNode, IXMLGETMIMETRNRSType)
  protected
    { IXMLGETMIMETRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetGETMIMERS: IXMLGETMIMERSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLGETMIMETRNRSTypeList }

  TXMLGETMIMETRNRSTypeList = class(TXMLNodeCollection, IXMLGETMIMETRNRSTypeList)
  protected
    { IXMLGETMIMETRNRSTypeList }
    function Add: IXMLGETMIMETRNRSType;
    function Insert(const Index: Integer): IXMLGETMIMETRNRSType;

    function GetItem(Index: Integer): IXMLGETMIMETRNRSType;
  end;

{ TXMLGETMIMERSType }

  TXMLGETMIMERSType = class(TXMLNode, IXMLGETMIMERSType)
  protected
    { IXMLGETMIMERSType }
    function GetURL: UnicodeString;
    procedure SetURL(Value: UnicodeString);
  end;

{ TXMLEMAILMSGSETType }

  TXMLEMAILMSGSETType = class(TXMLNode, IXMLEMAILMSGSETType)
  protected
    { IXMLEMAILMSGSETType }
    function GetEMAILMSGSETV1: IXMLEMAILMSGSETV1Type;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLEMAILMSGSETV1Type }

  TXMLEMAILMSGSETV1Type = class(TXMLNode, IXMLEMAILMSGSETV1Type)
  protected
    { IXMLEMAILMSGSETV1Type }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
    function GetMAILSUP: UnicodeString;
    function GetGETMIMESUP: UnicodeString;
    procedure SetMAILSUP(Value: UnicodeString);
    procedure SetGETMIMESUP(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPROFMSGSRQV1Type }

  TXMLPROFMSGSRQV1Type = class(TXMLNodeCollection, IXMLPROFMSGSRQV1Type)
  protected
    { IXMLPROFMSGSRQV1Type }
    function GetPROFTRNRQ(Index: Integer): IXMLPROFTRNRQType;
    function Add: IXMLPROFTRNRQType;
    function Insert(const Index: Integer): IXMLPROFTRNRQType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPROFTRNRQType }

  TXMLPROFTRNRQType = class(TXMLNode, IXMLPROFTRNRQType)
  protected
    { IXMLPROFTRNRQType }
    function GetTRNRQMACRO: UnicodeString;
    function GetPROFRQ: IXMLPROFRQType;
    procedure SetTRNRQMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPROFRQType }

  TXMLPROFRQType = class(TXMLNode, IXMLPROFRQType)
  protected
    { IXMLPROFRQType }
    function GetCLIENTROUTING: UnicodeString;
    function GetDTPROFUP: UnicodeString;
    procedure SetCLIENTROUTING(Value: UnicodeString);
    procedure SetDTPROFUP(Value: UnicodeString);
  end;

{ TXMLPROFMSGSRSV1Type }

  TXMLPROFMSGSRSV1Type = class(TXMLNodeCollection, IXMLPROFMSGSRSV1Type)
  protected
    { IXMLPROFMSGSRSV1Type }
    function GetPROFTRNRS(Index: Integer): IXMLPROFTRNRSType;
    function Add: IXMLPROFTRNRSType;
    function Insert(const Index: Integer): IXMLPROFTRNRSType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPROFTRNRSType }

  TXMLPROFTRNRSType = class(TXMLNode, IXMLPROFTRNRSType)
  protected
    { IXMLPROFTRNRSType }
    function GetTRNRSMACRO: UnicodeString;
    function GetPROFRS: IXMLPROFRSType;
    procedure SetTRNRSMACRO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPROFRSType }

  TXMLPROFRSType = class(TXMLNode, IXMLPROFRSType)
  protected
    { IXMLPROFRSType }
    function GetMSGSETLIST: IXMLMSGSETLISTType;
    function GetSIGNONINFOLIST: IXMLSIGNONINFOLISTType;
    function GetDTPROFUP: UnicodeString;
    function GetFINAME: UnicodeString;
    function GetADDR1: UnicodeString;
    function GetADDR2: UnicodeString;
    function GetADDR3: UnicodeString;
    function GetCITY: UnicodeString;
    function GetSTATE: UnicodeString;
    function GetPOSTALCODE: UnicodeString;
    function GetCOUNTRY: UnicodeString;
    function GetCSPHONE: UnicodeString;
    function GetTSPHONE: UnicodeString;
    function GetFAXPHONE: UnicodeString;
    function GetURL: UnicodeString;
    function GetEMAIL: UnicodeString;
    procedure SetDTPROFUP(Value: UnicodeString);
    procedure SetFINAME(Value: UnicodeString);
    procedure SetADDR1(Value: UnicodeString);
    procedure SetADDR2(Value: UnicodeString);
    procedure SetADDR3(Value: UnicodeString);
    procedure SetCITY(Value: UnicodeString);
    procedure SetSTATE(Value: UnicodeString);
    procedure SetPOSTALCODE(Value: UnicodeString);
    procedure SetCOUNTRY(Value: UnicodeString);
    procedure SetCSPHONE(Value: UnicodeString);
    procedure SetTSPHONE(Value: UnicodeString);
    procedure SetFAXPHONE(Value: UnicodeString);
    procedure SetURL(Value: UnicodeString);
    procedure SetEMAIL(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMSGSETLISTType }

  TXMLMSGSETLISTType = class(TXMLNodeCollection, IXMLMSGSETLISTType)
  protected
    { IXMLMSGSETLISTType }
    function GetMSGSETMACRO(Index: Integer): UnicodeString;
    function Add(const MSGSETMACRO: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const MSGSETMACRO: UnicodeString): IXMLNode;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSIGNONINFOLISTType }

  TXMLSIGNONINFOLISTType = class(TXMLNodeCollection, IXMLSIGNONINFOLISTType)
  protected
    { IXMLSIGNONINFOLISTType }
    function GetSIGNONINFO(Index: Integer): IXMLSIGNONINFOType;
    function Add: IXMLSIGNONINFOType;
    function Insert(const Index: Integer): IXMLSIGNONINFOType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSIGNONINFOType }

  TXMLSIGNONINFOType = class(TXMLNode, IXMLSIGNONINFOType)
  protected
    { IXMLSIGNONINFOType }
    function GetSIGNONREALM: UnicodeString;
    function GetMIN: UnicodeString;
    function GetMAX: UnicodeString;
    function GetCHARTYPE: UnicodeString;
    function GetCASESEN: UnicodeString;
    function GetSPECIAL: UnicodeString;
    function GetSPACES: UnicodeString;
    function GetPINCH: UnicodeString;
    function GetCHGPINFIRST: UnicodeString;
    procedure SetSIGNONREALM(Value: UnicodeString);
    procedure SetMIN(Value: UnicodeString);
    procedure SetMAX(Value: UnicodeString);
    procedure SetCHARTYPE(Value: UnicodeString);
    procedure SetCASESEN(Value: UnicodeString);
    procedure SetSPECIAL(Value: UnicodeString);
    procedure SetSPACES(Value: UnicodeString);
    procedure SetPINCH(Value: UnicodeString);
    procedure SetCHGPINFIRST(Value: UnicodeString);
  end;

{ TXMLPROFMSGSETType }

  TXMLPROFMSGSETType = class(TXMLNode, IXMLPROFMSGSETType)
  protected
    { IXMLPROFMSGSETType }
    function GetPROFMSGSETV1: IXMLPROFMSGSETV1Type;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPROFMSGSETV1Type }

  TXMLPROFMSGSETV1Type = class(TXMLNode, IXMLPROFMSGSETV1Type)
  protected
    { IXMLPROFMSGSETV1Type }
    function GetMSGSETCORE: IXMLMSGSETCOREType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOFXType }

  TXMLOFXType = class(TXMLNode, IXMLOFXType)
  protected
    { IXMLOFXType }
  end;

{ TXMLString_List }

  TXMLString_List = class(TXMLNodeCollection, IXMLString_List)
  protected
    { IXMLString_List }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function GetItem(Index: Integer): UnicodeString;
  end;

{ Global Functions }

function GetSIGNONMSGSRQV1(Doc: IXMLDocument): IXMLSIGNONMSGSRQV1Type;
function LoadSIGNONMSGSRQV1(const FileName: string): IXMLSIGNONMSGSRQV1Type;
function NewSIGNONMSGSRQV1: IXMLSIGNONMSGSRQV1Type;
function GetSIGNONMSGSRSV1(Doc: IXMLDocument): IXMLSIGNONMSGSRSV1Type;
function LoadSIGNONMSGSRSV1(const FileName: string): IXMLSIGNONMSGSRSV1Type;
function NewSIGNONMSGSRSV1: IXMLSIGNONMSGSRSV1Type;
function GetSIGNONMSGSET(Doc: IXMLDocument): IXMLSIGNONMSGSETType;
function LoadSIGNONMSGSET(const FileName: string): IXMLSIGNONMSGSETType;
function NewSIGNONMSGSET: IXMLSIGNONMSGSETType;
function GetBANKMSGSRQV1(Doc: IXMLDocument): IXMLBANKMSGSRQV1Type;
function LoadBANKMSGSRQV1(const FileName: string): IXMLBANKMSGSRQV1Type;
function NewBANKMSGSRQV1: IXMLBANKMSGSRQV1Type;
function GetINTERXFERMSGSRQV1(Doc: IXMLDocument): IXMLINTERXFERMSGSRQV1Type;
function LoadINTERXFERMSGSRQV1(const FileName: string): IXMLINTERXFERMSGSRQV1Type;
function NewINTERXFERMSGSRQV1: IXMLINTERXFERMSGSRQV1Type;
function GetBANKMSGSRSV1(Doc: IXMLDocument): IXMLBANKMSGSRSV1Type;
function LoadBANKMSGSRSV1(const FileName: string): IXMLBANKMSGSRSV1Type;
function NewBANKMSGSRSV1: IXMLBANKMSGSRSV1Type;
function GetBILLPAYMSGSRQV1(Doc: IXMLDocument): IXMLBILLPAYMSGSRQV1Type;
function LoadBILLPAYMSGSRQV1(const FileName: string): IXMLBILLPAYMSGSRQV1Type;
function NewBILLPAYMSGSRQV1: IXMLBILLPAYMSGSRQV1Type;
function GetSIGNUPMSGSRSV1(Doc: IXMLDocument): IXMLSIGNUPMSGSRSV1Type;
function LoadSIGNUPMSGSRSV1(const FileName: string): IXMLSIGNUPMSGSRSV1Type;
function NewSIGNUPMSGSRSV1: IXMLSIGNUPMSGSRSV1Type;
function GetSIGNUPMSGSET(Doc: IXMLDocument): IXMLSIGNUPMSGSETType;
function LoadSIGNUPMSGSET(const FileName: string): IXMLSIGNUPMSGSETType;
function NewSIGNUPMSGSET: IXMLSIGNUPMSGSETType;
function GetINVSTMTMSGSRQV1(Doc: IXMLDocument): IXMLINVSTMTMSGSRQV1Type;
function LoadINVSTMTMSGSRQV1(const FileName: string): IXMLINVSTMTMSGSRQV1Type;
function NewINVSTMTMSGSRQV1: IXMLINVSTMTMSGSRQV1Type;
function GetINVSTMTMSGSRSV1(Doc: IXMLDocument): IXMLINVSTMTMSGSRSV1Type;
function LoadINVSTMTMSGSRSV1(const FileName: string): IXMLINVSTMTMSGSRSV1Type;
function NewINVSTMTMSGSRSV1: IXMLINVSTMTMSGSRSV1Type;
function GetSECLISTMSGSRSV1(Doc: IXMLDocument): IXMLSECLISTMSGSRSV1Type;
function LoadSECLISTMSGSRSV1(const FileName: string): IXMLSECLISTMSGSRSV1Type;
function NewSECLISTMSGSRSV1: IXMLSECLISTMSGSRSV1Type;
function GetINVACCTTO(Doc: IXMLDocument): IXMLINVACCTTOType;
function LoadINVACCTTO(const FileName: string): IXMLINVACCTTOType;
function NewINVACCTTO: IXMLINVACCTTOType;
function GetINVACCTINFO(Doc: IXMLDocument): IXMLINVACCTINFOType;
function LoadINVACCTINFO(const FileName: string): IXMLINVACCTINFOType;
function NewINVACCTINFO: IXMLINVACCTINFOType;
function GetINVSTMTMSGSET(Doc: IXMLDocument): IXMLINVSTMTMSGSETType;
function LoadINVSTMTMSGSET(const FileName: string): IXMLINVSTMTMSGSETType;
function NewINVSTMTMSGSET: IXMLINVSTMTMSGSETType;
function GetSECLISTMSGSET(Doc: IXMLDocument): IXMLSECLISTMSGSETType;
function LoadSECLISTMSGSET(const FileName: string): IXMLSECLISTMSGSETType;
function NewSECLISTMSGSET: IXMLSECLISTMSGSETType;
function GetEMAILMSGSRQV1(Doc: IXMLDocument): IXMLEMAILMSGSRQV1Type;
function LoadEMAILMSGSRQV1(const FileName: string): IXMLEMAILMSGSRQV1Type;
function NewEMAILMSGSRQV1: IXMLEMAILMSGSRQV1Type;
function GetEMAILMSGSRSV1(Doc: IXMLDocument): IXMLEMAILMSGSRSV1Type;
function LoadEMAILMSGSRSV1(const FileName: string): IXMLEMAILMSGSRSV1Type;
function NewEMAILMSGSRSV1: IXMLEMAILMSGSRSV1Type;
function GetEMAILMSGSET(Doc: IXMLDocument): IXMLEMAILMSGSETType;
function LoadEMAILMSGSET(const FileName: string): IXMLEMAILMSGSETType;
function NewEMAILMSGSET: IXMLEMAILMSGSETType;
function GetPROFMSGSRQV1(Doc: IXMLDocument): IXMLPROFMSGSRQV1Type;
function LoadPROFMSGSRQV1(const FileName: string): IXMLPROFMSGSRQV1Type;
function NewPROFMSGSRQV1: IXMLPROFMSGSRQV1Type;
function GetPROFMSGSRSV1(Doc: IXMLDocument): IXMLPROFMSGSRSV1Type;
function LoadPROFMSGSRSV1(const FileName: string): IXMLPROFMSGSRSV1Type;
function NewPROFMSGSRSV1: IXMLPROFMSGSRSV1Type;
function GetPROFMSGSET(Doc: IXMLDocument): IXMLPROFMSGSETType;
function LoadPROFMSGSET(const FileName: string): IXMLPROFMSGSETType;
function NewPROFMSGSET: IXMLPROFMSGSETType;
function GetOFX(Doc: IXMLDocument): IXMLOFXType;
function LoadOFX(const FileName: string): IXMLOFXType;
function NewOFX: IXMLOFXType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetSIGNONMSGSRQV1(Doc: IXMLDocument): IXMLSIGNONMSGSRQV1Type;
begin
  Result := Doc.GetDocBinding('SIGNONMSGSRQV1', TXMLSIGNONMSGSRQV1Type, TargetNamespace) as IXMLSIGNONMSGSRQV1Type;
end;

function LoadSIGNONMSGSRQV1(const FileName: string): IXMLSIGNONMSGSRQV1Type;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('SIGNONMSGSRQV1', TXMLSIGNONMSGSRQV1Type, TargetNamespace) as IXMLSIGNONMSGSRQV1Type;
end;

function NewSIGNONMSGSRQV1: IXMLSIGNONMSGSRQV1Type;
begin
  Result := NewXMLDocument.GetDocBinding('SIGNONMSGSRQV1', TXMLSIGNONMSGSRQV1Type, TargetNamespace) as IXMLSIGNONMSGSRQV1Type;
end;
function GetSIGNONMSGSRSV1(Doc: IXMLDocument): IXMLSIGNONMSGSRSV1Type;
begin
  Result := Doc.GetDocBinding('SIGNONMSGSRSV1', TXMLSIGNONMSGSRSV1Type, TargetNamespace) as IXMLSIGNONMSGSRSV1Type;
end;

function LoadSIGNONMSGSRSV1(const FileName: string): IXMLSIGNONMSGSRSV1Type;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('SIGNONMSGSRSV1', TXMLSIGNONMSGSRSV1Type, TargetNamespace) as IXMLSIGNONMSGSRSV1Type;
end;

function NewSIGNONMSGSRSV1: IXMLSIGNONMSGSRSV1Type;
begin
  Result := NewXMLDocument.GetDocBinding('SIGNONMSGSRSV1', TXMLSIGNONMSGSRSV1Type, TargetNamespace) as IXMLSIGNONMSGSRSV1Type;
end;
function GetSIGNONMSGSET(Doc: IXMLDocument): IXMLSIGNONMSGSETType;
begin
  Result := Doc.GetDocBinding('SIGNONMSGSET', TXMLSIGNONMSGSETType, TargetNamespace) as IXMLSIGNONMSGSETType;
end;

function LoadSIGNONMSGSET(const FileName: string): IXMLSIGNONMSGSETType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('SIGNONMSGSET', TXMLSIGNONMSGSETType, TargetNamespace) as IXMLSIGNONMSGSETType;
end;

function NewSIGNONMSGSET: IXMLSIGNONMSGSETType;
begin
  Result := NewXMLDocument.GetDocBinding('SIGNONMSGSET', TXMLSIGNONMSGSETType, TargetNamespace) as IXMLSIGNONMSGSETType;
end;
function GetBANKMSGSRQV1(Doc: IXMLDocument): IXMLBANKMSGSRQV1Type;
begin
  Result := Doc.GetDocBinding('BANKMSGSRQV1', TXMLBANKMSGSRQV1Type, TargetNamespace) as IXMLBANKMSGSRQV1Type;
end;

function LoadBANKMSGSRQV1(const FileName: string): IXMLBANKMSGSRQV1Type;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('BANKMSGSRQV1', TXMLBANKMSGSRQV1Type, TargetNamespace) as IXMLBANKMSGSRQV1Type;
end;

function NewBANKMSGSRQV1: IXMLBANKMSGSRQV1Type;
begin
  Result := NewXMLDocument.GetDocBinding('BANKMSGSRQV1', TXMLBANKMSGSRQV1Type, TargetNamespace) as IXMLBANKMSGSRQV1Type;
end;
function GetINTERXFERMSGSRQV1(Doc: IXMLDocument): IXMLINTERXFERMSGSRQV1Type;
begin
  Result := Doc.GetDocBinding('INTERXFERMSGSRQV1', TXMLINTERXFERMSGSRQV1Type, TargetNamespace) as IXMLINTERXFERMSGSRQV1Type;
end;

function LoadINTERXFERMSGSRQV1(const FileName: string): IXMLINTERXFERMSGSRQV1Type;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('INTERXFERMSGSRQV1', TXMLINTERXFERMSGSRQV1Type, TargetNamespace) as IXMLINTERXFERMSGSRQV1Type;
end;

function NewINTERXFERMSGSRQV1: IXMLINTERXFERMSGSRQV1Type;
begin
  Result := NewXMLDocument.GetDocBinding('INTERXFERMSGSRQV1', TXMLINTERXFERMSGSRQV1Type, TargetNamespace) as IXMLINTERXFERMSGSRQV1Type;
end;
function GetBANKMSGSRSV1(Doc: IXMLDocument): IXMLBANKMSGSRSV1Type;
begin
  Result := Doc.GetDocBinding('BANKMSGSRSV1', TXMLBANKMSGSRSV1Type, TargetNamespace) as IXMLBANKMSGSRSV1Type;
end;

function LoadBANKMSGSRSV1(const FileName: string): IXMLBANKMSGSRSV1Type;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('BANKMSGSRSV1', TXMLBANKMSGSRSV1Type, TargetNamespace) as IXMLBANKMSGSRSV1Type;
end;

function NewBANKMSGSRSV1: IXMLBANKMSGSRSV1Type;
begin
  Result := NewXMLDocument.GetDocBinding('BANKMSGSRSV1', TXMLBANKMSGSRSV1Type, TargetNamespace) as IXMLBANKMSGSRSV1Type;
end;
function GetBILLPAYMSGSRQV1(Doc: IXMLDocument): IXMLBILLPAYMSGSRQV1Type;
begin
  Result := Doc.GetDocBinding('BILLPAYMSGSRQV1', TXMLBILLPAYMSGSRQV1Type, TargetNamespace) as IXMLBILLPAYMSGSRQV1Type;
end;

function LoadBILLPAYMSGSRQV1(const FileName: string): IXMLBILLPAYMSGSRQV1Type;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('BILLPAYMSGSRQV1', TXMLBILLPAYMSGSRQV1Type, TargetNamespace) as IXMLBILLPAYMSGSRQV1Type;
end;

function NewBILLPAYMSGSRQV1: IXMLBILLPAYMSGSRQV1Type;
begin
  Result := NewXMLDocument.GetDocBinding('BILLPAYMSGSRQV1', TXMLBILLPAYMSGSRQV1Type, TargetNamespace) as IXMLBILLPAYMSGSRQV1Type;
end;
function GetSIGNUPMSGSRSV1(Doc: IXMLDocument): IXMLSIGNUPMSGSRSV1Type;
begin
  Result := Doc.GetDocBinding('SIGNUPMSGSRSV1', TXMLSIGNUPMSGSRSV1Type, TargetNamespace) as IXMLSIGNUPMSGSRSV1Type;
end;

function LoadSIGNUPMSGSRSV1(const FileName: string): IXMLSIGNUPMSGSRSV1Type;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('SIGNUPMSGSRSV1', TXMLSIGNUPMSGSRSV1Type, TargetNamespace) as IXMLSIGNUPMSGSRSV1Type;
end;

function NewSIGNUPMSGSRSV1: IXMLSIGNUPMSGSRSV1Type;
begin
  Result := NewXMLDocument.GetDocBinding('SIGNUPMSGSRSV1', TXMLSIGNUPMSGSRSV1Type, TargetNamespace) as IXMLSIGNUPMSGSRSV1Type;
end;
function GetSIGNUPMSGSET(Doc: IXMLDocument): IXMLSIGNUPMSGSETType;
begin
  Result := Doc.GetDocBinding('SIGNUPMSGSET', TXMLSIGNUPMSGSETType, TargetNamespace) as IXMLSIGNUPMSGSETType;
end;

function LoadSIGNUPMSGSET(const FileName: string): IXMLSIGNUPMSGSETType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('SIGNUPMSGSET', TXMLSIGNUPMSGSETType, TargetNamespace) as IXMLSIGNUPMSGSETType;
end;

function NewSIGNUPMSGSET: IXMLSIGNUPMSGSETType;
begin
  Result := NewXMLDocument.GetDocBinding('SIGNUPMSGSET', TXMLSIGNUPMSGSETType, TargetNamespace) as IXMLSIGNUPMSGSETType;
end;
function GetINVSTMTMSGSRQV1(Doc: IXMLDocument): IXMLINVSTMTMSGSRQV1Type;
begin
  Result := Doc.GetDocBinding('INVSTMTMSGSRQV1', TXMLINVSTMTMSGSRQV1Type, TargetNamespace) as IXMLINVSTMTMSGSRQV1Type;
end;

function LoadINVSTMTMSGSRQV1(const FileName: string): IXMLINVSTMTMSGSRQV1Type;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('INVSTMTMSGSRQV1', TXMLINVSTMTMSGSRQV1Type, TargetNamespace) as IXMLINVSTMTMSGSRQV1Type;
end;

function NewINVSTMTMSGSRQV1: IXMLINVSTMTMSGSRQV1Type;
begin
  Result := NewXMLDocument.GetDocBinding('INVSTMTMSGSRQV1', TXMLINVSTMTMSGSRQV1Type, TargetNamespace) as IXMLINVSTMTMSGSRQV1Type;
end;
function GetINVSTMTMSGSRSV1(Doc: IXMLDocument): IXMLINVSTMTMSGSRSV1Type;
begin
  Result := Doc.GetDocBinding('INVSTMTMSGSRSV1', TXMLINVSTMTMSGSRSV1Type, TargetNamespace) as IXMLINVSTMTMSGSRSV1Type;
end;

function LoadINVSTMTMSGSRSV1(const FileName: string): IXMLINVSTMTMSGSRSV1Type;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('INVSTMTMSGSRSV1', TXMLINVSTMTMSGSRSV1Type, TargetNamespace) as IXMLINVSTMTMSGSRSV1Type;
end;

function NewINVSTMTMSGSRSV1: IXMLINVSTMTMSGSRSV1Type;
begin
  Result := NewXMLDocument.GetDocBinding('INVSTMTMSGSRSV1', TXMLINVSTMTMSGSRSV1Type, TargetNamespace) as IXMLINVSTMTMSGSRSV1Type;
end;
function GetSECLISTMSGSRSV1(Doc: IXMLDocument): IXMLSECLISTMSGSRSV1Type;
begin
  Result := Doc.GetDocBinding('SECLISTMSGSRSV1', TXMLSECLISTMSGSRSV1Type, TargetNamespace) as IXMLSECLISTMSGSRSV1Type;
end;

function LoadSECLISTMSGSRSV1(const FileName: string): IXMLSECLISTMSGSRSV1Type;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('SECLISTMSGSRSV1', TXMLSECLISTMSGSRSV1Type, TargetNamespace) as IXMLSECLISTMSGSRSV1Type;
end;

function NewSECLISTMSGSRSV1: IXMLSECLISTMSGSRSV1Type;
begin
  Result := NewXMLDocument.GetDocBinding('SECLISTMSGSRSV1', TXMLSECLISTMSGSRSV1Type, TargetNamespace) as IXMLSECLISTMSGSRSV1Type;
end;
function GetINVACCTTO(Doc: IXMLDocument): IXMLINVACCTTOType;
begin
  Result := Doc.GetDocBinding('INVACCTTO', TXMLINVACCTTOType, TargetNamespace) as IXMLINVACCTTOType;
end;

function LoadINVACCTTO(const FileName: string): IXMLINVACCTTOType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('INVACCTTO', TXMLINVACCTTOType, TargetNamespace) as IXMLINVACCTTOType;
end;

function NewINVACCTTO: IXMLINVACCTTOType;
begin
  Result := NewXMLDocument.GetDocBinding('INVACCTTO', TXMLINVACCTTOType, TargetNamespace) as IXMLINVACCTTOType;
end;
function GetINVACCTINFO(Doc: IXMLDocument): IXMLINVACCTINFOType;
begin
  Result := Doc.GetDocBinding('INVACCTINFO', TXMLINVACCTINFOType, TargetNamespace) as IXMLINVACCTINFOType;
end;

function LoadINVACCTINFO(const FileName: string): IXMLINVACCTINFOType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('INVACCTINFO', TXMLINVACCTINFOType, TargetNamespace) as IXMLINVACCTINFOType;
end;

function NewINVACCTINFO: IXMLINVACCTINFOType;
begin
  Result := NewXMLDocument.GetDocBinding('INVACCTINFO', TXMLINVACCTINFOType, TargetNamespace) as IXMLINVACCTINFOType;
end;
function GetINVSTMTMSGSET(Doc: IXMLDocument): IXMLINVSTMTMSGSETType;
begin
  Result := Doc.GetDocBinding('INVSTMTMSGSET', TXMLINVSTMTMSGSETType, TargetNamespace) as IXMLINVSTMTMSGSETType;
end;

function LoadINVSTMTMSGSET(const FileName: string): IXMLINVSTMTMSGSETType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('INVSTMTMSGSET', TXMLINVSTMTMSGSETType, TargetNamespace) as IXMLINVSTMTMSGSETType;
end;

function NewINVSTMTMSGSET: IXMLINVSTMTMSGSETType;
begin
  Result := NewXMLDocument.GetDocBinding('INVSTMTMSGSET', TXMLINVSTMTMSGSETType, TargetNamespace) as IXMLINVSTMTMSGSETType;
end;
function GetSECLISTMSGSET(Doc: IXMLDocument): IXMLSECLISTMSGSETType;
begin
  Result := Doc.GetDocBinding('SECLISTMSGSET', TXMLSECLISTMSGSETType, TargetNamespace) as IXMLSECLISTMSGSETType;
end;

function LoadSECLISTMSGSET(const FileName: string): IXMLSECLISTMSGSETType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('SECLISTMSGSET', TXMLSECLISTMSGSETType, TargetNamespace) as IXMLSECLISTMSGSETType;
end;

function NewSECLISTMSGSET: IXMLSECLISTMSGSETType;
begin
  Result := NewXMLDocument.GetDocBinding('SECLISTMSGSET', TXMLSECLISTMSGSETType, TargetNamespace) as IXMLSECLISTMSGSETType;
end;
function GetEMAILMSGSRQV1(Doc: IXMLDocument): IXMLEMAILMSGSRQV1Type;
begin
  Result := Doc.GetDocBinding('EMAILMSGSRQV1', TXMLEMAILMSGSRQV1Type, TargetNamespace) as IXMLEMAILMSGSRQV1Type;
end;

function LoadEMAILMSGSRQV1(const FileName: string): IXMLEMAILMSGSRQV1Type;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('EMAILMSGSRQV1', TXMLEMAILMSGSRQV1Type, TargetNamespace) as IXMLEMAILMSGSRQV1Type;
end;

function NewEMAILMSGSRQV1: IXMLEMAILMSGSRQV1Type;
begin
  Result := NewXMLDocument.GetDocBinding('EMAILMSGSRQV1', TXMLEMAILMSGSRQV1Type, TargetNamespace) as IXMLEMAILMSGSRQV1Type;
end;
function GetEMAILMSGSRSV1(Doc: IXMLDocument): IXMLEMAILMSGSRSV1Type;
begin
  Result := Doc.GetDocBinding('EMAILMSGSRSV1', TXMLEMAILMSGSRSV1Type, TargetNamespace) as IXMLEMAILMSGSRSV1Type;
end;

function LoadEMAILMSGSRSV1(const FileName: string): IXMLEMAILMSGSRSV1Type;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('EMAILMSGSRSV1', TXMLEMAILMSGSRSV1Type, TargetNamespace) as IXMLEMAILMSGSRSV1Type;
end;

function NewEMAILMSGSRSV1: IXMLEMAILMSGSRSV1Type;
begin
  Result := NewXMLDocument.GetDocBinding('EMAILMSGSRSV1', TXMLEMAILMSGSRSV1Type, TargetNamespace) as IXMLEMAILMSGSRSV1Type;
end;
function GetEMAILMSGSET(Doc: IXMLDocument): IXMLEMAILMSGSETType;
begin
  Result := Doc.GetDocBinding('EMAILMSGSET', TXMLEMAILMSGSETType, TargetNamespace) as IXMLEMAILMSGSETType;
end;

function LoadEMAILMSGSET(const FileName: string): IXMLEMAILMSGSETType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('EMAILMSGSET', TXMLEMAILMSGSETType, TargetNamespace) as IXMLEMAILMSGSETType;
end;

function NewEMAILMSGSET: IXMLEMAILMSGSETType;
begin
  Result := NewXMLDocument.GetDocBinding('EMAILMSGSET', TXMLEMAILMSGSETType, TargetNamespace) as IXMLEMAILMSGSETType;
end;
function GetPROFMSGSRQV1(Doc: IXMLDocument): IXMLPROFMSGSRQV1Type;
begin
  Result := Doc.GetDocBinding('PROFMSGSRQV1', TXMLPROFMSGSRQV1Type, TargetNamespace) as IXMLPROFMSGSRQV1Type;
end;

function LoadPROFMSGSRQV1(const FileName: string): IXMLPROFMSGSRQV1Type;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('PROFMSGSRQV1', TXMLPROFMSGSRQV1Type, TargetNamespace) as IXMLPROFMSGSRQV1Type;
end;

function NewPROFMSGSRQV1: IXMLPROFMSGSRQV1Type;
begin
  Result := NewXMLDocument.GetDocBinding('PROFMSGSRQV1', TXMLPROFMSGSRQV1Type, TargetNamespace) as IXMLPROFMSGSRQV1Type;
end;
function GetPROFMSGSRSV1(Doc: IXMLDocument): IXMLPROFMSGSRSV1Type;
begin
  Result := Doc.GetDocBinding('PROFMSGSRSV1', TXMLPROFMSGSRSV1Type, TargetNamespace) as IXMLPROFMSGSRSV1Type;
end;

function LoadPROFMSGSRSV1(const FileName: string): IXMLPROFMSGSRSV1Type;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('PROFMSGSRSV1', TXMLPROFMSGSRSV1Type, TargetNamespace) as IXMLPROFMSGSRSV1Type;
end;

function NewPROFMSGSRSV1: IXMLPROFMSGSRSV1Type;
begin
  Result := NewXMLDocument.GetDocBinding('PROFMSGSRSV1', TXMLPROFMSGSRSV1Type, TargetNamespace) as IXMLPROFMSGSRSV1Type;
end;
function GetPROFMSGSET(Doc: IXMLDocument): IXMLPROFMSGSETType;
begin
  Result := Doc.GetDocBinding('PROFMSGSET', TXMLPROFMSGSETType, TargetNamespace) as IXMLPROFMSGSETType;
end;

function LoadPROFMSGSET(const FileName: string): IXMLPROFMSGSETType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('PROFMSGSET', TXMLPROFMSGSETType, TargetNamespace) as IXMLPROFMSGSETType;
end;

function NewPROFMSGSET: IXMLPROFMSGSETType;
begin
  Result := NewXMLDocument.GetDocBinding('PROFMSGSET', TXMLPROFMSGSETType, TargetNamespace) as IXMLPROFMSGSETType;
end;
function GetOFX(Doc: IXMLDocument): IXMLOFXType;
begin
  Result := Doc.GetDocBinding('OFX', TXMLOFXType, TargetNamespace) as IXMLOFXType;
end;

function LoadOFX(const FileName: string): IXMLOFXType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('OFX', TXMLOFXType, TargetNamespace) as IXMLOFXType;
end;

function NewOFX: IXMLOFXType;
begin
  Result := NewXMLDocument.GetDocBinding('OFX', TXMLOFXType, TargetNamespace) as IXMLOFXType;
end;

{ TXMLSIGNONMSGSRQV1Type }

procedure TXMLSIGNONMSGSRQV1Type.AfterConstruction;
begin
  RegisterChildNode('SONRQ', TXMLSONRQType);
  RegisterChildNode('PINCHTRNRQ', TXMLPINCHTRNRQType);
  RegisterChildNode('CHALLENGETRNRQ', TXMLCHALLENGETRNRQType);
  inherited;
end;

function TXMLSIGNONMSGSRQV1Type.GetSONRQ: IXMLSONRQType;
begin
  Result := ChildNodes['SONRQ'] as IXMLSONRQType;
end;

function TXMLSIGNONMSGSRQV1Type.GetPINCHTRNRQ: IXMLPINCHTRNRQType;
begin
  Result := ChildNodes['PINCHTRNRQ'] as IXMLPINCHTRNRQType;
end;

function TXMLSIGNONMSGSRQV1Type.GetCHALLENGETRNRQ: IXMLCHALLENGETRNRQType;
begin
  Result := ChildNodes['CHALLENGETRNRQ'] as IXMLCHALLENGETRNRQType;
end;

{ TXMLSONRQType }

procedure TXMLSONRQType.AfterConstruction;
begin
  RegisterChildNode('FI', TXMLFIType);
  inherited;
end;

function TXMLSONRQType.GetDTCLIENT: UnicodeString;
begin
  Result := ChildNodes['DTCLIENT'].Text;
end;

procedure TXMLSONRQType.SetDTCLIENT(Value: UnicodeString);
begin
  ChildNodes['DTCLIENT'].NodeValue := Value;
end;

function TXMLSONRQType.GetUSERID: UnicodeString;
begin
  Result := ChildNodes['USERID'].Text;
end;

procedure TXMLSONRQType.SetUSERID(Value: UnicodeString);
begin
  ChildNodes['USERID'].NodeValue := Value;
end;

function TXMLSONRQType.GetUSERPASS: UnicodeString;
begin
  Result := ChildNodes['USERPASS'].Text;
end;

procedure TXMLSONRQType.SetUSERPASS(Value: UnicodeString);
begin
  ChildNodes['USERPASS'].NodeValue := Value;
end;

function TXMLSONRQType.GetUSERKEY: UnicodeString;
begin
  Result := ChildNodes['USERKEY'].Text;
end;

procedure TXMLSONRQType.SetUSERKEY(Value: UnicodeString);
begin
  ChildNodes['USERKEY'].NodeValue := Value;
end;

function TXMLSONRQType.GetGENUSERKEY: UnicodeString;
begin
  Result := ChildNodes['GENUSERKEY'].Text;
end;

procedure TXMLSONRQType.SetGENUSERKEY(Value: UnicodeString);
begin
  ChildNodes['GENUSERKEY'].NodeValue := Value;
end;

function TXMLSONRQType.GetLANGUAGE: UnicodeString;
begin
  Result := ChildNodes['LANGUAGE'].Text;
end;

procedure TXMLSONRQType.SetLANGUAGE(Value: UnicodeString);
begin
  ChildNodes['LANGUAGE'].NodeValue := Value;
end;

function TXMLSONRQType.GetFI: IXMLFIType;
begin
  Result := ChildNodes['FI'] as IXMLFIType;
end;

function TXMLSONRQType.GetSESSCOOKIE: UnicodeString;
begin
  Result := ChildNodes['SESSCOOKIE'].Text;
end;

procedure TXMLSONRQType.SetSESSCOOKIE(Value: UnicodeString);
begin
  ChildNodes['SESSCOOKIE'].NodeValue := Value;
end;

function TXMLSONRQType.GetAPPID: UnicodeString;
begin
  Result := ChildNodes['APPID'].Text;
end;

procedure TXMLSONRQType.SetAPPID(Value: UnicodeString);
begin
  ChildNodes['APPID'].NodeValue := Value;
end;

function TXMLSONRQType.GetAPPVER: UnicodeString;
begin
  Result := ChildNodes['APPVER'].Text;
end;

procedure TXMLSONRQType.SetAPPVER(Value: UnicodeString);
begin
  ChildNodes['APPVER'].NodeValue := Value;
end;

{ TXMLFIType }

function TXMLFIType.GetORG: UnicodeString;
begin
  Result := ChildNodes['ORG'].Text;
end;

procedure TXMLFIType.SetORG(Value: UnicodeString);
begin
  ChildNodes['ORG'].NodeValue := Value;
end;

function TXMLFIType.GetFID: UnicodeString;
begin
  Result := ChildNodes['FID'].Text;
end;

procedure TXMLFIType.SetFID(Value: UnicodeString);
begin
  ChildNodes['FID'].NodeValue := Value;
end;

{ TXMLPINCHTRNRQType }

procedure TXMLPINCHTRNRQType.AfterConstruction;
begin
  RegisterChildNode('PINCHRQ', TXMLPINCHRQType);
  inherited;
end;

function TXMLPINCHTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLPINCHTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLPINCHTRNRQType.GetPINCHRQ: IXMLPINCHRQType;
begin
  Result := ChildNodes['PINCHRQ'] as IXMLPINCHRQType;
end;

{ TXMLPINCHRQType }

function TXMLPINCHRQType.GetUSERID: UnicodeString;
begin
  Result := ChildNodes['USERID'].Text;
end;

procedure TXMLPINCHRQType.SetUSERID(Value: UnicodeString);
begin
  ChildNodes['USERID'].NodeValue := Value;
end;

function TXMLPINCHRQType.GetNEWUSERPASS: UnicodeString;
begin
  Result := ChildNodes['NEWUSERPASS'].Text;
end;

procedure TXMLPINCHRQType.SetNEWUSERPASS(Value: UnicodeString);
begin
  ChildNodes['NEWUSERPASS'].NodeValue := Value;
end;

{ TXMLCHALLENGETRNRQType }

procedure TXMLCHALLENGETRNRQType.AfterConstruction;
begin
  RegisterChildNode('CHALLENGERQ', TXMLCHALLENGERQType);
  inherited;
end;

function TXMLCHALLENGETRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLCHALLENGETRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLCHALLENGETRNRQType.GetCHALLENGERQ: IXMLCHALLENGERQType;
begin
  Result := ChildNodes['CHALLENGERQ'] as IXMLCHALLENGERQType;
end;

{ TXMLCHALLENGERQType }

function TXMLCHALLENGERQType.GetUSERID: UnicodeString;
begin
  Result := ChildNodes['USERID'].Text;
end;

procedure TXMLCHALLENGERQType.SetUSERID(Value: UnicodeString);
begin
  ChildNodes['USERID'].NodeValue := Value;
end;

function TXMLCHALLENGERQType.GetFICERTID: UnicodeString;
begin
  Result := ChildNodes['FICERTID'].Text;
end;

procedure TXMLCHALLENGERQType.SetFICERTID(Value: UnicodeString);
begin
  ChildNodes['FICERTID'].NodeValue := Value;
end;

{ TXMLSIGNONMSGSRSV1Type }

procedure TXMLSIGNONMSGSRSV1Type.AfterConstruction;
begin
  RegisterChildNode('SONRS', TXMLSONRSType);
  RegisterChildNode('PINCHTRNRS', TXMLPINCHTRNRSType);
  RegisterChildNode('CHALLENGETRNRS', TXMLCHALLENGETRNRSType);
  inherited;
end;

function TXMLSIGNONMSGSRSV1Type.GetSONRS: IXMLSONRSType;
begin
  Result := ChildNodes['SONRS'] as IXMLSONRSType;
end;

function TXMLSIGNONMSGSRSV1Type.GetPINCHTRNRS: IXMLPINCHTRNRSType;
begin
  Result := ChildNodes['PINCHTRNRS'] as IXMLPINCHTRNRSType;
end;

function TXMLSIGNONMSGSRSV1Type.GetCHALLENGETRNRS: IXMLCHALLENGETRNRSType;
begin
  Result := ChildNodes['CHALLENGETRNRS'] as IXMLCHALLENGETRNRSType;
end;

{ TXMLSONRSType }

procedure TXMLSONRSType.AfterConstruction;
begin
  RegisterChildNode('STATUS', TXMLSTATUSType);
  RegisterChildNode('FI', TXMLFIType);
  inherited;
end;

function TXMLSONRSType.GetSTATUS: IXMLSTATUSType;
begin
  Result := ChildNodes['STATUS'] as IXMLSTATUSType;
end;

function TXMLSONRSType.GetDTSERVER: UnicodeString;
begin
  Result := ChildNodes['DTSERVER'].Text;
end;

procedure TXMLSONRSType.SetDTSERVER(Value: UnicodeString);
begin
  ChildNodes['DTSERVER'].NodeValue := Value;
end;

function TXMLSONRSType.GetUSERKEY: UnicodeString;
begin
  Result := ChildNodes['USERKEY'].Text;
end;

procedure TXMLSONRSType.SetUSERKEY(Value: UnicodeString);
begin
  ChildNodes['USERKEY'].NodeValue := Value;
end;

function TXMLSONRSType.GetTSKEYEXPIRE: UnicodeString;
begin
  Result := ChildNodes['TSKEYEXPIRE'].Text;
end;

procedure TXMLSONRSType.SetTSKEYEXPIRE(Value: UnicodeString);
begin
  ChildNodes['TSKEYEXPIRE'].NodeValue := Value;
end;

function TXMLSONRSType.GetLANGUAGE: UnicodeString;
begin
  Result := ChildNodes['LANGUAGE'].Text;
end;

procedure TXMLSONRSType.SetLANGUAGE(Value: UnicodeString);
begin
  ChildNodes['LANGUAGE'].NodeValue := Value;
end;

function TXMLSONRSType.GetDTPROFUP: UnicodeString;
begin
  Result := ChildNodes['DTPROFUP'].Text;
end;

procedure TXMLSONRSType.SetDTPROFUP(Value: UnicodeString);
begin
  ChildNodes['DTPROFUP'].NodeValue := Value;
end;

function TXMLSONRSType.GetDTACCTUP: UnicodeString;
begin
  Result := ChildNodes['DTACCTUP'].Text;
end;

procedure TXMLSONRSType.SetDTACCTUP(Value: UnicodeString);
begin
  ChildNodes['DTACCTUP'].NodeValue := Value;
end;

function TXMLSONRSType.GetFI: IXMLFIType;
begin
  Result := ChildNodes['FI'] as IXMLFIType;
end;

function TXMLSONRSType.GetSESSCOOKIE: UnicodeString;
begin
  Result := ChildNodes['SESSCOOKIE'].Text;
end;

procedure TXMLSONRSType.SetSESSCOOKIE(Value: UnicodeString);
begin
  ChildNodes['SESSCOOKIE'].NodeValue := Value;
end;

{ TXMLSTATUSType }

function TXMLSTATUSType.GetCODE: UnicodeString;
begin
  Result := ChildNodes['CODE'].Text;
end;

procedure TXMLSTATUSType.SetCODE(Value: UnicodeString);
begin
  ChildNodes['CODE'].NodeValue := Value;
end;

function TXMLSTATUSType.GetSEVERITY: UnicodeString;
begin
  Result := ChildNodes['SEVERITY'].Text;
end;

procedure TXMLSTATUSType.SetSEVERITY(Value: UnicodeString);
begin
  ChildNodes['SEVERITY'].NodeValue := Value;
end;

function TXMLSTATUSType.GetMESSAGE: UnicodeString;
begin
  Result := ChildNodes['MESSAGE'].Text;
end;

procedure TXMLSTATUSType.SetMESSAGE(Value: UnicodeString);
begin
  ChildNodes['MESSAGE'].NodeValue := Value;
end;

{ TXMLPINCHTRNRSType }

procedure TXMLPINCHTRNRSType.AfterConstruction;
begin
  RegisterChildNode('PINCHRS', TXMLPINCHRSType);
  inherited;
end;

function TXMLPINCHTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLPINCHTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLPINCHTRNRSType.GetPINCHRS: IXMLPINCHRSType;
begin
  Result := ChildNodes['PINCHRS'] as IXMLPINCHRSType;
end;

{ TXMLPINCHRSType }

function TXMLPINCHRSType.GetUSERID: UnicodeString;
begin
  Result := ChildNodes['USERID'].Text;
end;

procedure TXMLPINCHRSType.SetUSERID(Value: UnicodeString);
begin
  ChildNodes['USERID'].NodeValue := Value;
end;

function TXMLPINCHRSType.GetDTCHANGED: UnicodeString;
begin
  Result := ChildNodes['DTCHANGED'].Text;
end;

procedure TXMLPINCHRSType.SetDTCHANGED(Value: UnicodeString);
begin
  ChildNodes['DTCHANGED'].NodeValue := Value;
end;

{ TXMLCHALLENGETRNRSType }

procedure TXMLCHALLENGETRNRSType.AfterConstruction;
begin
  RegisterChildNode('CHALLENGERS', TXMLCHALLENGERSType);
  inherited;
end;

function TXMLCHALLENGETRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLCHALLENGETRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLCHALLENGETRNRSType.GetCHALLENGERS: IXMLCHALLENGERSType;
begin
  Result := ChildNodes['CHALLENGERS'] as IXMLCHALLENGERSType;
end;

{ TXMLCHALLENGERSType }

function TXMLCHALLENGERSType.GetUSERID: UnicodeString;
begin
  Result := ChildNodes['USERID'].Text;
end;

procedure TXMLCHALLENGERSType.SetUSERID(Value: UnicodeString);
begin
  ChildNodes['USERID'].NodeValue := Value;
end;

function TXMLCHALLENGERSType.GetNONCE: UnicodeString;
begin
  Result := ChildNodes['NONCE'].Text;
end;

procedure TXMLCHALLENGERSType.SetNONCE(Value: UnicodeString);
begin
  ChildNodes['NONCE'].NodeValue := Value;
end;

function TXMLCHALLENGERSType.GetFICERTID: UnicodeString;
begin
  Result := ChildNodes['FICERTID'].Text;
end;

procedure TXMLCHALLENGERSType.SetFICERTID(Value: UnicodeString);
begin
  ChildNodes['FICERTID'].NodeValue := Value;
end;

{ TXMLSIGNONMSGSETType }

procedure TXMLSIGNONMSGSETType.AfterConstruction;
begin
  RegisterChildNode('SIGNONMSGSETV1', TXMLSIGNONMSGSETV1Type);
  inherited;
end;

function TXMLSIGNONMSGSETType.GetSIGNONMSGSETV1: IXMLSIGNONMSGSETV1Type;
begin
  Result := ChildNodes['SIGNONMSGSETV1'] as IXMLSIGNONMSGSETV1Type;
end;

{ TXMLSIGNONMSGSETV1Type }

procedure TXMLSIGNONMSGSETV1Type.AfterConstruction;
begin
  RegisterChildNode('MSGSETCORE', TXMLMSGSETCOREType);
  inherited;
end;

function TXMLSIGNONMSGSETV1Type.GetMSGSETCORE: IXMLMSGSETCOREType;
begin
  Result := ChildNodes['MSGSETCORE'] as IXMLMSGSETCOREType;
end;

{ TXMLMSGSETCOREType }

procedure TXMLMSGSETCOREType.AfterConstruction;
begin
  FLANGUAGE := CreateCollection(TXMLString_List, IXMLNode, 'LANGUAGE') as IXMLString_List;
  inherited;
end;

function TXMLMSGSETCOREType.GetVER: UnicodeString;
begin
  Result := ChildNodes['VER'].Text;
end;

procedure TXMLMSGSETCOREType.SetVER(Value: UnicodeString);
begin
  ChildNodes['VER'].NodeValue := Value;
end;

function TXMLMSGSETCOREType.GetURL: UnicodeString;
begin
  Result := ChildNodes['URL'].Text;
end;

procedure TXMLMSGSETCOREType.SetURL(Value: UnicodeString);
begin
  ChildNodes['URL'].NodeValue := Value;
end;

function TXMLMSGSETCOREType.GetOFXSEC: UnicodeString;
begin
  Result := ChildNodes['OFXSEC'].Text;
end;

procedure TXMLMSGSETCOREType.SetOFXSEC(Value: UnicodeString);
begin
  ChildNodes['OFXSEC'].NodeValue := Value;
end;

function TXMLMSGSETCOREType.GetTRANSPSEC: UnicodeString;
begin
  Result := ChildNodes['TRANSPSEC'].Text;
end;

procedure TXMLMSGSETCOREType.SetTRANSPSEC(Value: UnicodeString);
begin
  ChildNodes['TRANSPSEC'].NodeValue := Value;
end;

function TXMLMSGSETCOREType.GetSIGNONREALM: UnicodeString;
begin
  Result := ChildNodes['SIGNONREALM'].Text;
end;

procedure TXMLMSGSETCOREType.SetSIGNONREALM(Value: UnicodeString);
begin
  ChildNodes['SIGNONREALM'].NodeValue := Value;
end;

function TXMLMSGSETCOREType.GetLANGUAGE: IXMLString_List;
begin
  Result := FLANGUAGE;
end;

function TXMLMSGSETCOREType.GetSYNCMODE: UnicodeString;
begin
  Result := ChildNodes['SYNCMODE'].Text;
end;

procedure TXMLMSGSETCOREType.SetSYNCMODE(Value: UnicodeString);
begin
  ChildNodes['SYNCMODE'].NodeValue := Value;
end;

function TXMLMSGSETCOREType.GetRESPFILEER: UnicodeString;
begin
  Result := ChildNodes['RESPFILEER'].Text;
end;

procedure TXMLMSGSETCOREType.SetRESPFILEER(Value: UnicodeString);
begin
  ChildNodes['RESPFILEER'].NodeValue := Value;
end;

function TXMLMSGSETCOREType.GetSPNAME: UnicodeString;
begin
  Result := ChildNodes['SPNAME'].Text;
end;

procedure TXMLMSGSETCOREType.SetSPNAME(Value: UnicodeString);
begin
  ChildNodes['SPNAME'].NodeValue := Value;
end;

{ TXMLBANKMSGSETType }

procedure TXMLBANKMSGSETType.AfterConstruction;
begin
  RegisterChildNode('BANKMSGSETV1', TXMLBANKMSGSETV1Type);
  inherited;
end;

function TXMLBANKMSGSETType.GetBANKMSGSETV1: IXMLBANKMSGSETV1Type;
begin
  Result := ChildNodes['BANKMSGSETV1'] as IXMLBANKMSGSETV1Type;
end;

{ TXMLBANKMSGSETV1Type }

procedure TXMLBANKMSGSETV1Type.AfterConstruction;
begin
  RegisterChildNode('MSGSETCORE', TXMLMSGSETCOREType);
  RegisterChildNode('XFERPROF', TXMLXFERPROFType);
  RegisterChildNode('STPCHKPROF', TXMLSTPCHKPROFType);
  RegisterChildNode('EMAILPROF', TXMLEMAILPROFType);
  FINVALIDACCTTYPE := CreateCollection(TXMLString_List, IXMLNode, 'INVALIDACCTTYPE') as IXMLString_List;
  inherited;
end;

function TXMLBANKMSGSETV1Type.GetMSGSETCORE: IXMLMSGSETCOREType;
begin
  Result := ChildNodes['MSGSETCORE'] as IXMLMSGSETCOREType;
end;

function TXMLBANKMSGSETV1Type.GetINVALIDACCTTYPE: IXMLString_List;
begin
  Result := FINVALIDACCTTYPE;
end;

function TXMLBANKMSGSETV1Type.GetCLOSINGAVAIL: UnicodeString;
begin
  Result := ChildNodes['CLOSINGAVAIL'].Text;
end;

procedure TXMLBANKMSGSETV1Type.SetCLOSINGAVAIL(Value: UnicodeString);
begin
  ChildNodes['CLOSINGAVAIL'].NodeValue := Value;
end;

function TXMLBANKMSGSETV1Type.GetXFERPROF: IXMLXFERPROFType;
begin
  Result := ChildNodes['XFERPROF'] as IXMLXFERPROFType;
end;

function TXMLBANKMSGSETV1Type.GetSTPCHKPROF: IXMLSTPCHKPROFType;
begin
  Result := ChildNodes['STPCHKPROF'] as IXMLSTPCHKPROFType;
end;

function TXMLBANKMSGSETV1Type.GetEMAILPROF: IXMLEMAILPROFType;
begin
  Result := ChildNodes['EMAILPROF'] as IXMLEMAILPROFType;
end;

{ TXMLXFERPROFType }

procedure TXMLXFERPROFType.AfterConstruction;
begin
  FPROCDAYSOFF := CreateCollection(TXMLString_List, IXMLNode, 'PROCDAYSOFF') as IXMLString_List;
  inherited;
end;

function TXMLXFERPROFType.GetPROCDAYSOFF: IXMLString_List;
begin
  Result := FPROCDAYSOFF;
end;

function TXMLXFERPROFType.GetPROCENDTM: UnicodeString;
begin
  Result := ChildNodes['PROCENDTM'].Text;
end;

procedure TXMLXFERPROFType.SetPROCENDTM(Value: UnicodeString);
begin
  ChildNodes['PROCENDTM'].NodeValue := Value;
end;

function TXMLXFERPROFType.GetCANSCHED: UnicodeString;
begin
  Result := ChildNodes['CANSCHED'].Text;
end;

procedure TXMLXFERPROFType.SetCANSCHED(Value: UnicodeString);
begin
  ChildNodes['CANSCHED'].NodeValue := Value;
end;

function TXMLXFERPROFType.GetCANRECUR: UnicodeString;
begin
  Result := ChildNodes['CANRECUR'].Text;
end;

procedure TXMLXFERPROFType.SetCANRECUR(Value: UnicodeString);
begin
  ChildNodes['CANRECUR'].NodeValue := Value;
end;

function TXMLXFERPROFType.GetCANMODXFERS: UnicodeString;
begin
  Result := ChildNodes['CANMODXFERS'].Text;
end;

procedure TXMLXFERPROFType.SetCANMODXFERS(Value: UnicodeString);
begin
  ChildNodes['CANMODXFERS'].NodeValue := Value;
end;

function TXMLXFERPROFType.GetCANMODMDLS: UnicodeString;
begin
  Result := ChildNodes['CANMODMDLS'].Text;
end;

procedure TXMLXFERPROFType.SetCANMODMDLS(Value: UnicodeString);
begin
  ChildNodes['CANMODMDLS'].NodeValue := Value;
end;

function TXMLXFERPROFType.GetMODELWND: UnicodeString;
begin
  Result := ChildNodes['MODELWND'].Text;
end;

procedure TXMLXFERPROFType.SetMODELWND(Value: UnicodeString);
begin
  ChildNodes['MODELWND'].NodeValue := Value;
end;

function TXMLXFERPROFType.GetDAYSWITH: UnicodeString;
begin
  Result := ChildNodes['DAYSWITH'].Text;
end;

procedure TXMLXFERPROFType.SetDAYSWITH(Value: UnicodeString);
begin
  ChildNodes['DAYSWITH'].NodeValue := Value;
end;

function TXMLXFERPROFType.GetDFLTDAYSTOPAY: UnicodeString;
begin
  Result := ChildNodes['DFLTDAYSTOPAY'].Text;
end;

procedure TXMLXFERPROFType.SetDFLTDAYSTOPAY(Value: UnicodeString);
begin
  ChildNodes['DFLTDAYSTOPAY'].NodeValue := Value;
end;

{ TXMLSTPCHKPROFType }

procedure TXMLSTPCHKPROFType.AfterConstruction;
begin
  FPROCDAYSOFF := CreateCollection(TXMLString_List, IXMLNode, 'PROCDAYSOFF') as IXMLString_List;
  inherited;
end;

function TXMLSTPCHKPROFType.GetPROCDAYSOFF: IXMLString_List;
begin
  Result := FPROCDAYSOFF;
end;

function TXMLSTPCHKPROFType.GetPROCENDTM: UnicodeString;
begin
  Result := ChildNodes['PROCENDTM'].Text;
end;

procedure TXMLSTPCHKPROFType.SetPROCENDTM(Value: UnicodeString);
begin
  ChildNodes['PROCENDTM'].NodeValue := Value;
end;

function TXMLSTPCHKPROFType.GetCANUSERANGE: UnicodeString;
begin
  Result := ChildNodes['CANUSERANGE'].Text;
end;

procedure TXMLSTPCHKPROFType.SetCANUSERANGE(Value: UnicodeString);
begin
  ChildNodes['CANUSERANGE'].NodeValue := Value;
end;

function TXMLSTPCHKPROFType.GetCANUSEDESC: UnicodeString;
begin
  Result := ChildNodes['CANUSEDESC'].Text;
end;

procedure TXMLSTPCHKPROFType.SetCANUSEDESC(Value: UnicodeString);
begin
  ChildNodes['CANUSEDESC'].NodeValue := Value;
end;

function TXMLSTPCHKPROFType.GetSTPCHKFEE: UnicodeString;
begin
  Result := ChildNodes['STPCHKFEE'].Text;
end;

procedure TXMLSTPCHKPROFType.SetSTPCHKFEE(Value: UnicodeString);
begin
  ChildNodes['STPCHKFEE'].NodeValue := Value;
end;

{ TXMLEMAILPROFType }

function TXMLEMAILPROFType.GetCANEMAIL: UnicodeString;
begin
  Result := ChildNodes['CANEMAIL'].Text;
end;

procedure TXMLEMAILPROFType.SetCANEMAIL(Value: UnicodeString);
begin
  ChildNodes['CANEMAIL'].NodeValue := Value;
end;

function TXMLEMAILPROFType.GetCANNOTIFY: UnicodeString;
begin
  Result := ChildNodes['CANNOTIFY'].Text;
end;

procedure TXMLEMAILPROFType.SetCANNOTIFY(Value: UnicodeString);
begin
  ChildNodes['CANNOTIFY'].NodeValue := Value;
end;

{ TXMLCREDITCARDMSGSETType }

procedure TXMLCREDITCARDMSGSETType.AfterConstruction;
begin
  RegisterChildNode('CREDITCARDMSGSETV1', TXMLCREDITCARDMSGSETV1Type);
  inherited;
end;

function TXMLCREDITCARDMSGSETType.GetCREDITCARDMSGSETV1: IXMLCREDITCARDMSGSETV1Type;
begin
  Result := ChildNodes['CREDITCARDMSGSETV1'] as IXMLCREDITCARDMSGSETV1Type;
end;

{ TXMLCREDITCARDMSGSETV1Type }

procedure TXMLCREDITCARDMSGSETV1Type.AfterConstruction;
begin
  RegisterChildNode('MSGSETCORE', TXMLMSGSETCOREType);
  inherited;
end;

function TXMLCREDITCARDMSGSETV1Type.GetMSGSETCORE: IXMLMSGSETCOREType;
begin
  Result := ChildNodes['MSGSETCORE'] as IXMLMSGSETCOREType;
end;

function TXMLCREDITCARDMSGSETV1Type.GetCLOSINGAVAIL: UnicodeString;
begin
  Result := ChildNodes['CLOSINGAVAIL'].Text;
end;

procedure TXMLCREDITCARDMSGSETV1Type.SetCLOSINGAVAIL(Value: UnicodeString);
begin
  ChildNodes['CLOSINGAVAIL'].NodeValue := Value;
end;

{ TXMLINTERXFERMSGSETType }

procedure TXMLINTERXFERMSGSETType.AfterConstruction;
begin
  RegisterChildNode('INTERXFERMSGSETV1', TXMLINTERXFERMSGSETV1Type);
  inherited;
end;

function TXMLINTERXFERMSGSETType.GetINTERXFERMSGSETV1: IXMLINTERXFERMSGSETV1Type;
begin
  Result := ChildNodes['INTERXFERMSGSETV1'] as IXMLINTERXFERMSGSETV1Type;
end;

{ TXMLINTERXFERMSGSETV1Type }

procedure TXMLINTERXFERMSGSETV1Type.AfterConstruction;
begin
  RegisterChildNode('MSGSETCORE', TXMLMSGSETCOREType);
  RegisterChildNode('XFERPROF', TXMLXFERPROFType);
  inherited;
end;

function TXMLINTERXFERMSGSETV1Type.GetMSGSETCORE: IXMLMSGSETCOREType;
begin
  Result := ChildNodes['MSGSETCORE'] as IXMLMSGSETCOREType;
end;

function TXMLINTERXFERMSGSETV1Type.GetXFERPROF: IXMLXFERPROFType;
begin
  Result := ChildNodes['XFERPROF'] as IXMLXFERPROFType;
end;

function TXMLINTERXFERMSGSETV1Type.GetCANBILLPAY: UnicodeString;
begin
  Result := ChildNodes['CANBILLPAY'].Text;
end;

procedure TXMLINTERXFERMSGSETV1Type.SetCANBILLPAY(Value: UnicodeString);
begin
  ChildNodes['CANBILLPAY'].NodeValue := Value;
end;

function TXMLINTERXFERMSGSETV1Type.GetCANCELWND: UnicodeString;
begin
  Result := ChildNodes['CANCELWND'].Text;
end;

procedure TXMLINTERXFERMSGSETV1Type.SetCANCELWND(Value: UnicodeString);
begin
  ChildNodes['CANCELWND'].NodeValue := Value;
end;

function TXMLINTERXFERMSGSETV1Type.GetDOMXFERFEE: UnicodeString;
begin
  Result := ChildNodes['DOMXFERFEE'].Text;
end;

procedure TXMLINTERXFERMSGSETV1Type.SetDOMXFERFEE(Value: UnicodeString);
begin
  ChildNodes['DOMXFERFEE'].NodeValue := Value;
end;

function TXMLINTERXFERMSGSETV1Type.GetINTLXFERFEE: UnicodeString;
begin
  Result := ChildNodes['INTLXFERFEE'].Text;
end;

procedure TXMLINTERXFERMSGSETV1Type.SetINTLXFERFEE(Value: UnicodeString);
begin
  ChildNodes['INTLXFERFEE'].NodeValue := Value;
end;

{ TXMLWIREXFERMSGSETType }

procedure TXMLWIREXFERMSGSETType.AfterConstruction;
begin
  RegisterChildNode('WIREXFERMSGSETV1', TXMLWIREXFERMSGSETV1Type);
  inherited;
end;

function TXMLWIREXFERMSGSETType.GetWIREXFERMSGSETV1: IXMLWIREXFERMSGSETV1Type;
begin
  Result := ChildNodes['WIREXFERMSGSETV1'] as IXMLWIREXFERMSGSETV1Type;
end;

{ TXMLWIREXFERMSGSETV1Type }

procedure TXMLWIREXFERMSGSETV1Type.AfterConstruction;
begin
  RegisterChildNode('MSGSETCORE', TXMLMSGSETCOREType);
  FPROCDAYSOFF := CreateCollection(TXMLString_List, IXMLNode, 'PROCDAYSOFF') as IXMLString_List;
  inherited;
end;

function TXMLWIREXFERMSGSETV1Type.GetMSGSETCORE: IXMLMSGSETCOREType;
begin
  Result := ChildNodes['MSGSETCORE'] as IXMLMSGSETCOREType;
end;

function TXMLWIREXFERMSGSETV1Type.GetPROCDAYSOFF: IXMLString_List;
begin
  Result := FPROCDAYSOFF;
end;

function TXMLWIREXFERMSGSETV1Type.GetPROCENDTM: UnicodeString;
begin
  Result := ChildNodes['PROCENDTM'].Text;
end;

procedure TXMLWIREXFERMSGSETV1Type.SetPROCENDTM(Value: UnicodeString);
begin
  ChildNodes['PROCENDTM'].NodeValue := Value;
end;

function TXMLWIREXFERMSGSETV1Type.GetCANSCHED: UnicodeString;
begin
  Result := ChildNodes['CANSCHED'].Text;
end;

procedure TXMLWIREXFERMSGSETV1Type.SetCANSCHED(Value: UnicodeString);
begin
  ChildNodes['CANSCHED'].NodeValue := Value;
end;

function TXMLWIREXFERMSGSETV1Type.GetDOMXFERFEE: UnicodeString;
begin
  Result := ChildNodes['DOMXFERFEE'].Text;
end;

procedure TXMLWIREXFERMSGSETV1Type.SetDOMXFERFEE(Value: UnicodeString);
begin
  ChildNodes['DOMXFERFEE'].NodeValue := Value;
end;

function TXMLWIREXFERMSGSETV1Type.GetINTLXFERFEE: UnicodeString;
begin
  Result := ChildNodes['INTLXFERFEE'].Text;
end;

procedure TXMLWIREXFERMSGSETV1Type.SetINTLXFERFEE(Value: UnicodeString);
begin
  ChildNodes['INTLXFERFEE'].NodeValue := Value;
end;

{ TXMLBANKMSGSRQV1Type }

procedure TXMLBANKMSGSRQV1Type.AfterConstruction;
begin
  RegisterChildNode('STMTTRNRQ', TXMLSTMTTRNRQType);
  RegisterChildNode('STMTENDTRNRQ', TXMLSTMTENDTRNRQType);
  RegisterChildNode('INTRATRNRQ', TXMLINTRATRNRQType);
  RegisterChildNode('RECINTRATRNRQ', TXMLRECINTRATRNRQType);
  RegisterChildNode('STPCHKTRNRQ', TXMLSTPCHKTRNRQType);
  RegisterChildNode('BANKMAILTRNRQ', TXMLBANKMAILTRNRQType);
  RegisterChildNode('BANKMAILSYNCRQ', TXMLBANKMAILSYNCRQType);
  RegisterChildNode('STPCHKSYNCRQ', TXMLSTPCHKSYNCRQType);
  RegisterChildNode('INTRASYNCRQ', TXMLINTRASYNCRQType);
  RegisterChildNode('RECINTRASYNCRQ', TXMLRECINTRASYNCRQType);
  FSTMTTRNRQ := CreateCollection(TXMLSTMTTRNRQTypeList, IXMLSTMTTRNRQType, 'STMTTRNRQ') as IXMLSTMTTRNRQTypeList;
  FSTMTENDTRNRQ := CreateCollection(TXMLSTMTENDTRNRQTypeList, IXMLSTMTENDTRNRQType, 'STMTENDTRNRQ') as IXMLSTMTENDTRNRQTypeList;
  FINTRATRNRQ := CreateCollection(TXMLINTRATRNRQTypeList, IXMLINTRATRNRQType, 'INTRATRNRQ') as IXMLINTRATRNRQTypeList;
  FRECINTRATRNRQ := CreateCollection(TXMLRECINTRATRNRQTypeList, IXMLRECINTRATRNRQType, 'RECINTRATRNRQ') as IXMLRECINTRATRNRQTypeList;
  FSTPCHKTRNRQ := CreateCollection(TXMLSTPCHKTRNRQTypeList, IXMLSTPCHKTRNRQType, 'STPCHKTRNRQ') as IXMLSTPCHKTRNRQTypeList;
  FBANKMAILTRNRQ := CreateCollection(TXMLBANKMAILTRNRQTypeList, IXMLBANKMAILTRNRQType, 'BANKMAILTRNRQ') as IXMLBANKMAILTRNRQTypeList;
  FBANKMAILSYNCRQ := CreateCollection(TXMLBANKMAILSYNCRQTypeList, IXMLBANKMAILSYNCRQType, 'BANKMAILSYNCRQ') as IXMLBANKMAILSYNCRQTypeList;
  FSTPCHKSYNCRQ := CreateCollection(TXMLSTPCHKSYNCRQTypeList, IXMLSTPCHKSYNCRQType, 'STPCHKSYNCRQ') as IXMLSTPCHKSYNCRQTypeList;
  FINTRASYNCRQ := CreateCollection(TXMLINTRASYNCRQTypeList, IXMLINTRASYNCRQType, 'INTRASYNCRQ') as IXMLINTRASYNCRQTypeList;
  FRECINTRASYNCRQ := CreateCollection(TXMLRECINTRASYNCRQTypeList, IXMLRECINTRASYNCRQType, 'RECINTRASYNCRQ') as IXMLRECINTRASYNCRQTypeList;
  inherited;
end;

function TXMLBANKMSGSRQV1Type.GetSTMTTRNRQ: IXMLSTMTTRNRQTypeList;
begin
  Result := FSTMTTRNRQ;
end;

function TXMLBANKMSGSRQV1Type.GetSTMTENDTRNRQ: IXMLSTMTENDTRNRQTypeList;
begin
  Result := FSTMTENDTRNRQ;
end;

function TXMLBANKMSGSRQV1Type.GetINTRATRNRQ: IXMLINTRATRNRQTypeList;
begin
  Result := FINTRATRNRQ;
end;

function TXMLBANKMSGSRQV1Type.GetRECINTRATRNRQ: IXMLRECINTRATRNRQTypeList;
begin
  Result := FRECINTRATRNRQ;
end;

function TXMLBANKMSGSRQV1Type.GetSTPCHKTRNRQ: IXMLSTPCHKTRNRQTypeList;
begin
  Result := FSTPCHKTRNRQ;
end;

function TXMLBANKMSGSRQV1Type.GetBANKMAILTRNRQ: IXMLBANKMAILTRNRQTypeList;
begin
  Result := FBANKMAILTRNRQ;
end;

function TXMLBANKMSGSRQV1Type.GetBANKMAILSYNCRQ: IXMLBANKMAILSYNCRQTypeList;
begin
  Result := FBANKMAILSYNCRQ;
end;

function TXMLBANKMSGSRQV1Type.GetSTPCHKSYNCRQ: IXMLSTPCHKSYNCRQTypeList;
begin
  Result := FSTPCHKSYNCRQ;
end;

function TXMLBANKMSGSRQV1Type.GetINTRASYNCRQ: IXMLINTRASYNCRQTypeList;
begin
  Result := FINTRASYNCRQ;
end;

function TXMLBANKMSGSRQV1Type.GetRECINTRASYNCRQ: IXMLRECINTRASYNCRQTypeList;
begin
  Result := FRECINTRASYNCRQ;
end;

{ TXMLSTMTTRNRQType }

procedure TXMLSTMTTRNRQType.AfterConstruction;
begin
  RegisterChildNode('STMTRQ', TXMLSTMTRQType);
  inherited;
end;

function TXMLSTMTTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLSTMTTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLSTMTTRNRQType.GetSTMTRQ: IXMLSTMTRQType;
begin
  Result := ChildNodes['STMTRQ'] as IXMLSTMTRQType;
end;

{ TXMLSTMTTRNRQTypeList }

function TXMLSTMTTRNRQTypeList.Add: IXMLSTMTTRNRQType;
begin
  Result := AddItem(-1) as IXMLSTMTTRNRQType;
end;

function TXMLSTMTTRNRQTypeList.Insert(const Index: Integer): IXMLSTMTTRNRQType;
begin
  Result := AddItem(Index) as IXMLSTMTTRNRQType;
end;

function TXMLSTMTTRNRQTypeList.GetItem(Index: Integer): IXMLSTMTTRNRQType;
begin
  Result := List[Index] as IXMLSTMTTRNRQType;
end;

{ TXMLSTMTRQType }

procedure TXMLSTMTRQType.AfterConstruction;
begin
  RegisterChildNode('INCTRAN', TXMLINCTRANType);
  inherited;
end;

function TXMLSTMTRQType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLSTMTRQType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLSTMTRQType.GetINCTRAN: IXMLINCTRANType;
begin
  Result := ChildNodes['INCTRAN'] as IXMLINCTRANType;
end;

{ TXMLINCTRANType }

function TXMLINCTRANType.GetDTSTART: UnicodeString;
begin
  Result := ChildNodes['DTSTART'].Text;
end;

procedure TXMLINCTRANType.SetDTSTART(Value: UnicodeString);
begin
  ChildNodes['DTSTART'].NodeValue := Value;
end;

function TXMLINCTRANType.GetDTEND: UnicodeString;
begin
  Result := ChildNodes['DTEND'].Text;
end;

procedure TXMLINCTRANType.SetDTEND(Value: UnicodeString);
begin
  ChildNodes['DTEND'].NodeValue := Value;
end;

function TXMLINCTRANType.GetINCLUDE: UnicodeString;
begin
  Result := ChildNodes['INCLUDE'].Text;
end;

procedure TXMLINCTRANType.SetINCLUDE(Value: UnicodeString);
begin
  ChildNodes['INCLUDE'].NodeValue := Value;
end;

{ TXMLSTMTENDTRNRQType }

procedure TXMLSTMTENDTRNRQType.AfterConstruction;
begin
  RegisterChildNode('STMTENDRQ', TXMLSTMTENDRQType);
  inherited;
end;

function TXMLSTMTENDTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLSTMTENDTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLSTMTENDTRNRQType.GetSTMTENDRQ: IXMLSTMTENDRQType;
begin
  Result := ChildNodes['STMTENDRQ'] as IXMLSTMTENDRQType;
end;

{ TXMLSTMTENDTRNRQTypeList }

function TXMLSTMTENDTRNRQTypeList.Add: IXMLSTMTENDTRNRQType;
begin
  Result := AddItem(-1) as IXMLSTMTENDTRNRQType;
end;

function TXMLSTMTENDTRNRQTypeList.Insert(const Index: Integer): IXMLSTMTENDTRNRQType;
begin
  Result := AddItem(Index) as IXMLSTMTENDTRNRQType;
end;

function TXMLSTMTENDTRNRQTypeList.GetItem(Index: Integer): IXMLSTMTENDTRNRQType;
begin
  Result := List[Index] as IXMLSTMTENDTRNRQType;
end;

{ TXMLSTMTENDRQType }

function TXMLSTMTENDRQType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLSTMTENDRQType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLSTMTENDRQType.GetDTSTART: UnicodeString;
begin
  Result := ChildNodes['DTSTART'].Text;
end;

procedure TXMLSTMTENDRQType.SetDTSTART(Value: UnicodeString);
begin
  ChildNodes['DTSTART'].NodeValue := Value;
end;

function TXMLSTMTENDRQType.GetDTEND: UnicodeString;
begin
  Result := ChildNodes['DTEND'].Text;
end;

procedure TXMLSTMTENDRQType.SetDTEND(Value: UnicodeString);
begin
  ChildNodes['DTEND'].NodeValue := Value;
end;

{ TXMLINTRATRNRQType }

procedure TXMLINTRATRNRQType.AfterConstruction;
begin
  RegisterChildNode('INTRARQ', TXMLINTRARQType);
  RegisterChildNode('INTRAMODRQ', TXMLINTRAMODRQType);
  RegisterChildNode('INTRACANRQ', TXMLINTRACANRQType);
  inherited;
end;

function TXMLINTRATRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLINTRATRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLINTRATRNRQType.GetINTRARQ: IXMLINTRARQType;
begin
  Result := ChildNodes['INTRARQ'] as IXMLINTRARQType;
end;

function TXMLINTRATRNRQType.GetINTRAMODRQ: IXMLINTRAMODRQType;
begin
  Result := ChildNodes['INTRAMODRQ'] as IXMLINTRAMODRQType;
end;

function TXMLINTRATRNRQType.GetINTRACANRQ: IXMLINTRACANRQType;
begin
  Result := ChildNodes['INTRACANRQ'] as IXMLINTRACANRQType;
end;

{ TXMLINTRATRNRQTypeList }

function TXMLINTRATRNRQTypeList.Add: IXMLINTRATRNRQType;
begin
  Result := AddItem(-1) as IXMLINTRATRNRQType;
end;

function TXMLINTRATRNRQTypeList.Insert(const Index: Integer): IXMLINTRATRNRQType;
begin
  Result := AddItem(Index) as IXMLINTRATRNRQType;
end;

function TXMLINTRATRNRQTypeList.GetItem(Index: Integer): IXMLINTRATRNRQType;
begin
  Result := List[Index] as IXMLINTRATRNRQType;
end;

{ TXMLINTRARQType }

procedure TXMLINTRARQType.AfterConstruction;
begin
  RegisterChildNode('XFERINFO', TXMLXFERINFOType);
  inherited;
end;

function TXMLINTRARQType.GetXFERINFO: IXMLXFERINFOType;
begin
  Result := ChildNodes['XFERINFO'] as IXMLXFERINFOType;
end;

{ TXMLXFERINFOType }

function TXMLXFERINFOType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLXFERINFOType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLXFERINFOType.GetCCACCTFROM: UnicodeString;
begin
  Result := ChildNodes['CCACCTFROM'].Text;
end;

procedure TXMLXFERINFOType.SetCCACCTFROM(Value: UnicodeString);
begin
  ChildNodes['CCACCTFROM'].NodeValue := Value;
end;

function TXMLXFERINFOType.GetBANKACCTTO: UnicodeString;
begin
  Result := ChildNodes['BANKACCTTO'].Text;
end;

procedure TXMLXFERINFOType.SetBANKACCTTO(Value: UnicodeString);
begin
  ChildNodes['BANKACCTTO'].NodeValue := Value;
end;

function TXMLXFERINFOType.GetCCACCTTO: UnicodeString;
begin
  Result := ChildNodes['CCACCTTO'].Text;
end;

procedure TXMLXFERINFOType.SetCCACCTTO(Value: UnicodeString);
begin
  ChildNodes['CCACCTTO'].NodeValue := Value;
end;

function TXMLXFERINFOType.GetTRNAMT: UnicodeString;
begin
  Result := ChildNodes['TRNAMT'].Text;
end;

procedure TXMLXFERINFOType.SetTRNAMT(Value: UnicodeString);
begin
  ChildNodes['TRNAMT'].NodeValue := Value;
end;

function TXMLXFERINFOType.GetDTDUE: UnicodeString;
begin
  Result := ChildNodes['DTDUE'].Text;
end;

procedure TXMLXFERINFOType.SetDTDUE(Value: UnicodeString);
begin
  ChildNodes['DTDUE'].NodeValue := Value;
end;

{ TXMLINTRAMODRQType }

procedure TXMLINTRAMODRQType.AfterConstruction;
begin
  RegisterChildNode('XFERINFO', TXMLXFERINFOType);
  inherited;
end;

function TXMLINTRAMODRQType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLINTRAMODRQType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

function TXMLINTRAMODRQType.GetXFERINFO: IXMLXFERINFOType;
begin
  Result := ChildNodes['XFERINFO'] as IXMLXFERINFOType;
end;

{ TXMLINTRACANRQType }

function TXMLINTRACANRQType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLINTRACANRQType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

{ TXMLRECINTRATRNRQType }

procedure TXMLRECINTRATRNRQType.AfterConstruction;
begin
  RegisterChildNode('RECINTRARQ', TXMLRECINTRARQType);
  RegisterChildNode('RECINTRAMODRQ', TXMLRECINTRAMODRQType);
  RegisterChildNode('RECINTRACANRQ', TXMLRECINTRACANRQType);
  inherited;
end;

function TXMLRECINTRATRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLRECINTRATRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLRECINTRATRNRQType.GetRECINTRARQ: IXMLRECINTRARQType;
begin
  Result := ChildNodes['RECINTRARQ'] as IXMLRECINTRARQType;
end;

function TXMLRECINTRATRNRQType.GetRECINTRAMODRQ: IXMLRECINTRAMODRQType;
begin
  Result := ChildNodes['RECINTRAMODRQ'] as IXMLRECINTRAMODRQType;
end;

function TXMLRECINTRATRNRQType.GetRECINTRACANRQ: IXMLRECINTRACANRQType;
begin
  Result := ChildNodes['RECINTRACANRQ'] as IXMLRECINTRACANRQType;
end;

{ TXMLRECINTRATRNRQTypeList }

function TXMLRECINTRATRNRQTypeList.Add: IXMLRECINTRATRNRQType;
begin
  Result := AddItem(-1) as IXMLRECINTRATRNRQType;
end;

function TXMLRECINTRATRNRQTypeList.Insert(const Index: Integer): IXMLRECINTRATRNRQType;
begin
  Result := AddItem(Index) as IXMLRECINTRATRNRQType;
end;

function TXMLRECINTRATRNRQTypeList.GetItem(Index: Integer): IXMLRECINTRATRNRQType;
begin
  Result := List[Index] as IXMLRECINTRATRNRQType;
end;

{ TXMLRECINTRARQType }

procedure TXMLRECINTRARQType.AfterConstruction;
begin
  RegisterChildNode('RECURRINST', TXMLRECURRINSTType);
  RegisterChildNode('INTRARQ', TXMLINTRARQType);
  inherited;
end;

function TXMLRECINTRARQType.GetRECURRINST: IXMLRECURRINSTType;
begin
  Result := ChildNodes['RECURRINST'] as IXMLRECURRINSTType;
end;

function TXMLRECINTRARQType.GetINTRARQ: IXMLINTRARQType;
begin
  Result := ChildNodes['INTRARQ'] as IXMLINTRARQType;
end;

{ TXMLRECURRINSTType }

function TXMLRECURRINSTType.GetNINSTS: UnicodeString;
begin
  Result := ChildNodes['NINSTS'].Text;
end;

procedure TXMLRECURRINSTType.SetNINSTS(Value: UnicodeString);
begin
  ChildNodes['NINSTS'].NodeValue := Value;
end;

function TXMLRECURRINSTType.GetFREQ: UnicodeString;
begin
  Result := ChildNodes['FREQ'].Text;
end;

procedure TXMLRECURRINSTType.SetFREQ(Value: UnicodeString);
begin
  ChildNodes['FREQ'].NodeValue := Value;
end;

{ TXMLRECINTRAMODRQType }

procedure TXMLRECINTRAMODRQType.AfterConstruction;
begin
  RegisterChildNode('RECURRINST', TXMLRECURRINSTType);
  RegisterChildNode('INTRARQ', TXMLINTRARQType);
  inherited;
end;

function TXMLRECINTRAMODRQType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLRECINTRAMODRQType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

function TXMLRECINTRAMODRQType.GetRECURRINST: IXMLRECURRINSTType;
begin
  Result := ChildNodes['RECURRINST'] as IXMLRECURRINSTType;
end;

function TXMLRECINTRAMODRQType.GetINTRARQ: IXMLINTRARQType;
begin
  Result := ChildNodes['INTRARQ'] as IXMLINTRARQType;
end;

function TXMLRECINTRAMODRQType.GetMODPENDING: UnicodeString;
begin
  Result := ChildNodes['MODPENDING'].Text;
end;

procedure TXMLRECINTRAMODRQType.SetMODPENDING(Value: UnicodeString);
begin
  ChildNodes['MODPENDING'].NodeValue := Value;
end;

{ TXMLRECINTRACANRQType }

function TXMLRECINTRACANRQType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLRECINTRACANRQType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

function TXMLRECINTRACANRQType.GetCANPENDING: UnicodeString;
begin
  Result := ChildNodes['CANPENDING'].Text;
end;

procedure TXMLRECINTRACANRQType.SetCANPENDING(Value: UnicodeString);
begin
  ChildNodes['CANPENDING'].NodeValue := Value;
end;

{ TXMLSTPCHKTRNRQType }

procedure TXMLSTPCHKTRNRQType.AfterConstruction;
begin
  RegisterChildNode('STPCHKRQ', TXMLSTPCHKRQType);
  inherited;
end;

function TXMLSTPCHKTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLSTPCHKTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLSTPCHKTRNRQType.GetSTPCHKRQ: IXMLSTPCHKRQType;
begin
  Result := ChildNodes['STPCHKRQ'] as IXMLSTPCHKRQType;
end;

{ TXMLSTPCHKTRNRQTypeList }

function TXMLSTPCHKTRNRQTypeList.Add: IXMLSTPCHKTRNRQType;
begin
  Result := AddItem(-1) as IXMLSTPCHKTRNRQType;
end;

function TXMLSTPCHKTRNRQTypeList.Insert(const Index: Integer): IXMLSTPCHKTRNRQType;
begin
  Result := AddItem(Index) as IXMLSTPCHKTRNRQType;
end;

function TXMLSTPCHKTRNRQTypeList.GetItem(Index: Integer): IXMLSTPCHKTRNRQType;
begin
  Result := List[Index] as IXMLSTPCHKTRNRQType;
end;

{ TXMLSTPCHKRQType }

procedure TXMLSTPCHKRQType.AfterConstruction;
begin
  RegisterChildNode('CHKRANGE', TXMLCHKRANGEType);
  RegisterChildNode('CHKDESC', TXMLCHKDESCType);
  inherited;
end;

function TXMLSTPCHKRQType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLSTPCHKRQType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLSTPCHKRQType.GetCHKRANGE: IXMLCHKRANGEType;
begin
  Result := ChildNodes['CHKRANGE'] as IXMLCHKRANGEType;
end;

function TXMLSTPCHKRQType.GetCHKDESC: IXMLCHKDESCType;
begin
  Result := ChildNodes['CHKDESC'] as IXMLCHKDESCType;
end;

{ TXMLCHKRANGEType }

function TXMLCHKRANGEType.GetCHKNUMSTART: UnicodeString;
begin
  Result := ChildNodes['CHKNUMSTART'].Text;
end;

procedure TXMLCHKRANGEType.SetCHKNUMSTART(Value: UnicodeString);
begin
  ChildNodes['CHKNUMSTART'].NodeValue := Value;
end;

function TXMLCHKRANGEType.GetCHKNUMEND: UnicodeString;
begin
  Result := ChildNodes['CHKNUMEND'].Text;
end;

procedure TXMLCHKRANGEType.SetCHKNUMEND(Value: UnicodeString);
begin
  ChildNodes['CHKNUMEND'].NodeValue := Value;
end;

{ TXMLCHKDESCType }

function TXMLCHKDESCType.GetNAME: UnicodeString;
begin
  Result := ChildNodes['NAME'].Text;
end;

procedure TXMLCHKDESCType.SetNAME(Value: UnicodeString);
begin
  ChildNodes['NAME'].NodeValue := Value;
end;

function TXMLCHKDESCType.GetCHECKNUM: UnicodeString;
begin
  Result := ChildNodes['CHECKNUM'].Text;
end;

procedure TXMLCHKDESCType.SetCHECKNUM(Value: UnicodeString);
begin
  ChildNodes['CHECKNUM'].NodeValue := Value;
end;

function TXMLCHKDESCType.GetDTUSER: UnicodeString;
begin
  Result := ChildNodes['DTUSER'].Text;
end;

procedure TXMLCHKDESCType.SetDTUSER(Value: UnicodeString);
begin
  ChildNodes['DTUSER'].NodeValue := Value;
end;

function TXMLCHKDESCType.GetTRNAMT: UnicodeString;
begin
  Result := ChildNodes['TRNAMT'].Text;
end;

procedure TXMLCHKDESCType.SetTRNAMT(Value: UnicodeString);
begin
  ChildNodes['TRNAMT'].NodeValue := Value;
end;

{ TXMLBANKMAILTRNRQType }

procedure TXMLBANKMAILTRNRQType.AfterConstruction;
begin
  RegisterChildNode('BANKMAILRQ', TXMLBANKMAILRQType);
  inherited;
end;

function TXMLBANKMAILTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLBANKMAILTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLBANKMAILTRNRQType.GetBANKMAILRQ: IXMLBANKMAILRQType;
begin
  Result := ChildNodes['BANKMAILRQ'] as IXMLBANKMAILRQType;
end;

{ TXMLBANKMAILTRNRQTypeList }

function TXMLBANKMAILTRNRQTypeList.Add: IXMLBANKMAILTRNRQType;
begin
  Result := AddItem(-1) as IXMLBANKMAILTRNRQType;
end;

function TXMLBANKMAILTRNRQTypeList.Insert(const Index: Integer): IXMLBANKMAILTRNRQType;
begin
  Result := AddItem(Index) as IXMLBANKMAILTRNRQType;
end;

function TXMLBANKMAILTRNRQTypeList.GetItem(Index: Integer): IXMLBANKMAILTRNRQType;
begin
  Result := List[Index] as IXMLBANKMAILTRNRQType;
end;

{ TXMLBANKMAILRQType }

procedure TXMLBANKMAILRQType.AfterConstruction;
begin
  RegisterChildNode('MAIL', TXMLMAILType);
  inherited;
end;

function TXMLBANKMAILRQType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLBANKMAILRQType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLBANKMAILRQType.GetCCACCTFROM: UnicodeString;
begin
  Result := ChildNodes['CCACCTFROM'].Text;
end;

procedure TXMLBANKMAILRQType.SetCCACCTFROM(Value: UnicodeString);
begin
  ChildNodes['CCACCTFROM'].NodeValue := Value;
end;

function TXMLBANKMAILRQType.GetMAIL: IXMLMAILType;
begin
  Result := ChildNodes['MAIL'] as IXMLMAILType;
end;

{ TXMLMAILType }

function TXMLMAILType.GetUSERID: UnicodeString;
begin
  Result := ChildNodes['USERID'].Text;
end;

procedure TXMLMAILType.SetUSERID(Value: UnicodeString);
begin
  ChildNodes['USERID'].NodeValue := Value;
end;

function TXMLMAILType.GetDTCREATED: UnicodeString;
begin
  Result := ChildNodes['DTCREATED'].Text;
end;

procedure TXMLMAILType.SetDTCREATED(Value: UnicodeString);
begin
  ChildNodes['DTCREATED'].NodeValue := Value;
end;

function TXMLMAILType.GetFROM: UnicodeString;
begin
  Result := ChildNodes['FROM'].Text;
end;

procedure TXMLMAILType.SetFROM(Value: UnicodeString);
begin
  ChildNodes['FROM'].NodeValue := Value;
end;

function TXMLMAILType.GetTO_: UnicodeString;
begin
  Result := ChildNodes['TO'].Text;
end;

procedure TXMLMAILType.SetTO_(Value: UnicodeString);
begin
  ChildNodes['TO'].NodeValue := Value;
end;

function TXMLMAILType.GetSUBJECT: UnicodeString;
begin
  Result := ChildNodes['SUBJECT'].Text;
end;

procedure TXMLMAILType.SetSUBJECT(Value: UnicodeString);
begin
  ChildNodes['SUBJECT'].NodeValue := Value;
end;

function TXMLMAILType.GetMSGBODY: UnicodeString;
begin
  Result := ChildNodes['MSGBODY'].Text;
end;

procedure TXMLMAILType.SetMSGBODY(Value: UnicodeString);
begin
  ChildNodes['MSGBODY'].NodeValue := Value;
end;

function TXMLMAILType.GetINCIMAGES: UnicodeString;
begin
  Result := ChildNodes['INCIMAGES'].Text;
end;

procedure TXMLMAILType.SetINCIMAGES(Value: UnicodeString);
begin
  ChildNodes['INCIMAGES'].NodeValue := Value;
end;

function TXMLMAILType.GetUSEHTML: UnicodeString;
begin
  Result := ChildNodes['USEHTML'].Text;
end;

procedure TXMLMAILType.SetUSEHTML(Value: UnicodeString);
begin
  ChildNodes['USEHTML'].NodeValue := Value;
end;

{ TXMLBANKMAILSYNCRQType }

procedure TXMLBANKMAILSYNCRQType.AfterConstruction;
begin
  RegisterChildNode('BANKMAILTRNRQ', TXMLBANKMAILTRNRQType);
  FBANKMAILTRNRQ := CreateCollection(TXMLBANKMAILTRNRQTypeList, IXMLBANKMAILTRNRQType, 'BANKMAILTRNRQ') as IXMLBANKMAILTRNRQTypeList;
  inherited;
end;

function TXMLBANKMAILSYNCRQType.GetSYNCRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRQMACRO'].Text;
end;

procedure TXMLBANKMAILSYNCRQType.SetSYNCRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRQMACRO'].NodeValue := Value;
end;

function TXMLBANKMAILSYNCRQType.GetINCIMAGES: UnicodeString;
begin
  Result := ChildNodes['INCIMAGES'].Text;
end;

procedure TXMLBANKMAILSYNCRQType.SetINCIMAGES(Value: UnicodeString);
begin
  ChildNodes['INCIMAGES'].NodeValue := Value;
end;

function TXMLBANKMAILSYNCRQType.GetUSEHTML: UnicodeString;
begin
  Result := ChildNodes['USEHTML'].Text;
end;

procedure TXMLBANKMAILSYNCRQType.SetUSEHTML(Value: UnicodeString);
begin
  ChildNodes['USEHTML'].NodeValue := Value;
end;

function TXMLBANKMAILSYNCRQType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLBANKMAILSYNCRQType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLBANKMAILSYNCRQType.GetCCACCTFROM: UnicodeString;
begin
  Result := ChildNodes['CCACCTFROM'].Text;
end;

procedure TXMLBANKMAILSYNCRQType.SetCCACCTFROM(Value: UnicodeString);
begin
  ChildNodes['CCACCTFROM'].NodeValue := Value;
end;

function TXMLBANKMAILSYNCRQType.GetBANKMAILTRNRQ: IXMLBANKMAILTRNRQTypeList;
begin
  Result := FBANKMAILTRNRQ;
end;

{ TXMLBANKMAILSYNCRQTypeList }

function TXMLBANKMAILSYNCRQTypeList.Add: IXMLBANKMAILSYNCRQType;
begin
  Result := AddItem(-1) as IXMLBANKMAILSYNCRQType;
end;

function TXMLBANKMAILSYNCRQTypeList.Insert(const Index: Integer): IXMLBANKMAILSYNCRQType;
begin
  Result := AddItem(Index) as IXMLBANKMAILSYNCRQType;
end;

function TXMLBANKMAILSYNCRQTypeList.GetItem(Index: Integer): IXMLBANKMAILSYNCRQType;
begin
  Result := List[Index] as IXMLBANKMAILSYNCRQType;
end;

{ TXMLSTPCHKSYNCRQType }

procedure TXMLSTPCHKSYNCRQType.AfterConstruction;
begin
  RegisterChildNode('STPCHKTRNRQ', TXMLSTPCHKTRNRQType);
  FSTPCHKTRNRQ := CreateCollection(TXMLSTPCHKTRNRQTypeList, IXMLSTPCHKTRNRQType, 'STPCHKTRNRQ') as IXMLSTPCHKTRNRQTypeList;
  inherited;
end;

function TXMLSTPCHKSYNCRQType.GetSYNCRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRQMACRO'].Text;
end;

procedure TXMLSTPCHKSYNCRQType.SetSYNCRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRQMACRO'].NodeValue := Value;
end;

function TXMLSTPCHKSYNCRQType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLSTPCHKSYNCRQType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLSTPCHKSYNCRQType.GetSTPCHKTRNRQ: IXMLSTPCHKTRNRQTypeList;
begin
  Result := FSTPCHKTRNRQ;
end;

{ TXMLSTPCHKSYNCRQTypeList }

function TXMLSTPCHKSYNCRQTypeList.Add: IXMLSTPCHKSYNCRQType;
begin
  Result := AddItem(-1) as IXMLSTPCHKSYNCRQType;
end;

function TXMLSTPCHKSYNCRQTypeList.Insert(const Index: Integer): IXMLSTPCHKSYNCRQType;
begin
  Result := AddItem(Index) as IXMLSTPCHKSYNCRQType;
end;

function TXMLSTPCHKSYNCRQTypeList.GetItem(Index: Integer): IXMLSTPCHKSYNCRQType;
begin
  Result := List[Index] as IXMLSTPCHKSYNCRQType;
end;

{ TXMLINTRASYNCRQType }

procedure TXMLINTRASYNCRQType.AfterConstruction;
begin
  RegisterChildNode('INTRATRNRQ', TXMLINTRATRNRQType);
  FINTRATRNRQ := CreateCollection(TXMLINTRATRNRQTypeList, IXMLINTRATRNRQType, 'INTRATRNRQ') as IXMLINTRATRNRQTypeList;
  inherited;
end;

function TXMLINTRASYNCRQType.GetSYNCRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRQMACRO'].Text;
end;

procedure TXMLINTRASYNCRQType.SetSYNCRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRQMACRO'].NodeValue := Value;
end;

function TXMLINTRASYNCRQType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLINTRASYNCRQType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLINTRASYNCRQType.GetINTRATRNRQ: IXMLINTRATRNRQTypeList;
begin
  Result := FINTRATRNRQ;
end;

{ TXMLINTRASYNCRQTypeList }

function TXMLINTRASYNCRQTypeList.Add: IXMLINTRASYNCRQType;
begin
  Result := AddItem(-1) as IXMLINTRASYNCRQType;
end;

function TXMLINTRASYNCRQTypeList.Insert(const Index: Integer): IXMLINTRASYNCRQType;
begin
  Result := AddItem(Index) as IXMLINTRASYNCRQType;
end;

function TXMLINTRASYNCRQTypeList.GetItem(Index: Integer): IXMLINTRASYNCRQType;
begin
  Result := List[Index] as IXMLINTRASYNCRQType;
end;

{ TXMLRECINTRASYNCRQType }

procedure TXMLRECINTRASYNCRQType.AfterConstruction;
begin
  RegisterChildNode('RECINTRATRNRQ', TXMLRECINTRATRNRQType);
  FRECINTRATRNRQ := CreateCollection(TXMLRECINTRATRNRQTypeList, IXMLRECINTRATRNRQType, 'RECINTRATRNRQ') as IXMLRECINTRATRNRQTypeList;
  inherited;
end;

function TXMLRECINTRASYNCRQType.GetSYNCRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRQMACRO'].Text;
end;

procedure TXMLRECINTRASYNCRQType.SetSYNCRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRQMACRO'].NodeValue := Value;
end;

function TXMLRECINTRASYNCRQType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLRECINTRASYNCRQType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLRECINTRASYNCRQType.GetRECINTRATRNRQ: IXMLRECINTRATRNRQTypeList;
begin
  Result := FRECINTRATRNRQ;
end;

{ TXMLRECINTRASYNCRQTypeList }

function TXMLRECINTRASYNCRQTypeList.Add: IXMLRECINTRASYNCRQType;
begin
  Result := AddItem(-1) as IXMLRECINTRASYNCRQType;
end;

function TXMLRECINTRASYNCRQTypeList.Insert(const Index: Integer): IXMLRECINTRASYNCRQType;
begin
  Result := AddItem(Index) as IXMLRECINTRASYNCRQType;
end;

function TXMLRECINTRASYNCRQTypeList.GetItem(Index: Integer): IXMLRECINTRASYNCRQType;
begin
  Result := List[Index] as IXMLRECINTRASYNCRQType;
end;

{ TXMLCREDITCARDMSGSRQV1Type }

procedure TXMLCREDITCARDMSGSRQV1Type.AfterConstruction;
begin
  RegisterChildNode('CCSTMTTRNRQ', TXMLCCSTMTTRNRQType);
  RegisterChildNode('CCSTMTENDTRNRQ', TXMLCCSTMTENDTRNRQType);
  FCCSTMTTRNRQ := CreateCollection(TXMLCCSTMTTRNRQTypeList, IXMLCCSTMTTRNRQType, 'CCSTMTTRNRQ') as IXMLCCSTMTTRNRQTypeList;
  FCCSTMTENDTRNRQ := CreateCollection(TXMLCCSTMTENDTRNRQTypeList, IXMLCCSTMTENDTRNRQType, 'CCSTMTENDTRNRQ') as IXMLCCSTMTENDTRNRQTypeList;
  inherited;
end;

function TXMLCREDITCARDMSGSRQV1Type.GetCCSTMTTRNRQ: IXMLCCSTMTTRNRQTypeList;
begin
  Result := FCCSTMTTRNRQ;
end;

function TXMLCREDITCARDMSGSRQV1Type.GetCCSTMTENDTRNRQ: IXMLCCSTMTENDTRNRQTypeList;
begin
  Result := FCCSTMTENDTRNRQ;
end;

{ TXMLCCSTMTTRNRQType }

procedure TXMLCCSTMTTRNRQType.AfterConstruction;
begin
  RegisterChildNode('CCSTMTRQ', TXMLCCSTMTRQType);
  inherited;
end;

function TXMLCCSTMTTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLCCSTMTTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLCCSTMTTRNRQType.GetCCSTMTRQ: IXMLCCSTMTRQType;
begin
  Result := ChildNodes['CCSTMTRQ'] as IXMLCCSTMTRQType;
end;

{ TXMLCCSTMTTRNRQTypeList }

function TXMLCCSTMTTRNRQTypeList.Add: IXMLCCSTMTTRNRQType;
begin
  Result := AddItem(-1) as IXMLCCSTMTTRNRQType;
end;

function TXMLCCSTMTTRNRQTypeList.Insert(const Index: Integer): IXMLCCSTMTTRNRQType;
begin
  Result := AddItem(Index) as IXMLCCSTMTTRNRQType;
end;

function TXMLCCSTMTTRNRQTypeList.GetItem(Index: Integer): IXMLCCSTMTTRNRQType;
begin
  Result := List[Index] as IXMLCCSTMTTRNRQType;
end;

{ TXMLCCSTMTRQType }

procedure TXMLCCSTMTRQType.AfterConstruction;
begin
  RegisterChildNode('INCTRAN', TXMLINCTRANType);
  inherited;
end;

function TXMLCCSTMTRQType.GetCCACCTFROM: UnicodeString;
begin
  Result := ChildNodes['CCACCTFROM'].Text;
end;

procedure TXMLCCSTMTRQType.SetCCACCTFROM(Value: UnicodeString);
begin
  ChildNodes['CCACCTFROM'].NodeValue := Value;
end;

function TXMLCCSTMTRQType.GetINCTRAN: IXMLINCTRANType;
begin
  Result := ChildNodes['INCTRAN'] as IXMLINCTRANType;
end;

{ TXMLCCSTMTENDTRNRQType }

procedure TXMLCCSTMTENDTRNRQType.AfterConstruction;
begin
  RegisterChildNode('CCSTMTENDRQ', TXMLCCSTMTENDRQType);
  inherited;
end;

function TXMLCCSTMTENDTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLCCSTMTENDTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLCCSTMTENDTRNRQType.GetCCSTMTENDRQ: IXMLCCSTMTENDRQType;
begin
  Result := ChildNodes['CCSTMTENDRQ'] as IXMLCCSTMTENDRQType;
end;

{ TXMLCCSTMTENDTRNRQTypeList }

function TXMLCCSTMTENDTRNRQTypeList.Add: IXMLCCSTMTENDTRNRQType;
begin
  Result := AddItem(-1) as IXMLCCSTMTENDTRNRQType;
end;

function TXMLCCSTMTENDTRNRQTypeList.Insert(const Index: Integer): IXMLCCSTMTENDTRNRQType;
begin
  Result := AddItem(Index) as IXMLCCSTMTENDTRNRQType;
end;

function TXMLCCSTMTENDTRNRQTypeList.GetItem(Index: Integer): IXMLCCSTMTENDTRNRQType;
begin
  Result := List[Index] as IXMLCCSTMTENDTRNRQType;
end;

{ TXMLCCSTMTENDRQType }

function TXMLCCSTMTENDRQType.GetCCACCTFROM: UnicodeString;
begin
  Result := ChildNodes['CCACCTFROM'].Text;
end;

procedure TXMLCCSTMTENDRQType.SetCCACCTFROM(Value: UnicodeString);
begin
  ChildNodes['CCACCTFROM'].NodeValue := Value;
end;

function TXMLCCSTMTENDRQType.GetDTSTART: UnicodeString;
begin
  Result := ChildNodes['DTSTART'].Text;
end;

procedure TXMLCCSTMTENDRQType.SetDTSTART(Value: UnicodeString);
begin
  ChildNodes['DTSTART'].NodeValue := Value;
end;

function TXMLCCSTMTENDRQType.GetDTEND: UnicodeString;
begin
  Result := ChildNodes['DTEND'].Text;
end;

procedure TXMLCCSTMTENDRQType.SetDTEND(Value: UnicodeString);
begin
  ChildNodes['DTEND'].NodeValue := Value;
end;

{ TXMLINTERXFERMSGSRQV1Type }

procedure TXMLINTERXFERMSGSRQV1Type.AfterConstruction;
begin
  RegisterChildNode('INTERTRNRQ', TXMLINTERTRNRQType);
  RegisterChildNode('RECINTERTRNRQ', TXMLRECINTERTRNRQType);
  RegisterChildNode('INTERSYNCRQ', TXMLINTERSYNCRQType);
  RegisterChildNode('RECINTERSYNCRQ', TXMLRECINTERSYNCRQType);
  FINTERTRNRQ := CreateCollection(TXMLINTERTRNRQTypeList, IXMLINTERTRNRQType, 'INTERTRNRQ') as IXMLINTERTRNRQTypeList;
  FRECINTERTRNRQ := CreateCollection(TXMLRECINTERTRNRQTypeList, IXMLRECINTERTRNRQType, 'RECINTERTRNRQ') as IXMLRECINTERTRNRQTypeList;
  FINTERSYNCRQ := CreateCollection(TXMLINTERSYNCRQTypeList, IXMLINTERSYNCRQType, 'INTERSYNCRQ') as IXMLINTERSYNCRQTypeList;
  FRECINTERSYNCRQ := CreateCollection(TXMLRECINTERSYNCRQTypeList, IXMLRECINTERSYNCRQType, 'RECINTERSYNCRQ') as IXMLRECINTERSYNCRQTypeList;
  inherited;
end;

function TXMLINTERXFERMSGSRQV1Type.GetINTERTRNRQ: IXMLINTERTRNRQTypeList;
begin
  Result := FINTERTRNRQ;
end;

function TXMLINTERXFERMSGSRQV1Type.GetRECINTERTRNRQ: IXMLRECINTERTRNRQTypeList;
begin
  Result := FRECINTERTRNRQ;
end;

function TXMLINTERXFERMSGSRQV1Type.GetINTERSYNCRQ: IXMLINTERSYNCRQTypeList;
begin
  Result := FINTERSYNCRQ;
end;

function TXMLINTERXFERMSGSRQV1Type.GetRECINTERSYNCRQ: IXMLRECINTERSYNCRQTypeList;
begin
  Result := FRECINTERSYNCRQ;
end;

{ TXMLINTERTRNRQType }

procedure TXMLINTERTRNRQType.AfterConstruction;
begin
  RegisterChildNode('INTERRQ', TXMLINTERRQType);
  RegisterChildNode('INTERMODRQ', TXMLINTERMODRQType);
  RegisterChildNode('INTERCANRQ', TXMLINTERCANRQType);
  inherited;
end;

function TXMLINTERTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLINTERTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLINTERTRNRQType.GetINTERRQ: IXMLINTERRQType;
begin
  Result := ChildNodes['INTERRQ'] as IXMLINTERRQType;
end;

function TXMLINTERTRNRQType.GetINTERMODRQ: IXMLINTERMODRQType;
begin
  Result := ChildNodes['INTERMODRQ'] as IXMLINTERMODRQType;
end;

function TXMLINTERTRNRQType.GetINTERCANRQ: IXMLINTERCANRQType;
begin
  Result := ChildNodes['INTERCANRQ'] as IXMLINTERCANRQType;
end;

{ TXMLINTERTRNRQTypeList }

function TXMLINTERTRNRQTypeList.Add: IXMLINTERTRNRQType;
begin
  Result := AddItem(-1) as IXMLINTERTRNRQType;
end;

function TXMLINTERTRNRQTypeList.Insert(const Index: Integer): IXMLINTERTRNRQType;
begin
  Result := AddItem(Index) as IXMLINTERTRNRQType;
end;

function TXMLINTERTRNRQTypeList.GetItem(Index: Integer): IXMLINTERTRNRQType;
begin
  Result := List[Index] as IXMLINTERTRNRQType;
end;

{ TXMLINTERRQType }

procedure TXMLINTERRQType.AfterConstruction;
begin
  RegisterChildNode('XFERINFO', TXMLXFERINFOType);
  inherited;
end;

function TXMLINTERRQType.GetXFERINFO: IXMLXFERINFOType;
begin
  Result := ChildNodes['XFERINFO'] as IXMLXFERINFOType;
end;

{ TXMLINTERMODRQType }

procedure TXMLINTERMODRQType.AfterConstruction;
begin
  RegisterChildNode('XFERINFO', TXMLXFERINFOType);
  inherited;
end;

function TXMLINTERMODRQType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLINTERMODRQType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

function TXMLINTERMODRQType.GetXFERINFO: IXMLXFERINFOType;
begin
  Result := ChildNodes['XFERINFO'] as IXMLXFERINFOType;
end;

{ TXMLINTERCANRQType }

function TXMLINTERCANRQType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLINTERCANRQType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

{ TXMLRECINTERTRNRQType }

procedure TXMLRECINTERTRNRQType.AfterConstruction;
begin
  RegisterChildNode('RECINTERRQ', TXMLRECINTERRQType);
  RegisterChildNode('RECINTERMODRQ', TXMLRECINTERMODRQType);
  RegisterChildNode('RECINTERCANRQ', TXMLRECINTERCANRQType);
  inherited;
end;

function TXMLRECINTERTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLRECINTERTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLRECINTERTRNRQType.GetRECINTERRQ: IXMLRECINTERRQType;
begin
  Result := ChildNodes['RECINTERRQ'] as IXMLRECINTERRQType;
end;

function TXMLRECINTERTRNRQType.GetRECINTERMODRQ: IXMLRECINTERMODRQType;
begin
  Result := ChildNodes['RECINTERMODRQ'] as IXMLRECINTERMODRQType;
end;

function TXMLRECINTERTRNRQType.GetRECINTERCANRQ: IXMLRECINTERCANRQType;
begin
  Result := ChildNodes['RECINTERCANRQ'] as IXMLRECINTERCANRQType;
end;

{ TXMLRECINTERTRNRQTypeList }

function TXMLRECINTERTRNRQTypeList.Add: IXMLRECINTERTRNRQType;
begin
  Result := AddItem(-1) as IXMLRECINTERTRNRQType;
end;

function TXMLRECINTERTRNRQTypeList.Insert(const Index: Integer): IXMLRECINTERTRNRQType;
begin
  Result := AddItem(Index) as IXMLRECINTERTRNRQType;
end;

function TXMLRECINTERTRNRQTypeList.GetItem(Index: Integer): IXMLRECINTERTRNRQType;
begin
  Result := List[Index] as IXMLRECINTERTRNRQType;
end;

{ TXMLRECINTERRQType }

procedure TXMLRECINTERRQType.AfterConstruction;
begin
  RegisterChildNode('RECURRINST', TXMLRECURRINSTType);
  RegisterChildNode('INTERRQ', TXMLINTERRQType);
  inherited;
end;

function TXMLRECINTERRQType.GetRECURRINST: IXMLRECURRINSTType;
begin
  Result := ChildNodes['RECURRINST'] as IXMLRECURRINSTType;
end;

function TXMLRECINTERRQType.GetINTERRQ: IXMLINTERRQType;
begin
  Result := ChildNodes['INTERRQ'] as IXMLINTERRQType;
end;

{ TXMLRECINTERMODRQType }

procedure TXMLRECINTERMODRQType.AfterConstruction;
begin
  RegisterChildNode('RECURRINST', TXMLRECURRINSTType);
  RegisterChildNode('INTERRQ', TXMLINTERRQType);
  inherited;
end;

function TXMLRECINTERMODRQType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLRECINTERMODRQType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

function TXMLRECINTERMODRQType.GetRECURRINST: IXMLRECURRINSTType;
begin
  Result := ChildNodes['RECURRINST'] as IXMLRECURRINSTType;
end;

function TXMLRECINTERMODRQType.GetINTERRQ: IXMLINTERRQType;
begin
  Result := ChildNodes['INTERRQ'] as IXMLINTERRQType;
end;

function TXMLRECINTERMODRQType.GetMODPENDING: UnicodeString;
begin
  Result := ChildNodes['MODPENDING'].Text;
end;

procedure TXMLRECINTERMODRQType.SetMODPENDING(Value: UnicodeString);
begin
  ChildNodes['MODPENDING'].NodeValue := Value;
end;

{ TXMLRECINTERCANRQType }

function TXMLRECINTERCANRQType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLRECINTERCANRQType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

function TXMLRECINTERCANRQType.GetCANPENDING: UnicodeString;
begin
  Result := ChildNodes['CANPENDING'].Text;
end;

procedure TXMLRECINTERCANRQType.SetCANPENDING(Value: UnicodeString);
begin
  ChildNodes['CANPENDING'].NodeValue := Value;
end;

{ TXMLINTERSYNCRQType }

procedure TXMLINTERSYNCRQType.AfterConstruction;
begin
  RegisterChildNode('INTERTRNRQ', TXMLINTERTRNRQType);
  FINTERTRNRQ := CreateCollection(TXMLINTERTRNRQTypeList, IXMLINTERTRNRQType, 'INTERTRNRQ') as IXMLINTERTRNRQTypeList;
  inherited;
end;

function TXMLINTERSYNCRQType.GetSYNCRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRQMACRO'].Text;
end;

procedure TXMLINTERSYNCRQType.SetSYNCRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRQMACRO'].NodeValue := Value;
end;

function TXMLINTERSYNCRQType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLINTERSYNCRQType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLINTERSYNCRQType.GetINTERTRNRQ: IXMLINTERTRNRQTypeList;
begin
  Result := FINTERTRNRQ;
end;

{ TXMLINTERSYNCRQTypeList }

function TXMLINTERSYNCRQTypeList.Add: IXMLINTERSYNCRQType;
begin
  Result := AddItem(-1) as IXMLINTERSYNCRQType;
end;

function TXMLINTERSYNCRQTypeList.Insert(const Index: Integer): IXMLINTERSYNCRQType;
begin
  Result := AddItem(Index) as IXMLINTERSYNCRQType;
end;

function TXMLINTERSYNCRQTypeList.GetItem(Index: Integer): IXMLINTERSYNCRQType;
begin
  Result := List[Index] as IXMLINTERSYNCRQType;
end;

{ TXMLRECINTERSYNCRQType }

procedure TXMLRECINTERSYNCRQType.AfterConstruction;
begin
  RegisterChildNode('RECINTERTRNRQ', TXMLRECINTERTRNRQType);
  FRECINTERTRNRQ := CreateCollection(TXMLRECINTERTRNRQTypeList, IXMLRECINTERTRNRQType, 'RECINTERTRNRQ') as IXMLRECINTERTRNRQTypeList;
  inherited;
end;

function TXMLRECINTERSYNCRQType.GetSYNCRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRQMACRO'].Text;
end;

procedure TXMLRECINTERSYNCRQType.SetSYNCRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRQMACRO'].NodeValue := Value;
end;

function TXMLRECINTERSYNCRQType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLRECINTERSYNCRQType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLRECINTERSYNCRQType.GetRECINTERTRNRQ: IXMLRECINTERTRNRQTypeList;
begin
  Result := FRECINTERTRNRQ;
end;

{ TXMLRECINTERSYNCRQTypeList }

function TXMLRECINTERSYNCRQTypeList.Add: IXMLRECINTERSYNCRQType;
begin
  Result := AddItem(-1) as IXMLRECINTERSYNCRQType;
end;

function TXMLRECINTERSYNCRQTypeList.Insert(const Index: Integer): IXMLRECINTERSYNCRQType;
begin
  Result := AddItem(Index) as IXMLRECINTERSYNCRQType;
end;

function TXMLRECINTERSYNCRQTypeList.GetItem(Index: Integer): IXMLRECINTERSYNCRQType;
begin
  Result := List[Index] as IXMLRECINTERSYNCRQType;
end;

{ TXMLWIREXFERMSGSRQV1Type }

procedure TXMLWIREXFERMSGSRQV1Type.AfterConstruction;
begin
  RegisterChildNode('WIRETRNRQ', TXMLWIRETRNRQType);
  RegisterChildNode('WIRESYNCRQ', TXMLWIRESYNCRQType);
  FWIRETRNRQ := CreateCollection(TXMLWIRETRNRQTypeList, IXMLWIRETRNRQType, 'WIRETRNRQ') as IXMLWIRETRNRQTypeList;
  FWIRESYNCRQ := CreateCollection(TXMLWIRESYNCRQTypeList, IXMLWIRESYNCRQType, 'WIRESYNCRQ') as IXMLWIRESYNCRQTypeList;
  inherited;
end;

function TXMLWIREXFERMSGSRQV1Type.GetWIRETRNRQ: IXMLWIRETRNRQTypeList;
begin
  Result := FWIRETRNRQ;
end;

function TXMLWIREXFERMSGSRQV1Type.GetWIRESYNCRQ: IXMLWIRESYNCRQTypeList;
begin
  Result := FWIRESYNCRQ;
end;

{ TXMLWIRETRNRQType }

procedure TXMLWIRETRNRQType.AfterConstruction;
begin
  RegisterChildNode('WIRERQ', TXMLWIRERQType);
  RegisterChildNode('WIRECANRQ', TXMLWIRECANRQType);
  inherited;
end;

function TXMLWIRETRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLWIRETRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLWIRETRNRQType.GetWIRERQ: IXMLWIRERQType;
begin
  Result := ChildNodes['WIRERQ'] as IXMLWIRERQType;
end;

function TXMLWIRETRNRQType.GetWIRECANRQ: IXMLWIRECANRQType;
begin
  Result := ChildNodes['WIRECANRQ'] as IXMLWIRECANRQType;
end;

{ TXMLWIRETRNRQTypeList }

function TXMLWIRETRNRQTypeList.Add: IXMLWIRETRNRQType;
begin
  Result := AddItem(-1) as IXMLWIRETRNRQType;
end;

function TXMLWIRETRNRQTypeList.Insert(const Index: Integer): IXMLWIRETRNRQType;
begin
  Result := AddItem(Index) as IXMLWIRETRNRQType;
end;

function TXMLWIRETRNRQTypeList.GetItem(Index: Integer): IXMLWIRETRNRQType;
begin
  Result := List[Index] as IXMLWIRETRNRQType;
end;

{ TXMLWIRERQType }

procedure TXMLWIRERQType.AfterConstruction;
begin
  RegisterChildNode('WIREBENEFICIARY', TXMLWIREBENEFICIARYType);
  RegisterChildNode('WIREDESTBANK', TXMLWIREDESTBANKType);
  inherited;
end;

function TXMLWIRERQType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLWIRERQType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLWIRERQType.GetWIREBENEFICIARY: IXMLWIREBENEFICIARYType;
begin
  Result := ChildNodes['WIREBENEFICIARY'] as IXMLWIREBENEFICIARYType;
end;

function TXMLWIRERQType.GetWIREDESTBANK: IXMLWIREDESTBANKType;
begin
  Result := ChildNodes['WIREDESTBANK'] as IXMLWIREDESTBANKType;
end;

function TXMLWIRERQType.GetTRNAMT: UnicodeString;
begin
  Result := ChildNodes['TRNAMT'].Text;
end;

procedure TXMLWIRERQType.SetTRNAMT(Value: UnicodeString);
begin
  ChildNodes['TRNAMT'].NodeValue := Value;
end;

function TXMLWIRERQType.GetDTDUE: UnicodeString;
begin
  Result := ChildNodes['DTDUE'].Text;
end;

procedure TXMLWIRERQType.SetDTDUE(Value: UnicodeString);
begin
  ChildNodes['DTDUE'].NodeValue := Value;
end;

function TXMLWIRERQType.GetPAYINSTRUCT: UnicodeString;
begin
  Result := ChildNodes['PAYINSTRUCT'].Text;
end;

procedure TXMLWIRERQType.SetPAYINSTRUCT(Value: UnicodeString);
begin
  ChildNodes['PAYINSTRUCT'].NodeValue := Value;
end;

{ TXMLWIREBENEFICIARYType }

function TXMLWIREBENEFICIARYType.GetNAME: UnicodeString;
begin
  Result := ChildNodes['NAME'].Text;
end;

procedure TXMLWIREBENEFICIARYType.SetNAME(Value: UnicodeString);
begin
  ChildNodes['NAME'].NodeValue := Value;
end;

function TXMLWIREBENEFICIARYType.GetBANKACCTTO: UnicodeString;
begin
  Result := ChildNodes['BANKACCTTO'].Text;
end;

procedure TXMLWIREBENEFICIARYType.SetBANKACCTTO(Value: UnicodeString);
begin
  ChildNodes['BANKACCTTO'].NodeValue := Value;
end;

function TXMLWIREBENEFICIARYType.GetMEMO: UnicodeString;
begin
  Result := ChildNodes['MEMO'].Text;
end;

procedure TXMLWIREBENEFICIARYType.SetMEMO(Value: UnicodeString);
begin
  ChildNodes['MEMO'].NodeValue := Value;
end;

{ TXMLWIREDESTBANKType }

procedure TXMLWIREDESTBANKType.AfterConstruction;
begin
  RegisterChildNode('EXTBANKDESC', TXMLEXTBANKDESCType);
  inherited;
end;

function TXMLWIREDESTBANKType.GetEXTBANKDESC: IXMLEXTBANKDESCType;
begin
  Result := ChildNodes['EXTBANKDESC'] as IXMLEXTBANKDESCType;
end;

{ TXMLEXTBANKDESCType }

function TXMLEXTBANKDESCType.GetNAME: UnicodeString;
begin
  Result := ChildNodes['NAME'].Text;
end;

procedure TXMLEXTBANKDESCType.SetNAME(Value: UnicodeString);
begin
  ChildNodes['NAME'].NodeValue := Value;
end;

function TXMLEXTBANKDESCType.GetBANKID: UnicodeString;
begin
  Result := ChildNodes['BANKID'].Text;
end;

procedure TXMLEXTBANKDESCType.SetBANKID(Value: UnicodeString);
begin
  ChildNodes['BANKID'].NodeValue := Value;
end;

function TXMLEXTBANKDESCType.GetADDR1: UnicodeString;
begin
  Result := ChildNodes['ADDR1'].Text;
end;

procedure TXMLEXTBANKDESCType.SetADDR1(Value: UnicodeString);
begin
  ChildNodes['ADDR1'].NodeValue := Value;
end;

function TXMLEXTBANKDESCType.GetADDR2: UnicodeString;
begin
  Result := ChildNodes['ADDR2'].Text;
end;

procedure TXMLEXTBANKDESCType.SetADDR2(Value: UnicodeString);
begin
  ChildNodes['ADDR2'].NodeValue := Value;
end;

function TXMLEXTBANKDESCType.GetADDR3: UnicodeString;
begin
  Result := ChildNodes['ADDR3'].Text;
end;

procedure TXMLEXTBANKDESCType.SetADDR3(Value: UnicodeString);
begin
  ChildNodes['ADDR3'].NodeValue := Value;
end;

function TXMLEXTBANKDESCType.GetCITY: UnicodeString;
begin
  Result := ChildNodes['CITY'].Text;
end;

procedure TXMLEXTBANKDESCType.SetCITY(Value: UnicodeString);
begin
  ChildNodes['CITY'].NodeValue := Value;
end;

function TXMLEXTBANKDESCType.GetSTATE: UnicodeString;
begin
  Result := ChildNodes['STATE'].Text;
end;

procedure TXMLEXTBANKDESCType.SetSTATE(Value: UnicodeString);
begin
  ChildNodes['STATE'].NodeValue := Value;
end;

function TXMLEXTBANKDESCType.GetPOSTALCODE: UnicodeString;
begin
  Result := ChildNodes['POSTALCODE'].Text;
end;

procedure TXMLEXTBANKDESCType.SetPOSTALCODE(Value: UnicodeString);
begin
  ChildNodes['POSTALCODE'].NodeValue := Value;
end;

function TXMLEXTBANKDESCType.GetCOUNTRY: UnicodeString;
begin
  Result := ChildNodes['COUNTRY'].Text;
end;

procedure TXMLEXTBANKDESCType.SetCOUNTRY(Value: UnicodeString);
begin
  ChildNodes['COUNTRY'].NodeValue := Value;
end;

function TXMLEXTBANKDESCType.GetPHONE: UnicodeString;
begin
  Result := ChildNodes['PHONE'].Text;
end;

procedure TXMLEXTBANKDESCType.SetPHONE(Value: UnicodeString);
begin
  ChildNodes['PHONE'].NodeValue := Value;
end;

{ TXMLWIRECANRQType }

function TXMLWIRECANRQType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLWIRECANRQType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

{ TXMLWIRESYNCRQType }

procedure TXMLWIRESYNCRQType.AfterConstruction;
begin
  RegisterChildNode('WIRETRNRQ', TXMLWIRETRNRQType);
  FWIRETRNRQ := CreateCollection(TXMLWIRETRNRQTypeList, IXMLWIRETRNRQType, 'WIRETRNRQ') as IXMLWIRETRNRQTypeList;
  inherited;
end;

function TXMLWIRESYNCRQType.GetSYNCRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRQMACRO'].Text;
end;

procedure TXMLWIRESYNCRQType.SetSYNCRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRQMACRO'].NodeValue := Value;
end;

function TXMLWIRESYNCRQType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLWIRESYNCRQType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLWIRESYNCRQType.GetWIRETRNRQ: IXMLWIRETRNRQTypeList;
begin
  Result := FWIRETRNRQ;
end;

{ TXMLWIRESYNCRQTypeList }

function TXMLWIRESYNCRQTypeList.Add: IXMLWIRESYNCRQType;
begin
  Result := AddItem(-1) as IXMLWIRESYNCRQType;
end;

function TXMLWIRESYNCRQTypeList.Insert(const Index: Integer): IXMLWIRESYNCRQType;
begin
  Result := AddItem(Index) as IXMLWIRESYNCRQType;
end;

function TXMLWIRESYNCRQTypeList.GetItem(Index: Integer): IXMLWIRESYNCRQType;
begin
  Result := List[Index] as IXMLWIRESYNCRQType;
end;

{ TXMLBANKMSGSRSV1Type }

procedure TXMLBANKMSGSRSV1Type.AfterConstruction;
begin
  RegisterChildNode('STMTTRNRS', TXMLSTMTTRNRSType);
  RegisterChildNode('STMTENDTRNRS', TXMLSTMTENDTRNRSType);
  RegisterChildNode('INTRATRNRS', TXMLINTRATRNRSType);
  RegisterChildNode('RECINTRATRNRS', TXMLRECINTRATRNRSType);
  RegisterChildNode('STPCHKTRNRS', TXMLSTPCHKTRNRSType);
  RegisterChildNode('BANKMAILTRNRS', TXMLBANKMAILTRNRSType);
  RegisterChildNode('BANKMAILSYNCRS', TXMLBANKMAILSYNCRSType);
  RegisterChildNode('STPCHKSYNCRS', TXMLSTPCHKSYNCRSType);
  RegisterChildNode('INTRASYNCRS', TXMLINTRASYNCRSType);
  RegisterChildNode('RECINTRASYNCRS', TXMLRECINTRASYNCRSType);
  FSTMTTRNRS := CreateCollection(TXMLSTMTTRNRSTypeList, IXMLSTMTTRNRSType, 'STMTTRNRS') as IXMLSTMTTRNRSTypeList;
  FSTMTENDTRNRS := CreateCollection(TXMLSTMTENDTRNRSTypeList, IXMLSTMTENDTRNRSType, 'STMTENDTRNRS') as IXMLSTMTENDTRNRSTypeList;
  FINTRATRNRS := CreateCollection(TXMLINTRATRNRSTypeList, IXMLINTRATRNRSType, 'INTRATRNRS') as IXMLINTRATRNRSTypeList;
  FRECINTRATRNRS := CreateCollection(TXMLRECINTRATRNRSTypeList, IXMLRECINTRATRNRSType, 'RECINTRATRNRS') as IXMLRECINTRATRNRSTypeList;
  FSTPCHKTRNRS := CreateCollection(TXMLSTPCHKTRNRSTypeList, IXMLSTPCHKTRNRSType, 'STPCHKTRNRS') as IXMLSTPCHKTRNRSTypeList;
  FBANKMAILTRNRS := CreateCollection(TXMLBANKMAILTRNRSTypeList, IXMLBANKMAILTRNRSType, 'BANKMAILTRNRS') as IXMLBANKMAILTRNRSTypeList;
  FBANKMAILSYNCRS := CreateCollection(TXMLBANKMAILSYNCRSTypeList, IXMLBANKMAILSYNCRSType, 'BANKMAILSYNCRS') as IXMLBANKMAILSYNCRSTypeList;
  FSTPCHKSYNCRS := CreateCollection(TXMLSTPCHKSYNCRSTypeList, IXMLSTPCHKSYNCRSType, 'STPCHKSYNCRS') as IXMLSTPCHKSYNCRSTypeList;
  FINTRASYNCRS := CreateCollection(TXMLINTRASYNCRSTypeList, IXMLINTRASYNCRSType, 'INTRASYNCRS') as IXMLINTRASYNCRSTypeList;
  FRECINTRASYNCRS := CreateCollection(TXMLRECINTRASYNCRSTypeList, IXMLRECINTRASYNCRSType, 'RECINTRASYNCRS') as IXMLRECINTRASYNCRSTypeList;
  inherited;
end;

function TXMLBANKMSGSRSV1Type.GetSTMTTRNRS: IXMLSTMTTRNRSTypeList;
begin
  Result := FSTMTTRNRS;
end;

function TXMLBANKMSGSRSV1Type.GetSTMTENDTRNRS: IXMLSTMTENDTRNRSTypeList;
begin
  Result := FSTMTENDTRNRS;
end;

function TXMLBANKMSGSRSV1Type.GetINTRATRNRS: IXMLINTRATRNRSTypeList;
begin
  Result := FINTRATRNRS;
end;

function TXMLBANKMSGSRSV1Type.GetRECINTRATRNRS: IXMLRECINTRATRNRSTypeList;
begin
  Result := FRECINTRATRNRS;
end;

function TXMLBANKMSGSRSV1Type.GetSTPCHKTRNRS: IXMLSTPCHKTRNRSTypeList;
begin
  Result := FSTPCHKTRNRS;
end;

function TXMLBANKMSGSRSV1Type.GetBANKMAILTRNRS: IXMLBANKMAILTRNRSTypeList;
begin
  Result := FBANKMAILTRNRS;
end;

function TXMLBANKMSGSRSV1Type.GetBANKMAILSYNCRS: IXMLBANKMAILSYNCRSTypeList;
begin
  Result := FBANKMAILSYNCRS;
end;

function TXMLBANKMSGSRSV1Type.GetSTPCHKSYNCRS: IXMLSTPCHKSYNCRSTypeList;
begin
  Result := FSTPCHKSYNCRS;
end;

function TXMLBANKMSGSRSV1Type.GetINTRASYNCRS: IXMLINTRASYNCRSTypeList;
begin
  Result := FINTRASYNCRS;
end;

function TXMLBANKMSGSRSV1Type.GetRECINTRASYNCRS: IXMLRECINTRASYNCRSTypeList;
begin
  Result := FRECINTRASYNCRS;
end;

{ TXMLSTMTTRNRSType }

procedure TXMLSTMTTRNRSType.AfterConstruction;
begin
  RegisterChildNode('STMTRS', TXMLSTMTRSType);
  inherited;
end;

function TXMLSTMTTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLSTMTTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLSTMTTRNRSType.GetSTMTRS: IXMLSTMTRSType;
begin
  Result := ChildNodes['STMTRS'] as IXMLSTMTRSType;
end;

{ TXMLSTMTTRNRSTypeList }

function TXMLSTMTTRNRSTypeList.Add: IXMLSTMTTRNRSType;
begin
  Result := AddItem(-1) as IXMLSTMTTRNRSType;
end;

function TXMLSTMTTRNRSTypeList.Insert(const Index: Integer): IXMLSTMTTRNRSType;
begin
  Result := AddItem(Index) as IXMLSTMTTRNRSType;
end;

function TXMLSTMTTRNRSTypeList.GetItem(Index: Integer): IXMLSTMTTRNRSType;
begin
  Result := List[Index] as IXMLSTMTTRNRSType;
end;

{ TXMLSTMTRSType }

procedure TXMLSTMTRSType.AfterConstruction;
begin
  RegisterChildNode('BANKTRANLIST', TXMLBANKTRANLISTType);
  RegisterChildNode('LEDGERBAL', TXMLLEDGERBALType);
  RegisterChildNode('AVAILBAL', TXMLAVAILBALType);
  inherited;
end;

function TXMLSTMTRSType.GetCURDEF: UnicodeString;
begin
  Result := ChildNodes['CURDEF'].Text;
end;

procedure TXMLSTMTRSType.SetCURDEF(Value: UnicodeString);
begin
  ChildNodes['CURDEF'].NodeValue := Value;
end;

function TXMLSTMTRSType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLSTMTRSType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLSTMTRSType.GetBANKTRANLIST: IXMLBANKTRANLISTType;
begin
  Result := ChildNodes['BANKTRANLIST'] as IXMLBANKTRANLISTType;
end;

function TXMLSTMTRSType.GetLEDGERBAL: IXMLLEDGERBALType;
begin
  Result := ChildNodes['LEDGERBAL'] as IXMLLEDGERBALType;
end;

function TXMLSTMTRSType.GetAVAILBAL: IXMLAVAILBALType;
begin
  Result := ChildNodes['AVAILBAL'] as IXMLAVAILBALType;
end;

function TXMLSTMTRSType.GetMKTGINFO: UnicodeString;
begin
  Result := ChildNodes['MKTGINFO'].Text;
end;

procedure TXMLSTMTRSType.SetMKTGINFO(Value: UnicodeString);
begin
  ChildNodes['MKTGINFO'].NodeValue := Value;
end;

{ TXMLBANKTRANLISTType }

procedure TXMLBANKTRANLISTType.AfterConstruction;
begin
  RegisterChildNode('STMTTRN', TXMLSTMTTRNType);
  FSTMTTRN := CreateCollection(TXMLSTMTTRNTypeList, IXMLSTMTTRNType, 'STMTTRN') as IXMLSTMTTRNTypeList;
  inherited;
end;

function TXMLBANKTRANLISTType.GetDTSTART: UnicodeString;
begin
  Result := ChildNodes['DTSTART'].Text;
end;

procedure TXMLBANKTRANLISTType.SetDTSTART(Value: UnicodeString);
begin
  ChildNodes['DTSTART'].NodeValue := Value;
end;

function TXMLBANKTRANLISTType.GetDTEND: UnicodeString;
begin
  Result := ChildNodes['DTEND'].Text;
end;

procedure TXMLBANKTRANLISTType.SetDTEND(Value: UnicodeString);
begin
  ChildNodes['DTEND'].NodeValue := Value;
end;

function TXMLBANKTRANLISTType.GetSTMTTRN: IXMLSTMTTRNTypeList;
begin
  Result := FSTMTTRN;
end;

{ TXMLSTMTTRNType }

procedure TXMLSTMTTRNType.AfterConstruction;
begin
  RegisterChildNode('PAYEE', TXMLPAYEEType);
  inherited;
end;

function TXMLSTMTTRNType.GetTRNTYPE: UnicodeString;
begin
  Result := ChildNodes['TRNTYPE'].Text;
end;

procedure TXMLSTMTTRNType.SetTRNTYPE(Value: UnicodeString);
begin
  ChildNodes['TRNTYPE'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetDTPOSTED: UnicodeString;
begin
  Result := ChildNodes['DTPOSTED'].Text;
end;

procedure TXMLSTMTTRNType.SetDTPOSTED(Value: UnicodeString);
begin
  ChildNodes['DTPOSTED'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetDTUSER: UnicodeString;
begin
  Result := ChildNodes['DTUSER'].Text;
end;

procedure TXMLSTMTTRNType.SetDTUSER(Value: UnicodeString);
begin
  ChildNodes['DTUSER'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetDTAVAIL: UnicodeString;
begin
  Result := ChildNodes['DTAVAIL'].Text;
end;

procedure TXMLSTMTTRNType.SetDTAVAIL(Value: UnicodeString);
begin
  ChildNodes['DTAVAIL'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetTRNAMT: UnicodeString;
begin
  Result := ChildNodes['TRNAMT'].Text;
end;

procedure TXMLSTMTTRNType.SetTRNAMT(Value: UnicodeString);
begin
  ChildNodes['TRNAMT'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetFITID: UnicodeString;
begin
  Result := ChildNodes['FITID'].Text;
end;

procedure TXMLSTMTTRNType.SetFITID(Value: UnicodeString);
begin
  ChildNodes['FITID'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetCORRECTFITID: UnicodeString;
begin
  Result := ChildNodes['CORRECTFITID'].Text;
end;

procedure TXMLSTMTTRNType.SetCORRECTFITID(Value: UnicodeString);
begin
  ChildNodes['CORRECTFITID'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetCORRECTACTION: UnicodeString;
begin
  Result := ChildNodes['CORRECTACTION'].Text;
end;

procedure TXMLSTMTTRNType.SetCORRECTACTION(Value: UnicodeString);
begin
  ChildNodes['CORRECTACTION'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLSTMTTRNType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetCHECKNUM: UnicodeString;
begin
  Result := ChildNodes['CHECKNUM'].Text;
end;

procedure TXMLSTMTTRNType.SetCHECKNUM(Value: UnicodeString);
begin
  ChildNodes['CHECKNUM'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetREFNUM: UnicodeString;
begin
  Result := ChildNodes['REFNUM'].Text;
end;

procedure TXMLSTMTTRNType.SetREFNUM(Value: UnicodeString);
begin
  ChildNodes['REFNUM'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetSIC: UnicodeString;
begin
  Result := ChildNodes['SIC'].Text;
end;

procedure TXMLSTMTTRNType.SetSIC(Value: UnicodeString);
begin
  ChildNodes['SIC'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetPAYEEID: UnicodeString;
begin
  Result := ChildNodes['PAYEEID'].Text;
end;

procedure TXMLSTMTTRNType.SetPAYEEID(Value: UnicodeString);
begin
  ChildNodes['PAYEEID'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetNAME: UnicodeString;
begin
  Result := ChildNodes['NAME'].Text;
end;

procedure TXMLSTMTTRNType.SetNAME(Value: UnicodeString);
begin
  ChildNodes['NAME'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetPAYEE: IXMLPAYEEType;
begin
  Result := ChildNodes['PAYEE'] as IXMLPAYEEType;
end;

function TXMLSTMTTRNType.GetBANKACCTTO: UnicodeString;
begin
  Result := ChildNodes['BANKACCTTO'].Text;
end;

procedure TXMLSTMTTRNType.SetBANKACCTTO(Value: UnicodeString);
begin
  ChildNodes['BANKACCTTO'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetCCACCTTO: UnicodeString;
begin
  Result := ChildNodes['CCACCTTO'].Text;
end;

procedure TXMLSTMTTRNType.SetCCACCTTO(Value: UnicodeString);
begin
  ChildNodes['CCACCTTO'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetMEMO: UnicodeString;
begin
  Result := ChildNodes['MEMO'].Text;
end;

procedure TXMLSTMTTRNType.SetMEMO(Value: UnicodeString);
begin
  ChildNodes['MEMO'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetCURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLSTMTTRNType.SetCURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLSTMTTRNType.GetORIGCURRENCY: UnicodeString;
begin
  Result := ChildNodes['ORIGCURRENCY'].Text;
end;

procedure TXMLSTMTTRNType.SetORIGCURRENCY(Value: UnicodeString);
begin
  ChildNodes['ORIGCURRENCY'].NodeValue := Value;
end;

{ TXMLSTMTTRNTypeList }

function TXMLSTMTTRNTypeList.Add: IXMLSTMTTRNType;
begin
  Result := AddItem(-1) as IXMLSTMTTRNType;
end;

function TXMLSTMTTRNTypeList.Insert(const Index: Integer): IXMLSTMTTRNType;
begin
  Result := AddItem(Index) as IXMLSTMTTRNType;
end;

function TXMLSTMTTRNTypeList.GetItem(Index: Integer): IXMLSTMTTRNType;
begin
  Result := List[Index] as IXMLSTMTTRNType;
end;

{ TXMLPAYEEType }

function TXMLPAYEEType.GetNAME: UnicodeString;
begin
  Result := ChildNodes['NAME'].Text;
end;

procedure TXMLPAYEEType.SetNAME(Value: UnicodeString);
begin
  ChildNodes['NAME'].NodeValue := Value;
end;

function TXMLPAYEEType.GetADDR1: UnicodeString;
begin
  Result := ChildNodes['ADDR1'].Text;
end;

procedure TXMLPAYEEType.SetADDR1(Value: UnicodeString);
begin
  ChildNodes['ADDR1'].NodeValue := Value;
end;

function TXMLPAYEEType.GetADDR2: UnicodeString;
begin
  Result := ChildNodes['ADDR2'].Text;
end;

procedure TXMLPAYEEType.SetADDR2(Value: UnicodeString);
begin
  ChildNodes['ADDR2'].NodeValue := Value;
end;

function TXMLPAYEEType.GetADDR3: UnicodeString;
begin
  Result := ChildNodes['ADDR3'].Text;
end;

procedure TXMLPAYEEType.SetADDR3(Value: UnicodeString);
begin
  ChildNodes['ADDR3'].NodeValue := Value;
end;

function TXMLPAYEEType.GetCITY: UnicodeString;
begin
  Result := ChildNodes['CITY'].Text;
end;

procedure TXMLPAYEEType.SetCITY(Value: UnicodeString);
begin
  ChildNodes['CITY'].NodeValue := Value;
end;

function TXMLPAYEEType.GetSTATE: UnicodeString;
begin
  Result := ChildNodes['STATE'].Text;
end;

procedure TXMLPAYEEType.SetSTATE(Value: UnicodeString);
begin
  ChildNodes['STATE'].NodeValue := Value;
end;

function TXMLPAYEEType.GetPOSTALCODE: UnicodeString;
begin
  Result := ChildNodes['POSTALCODE'].Text;
end;

procedure TXMLPAYEEType.SetPOSTALCODE(Value: UnicodeString);
begin
  ChildNodes['POSTALCODE'].NodeValue := Value;
end;

function TXMLPAYEEType.GetCOUNTRY: UnicodeString;
begin
  Result := ChildNodes['COUNTRY'].Text;
end;

procedure TXMLPAYEEType.SetCOUNTRY(Value: UnicodeString);
begin
  ChildNodes['COUNTRY'].NodeValue := Value;
end;

function TXMLPAYEEType.GetPHONE: UnicodeString;
begin
  Result := ChildNodes['PHONE'].Text;
end;

procedure TXMLPAYEEType.SetPHONE(Value: UnicodeString);
begin
  ChildNodes['PHONE'].NodeValue := Value;
end;

{ TXMLLEDGERBALType }

function TXMLLEDGERBALType.GetBALAMT: UnicodeString;
begin
  Result := ChildNodes['BALAMT'].Text;
end;

procedure TXMLLEDGERBALType.SetBALAMT(Value: UnicodeString);
begin
  ChildNodes['BALAMT'].NodeValue := Value;
end;

function TXMLLEDGERBALType.GetDTASOF: UnicodeString;
begin
  Result := ChildNodes['DTASOF'].Text;
end;

procedure TXMLLEDGERBALType.SetDTASOF(Value: UnicodeString);
begin
  ChildNodes['DTASOF'].NodeValue := Value;
end;

{ TXMLAVAILBALType }

function TXMLAVAILBALType.GetBALAMT: UnicodeString;
begin
  Result := ChildNodes['BALAMT'].Text;
end;

procedure TXMLAVAILBALType.SetBALAMT(Value: UnicodeString);
begin
  ChildNodes['BALAMT'].NodeValue := Value;
end;

function TXMLAVAILBALType.GetDTASOF: UnicodeString;
begin
  Result := ChildNodes['DTASOF'].Text;
end;

procedure TXMLAVAILBALType.SetDTASOF(Value: UnicodeString);
begin
  ChildNodes['DTASOF'].NodeValue := Value;
end;

{ TXMLSTMTENDTRNRSType }

procedure TXMLSTMTENDTRNRSType.AfterConstruction;
begin
  RegisterChildNode('STMTENDRS', TXMLSTMTENDRSType);
  inherited;
end;

function TXMLSTMTENDTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLSTMTENDTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLSTMTENDTRNRSType.GetSTMTENDRS: IXMLSTMTENDRSType;
begin
  Result := ChildNodes['STMTENDRS'] as IXMLSTMTENDRSType;
end;

{ TXMLSTMTENDTRNRSTypeList }

function TXMLSTMTENDTRNRSTypeList.Add: IXMLSTMTENDTRNRSType;
begin
  Result := AddItem(-1) as IXMLSTMTENDTRNRSType;
end;

function TXMLSTMTENDTRNRSTypeList.Insert(const Index: Integer): IXMLSTMTENDTRNRSType;
begin
  Result := AddItem(Index) as IXMLSTMTENDTRNRSType;
end;

function TXMLSTMTENDTRNRSTypeList.GetItem(Index: Integer): IXMLSTMTENDTRNRSType;
begin
  Result := List[Index] as IXMLSTMTENDTRNRSType;
end;

{ TXMLSTMTENDRSType }

procedure TXMLSTMTENDRSType.AfterConstruction;
begin
  RegisterChildNode('CLOSING', TXMLCLOSINGType);
  FCLOSING := CreateCollection(TXMLCLOSINGTypeList, IXMLCLOSINGType, 'CLOSING') as IXMLCLOSINGTypeList;
  inherited;
end;

function TXMLSTMTENDRSType.GetCURDEF: UnicodeString;
begin
  Result := ChildNodes['CURDEF'].Text;
end;

procedure TXMLSTMTENDRSType.SetCURDEF(Value: UnicodeString);
begin
  ChildNodes['CURDEF'].NodeValue := Value;
end;

function TXMLSTMTENDRSType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLSTMTENDRSType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLSTMTENDRSType.GetCLOSING: IXMLCLOSINGTypeList;
begin
  Result := FCLOSING;
end;

{ TXMLCLOSINGType }

function TXMLCLOSINGType.GetFITID: UnicodeString;
begin
  Result := ChildNodes['FITID'].Text;
end;

procedure TXMLCLOSINGType.SetFITID(Value: UnicodeString);
begin
  ChildNodes['FITID'].NodeValue := Value;
end;

function TXMLCLOSINGType.GetDTOPEN: UnicodeString;
begin
  Result := ChildNodes['DTOPEN'].Text;
end;

procedure TXMLCLOSINGType.SetDTOPEN(Value: UnicodeString);
begin
  ChildNodes['DTOPEN'].NodeValue := Value;
end;

function TXMLCLOSINGType.GetDTCLOSE: UnicodeString;
begin
  Result := ChildNodes['DTCLOSE'].Text;
end;

procedure TXMLCLOSINGType.SetDTCLOSE(Value: UnicodeString);
begin
  ChildNodes['DTCLOSE'].NodeValue := Value;
end;

function TXMLCLOSINGType.GetDTNEXT: UnicodeString;
begin
  Result := ChildNodes['DTNEXT'].Text;
end;

procedure TXMLCLOSINGType.SetDTNEXT(Value: UnicodeString);
begin
  ChildNodes['DTNEXT'].NodeValue := Value;
end;

function TXMLCLOSINGType.GetBALOPEN: UnicodeString;
begin
  Result := ChildNodes['BALOPEN'].Text;
end;

procedure TXMLCLOSINGType.SetBALOPEN(Value: UnicodeString);
begin
  ChildNodes['BALOPEN'].NodeValue := Value;
end;

function TXMLCLOSINGType.GetBALCLOSE: UnicodeString;
begin
  Result := ChildNodes['BALCLOSE'].Text;
end;

procedure TXMLCLOSINGType.SetBALCLOSE(Value: UnicodeString);
begin
  ChildNodes['BALCLOSE'].NodeValue := Value;
end;

function TXMLCLOSINGType.GetBALMIN: UnicodeString;
begin
  Result := ChildNodes['BALMIN'].Text;
end;

procedure TXMLCLOSINGType.SetBALMIN(Value: UnicodeString);
begin
  ChildNodes['BALMIN'].NodeValue := Value;
end;

function TXMLCLOSINGType.GetDEPANDCREDIT: UnicodeString;
begin
  Result := ChildNodes['DEPANDCREDIT'].Text;
end;

procedure TXMLCLOSINGType.SetDEPANDCREDIT(Value: UnicodeString);
begin
  ChildNodes['DEPANDCREDIT'].NodeValue := Value;
end;

function TXMLCLOSINGType.GetCHKANDDEB: UnicodeString;
begin
  Result := ChildNodes['CHKANDDEB'].Text;
end;

procedure TXMLCLOSINGType.SetCHKANDDEB(Value: UnicodeString);
begin
  ChildNodes['CHKANDDEB'].NodeValue := Value;
end;

function TXMLCLOSINGType.GetTOTALFEES: UnicodeString;
begin
  Result := ChildNodes['TOTALFEES'].Text;
end;

procedure TXMLCLOSINGType.SetTOTALFEES(Value: UnicodeString);
begin
  ChildNodes['TOTALFEES'].NodeValue := Value;
end;

function TXMLCLOSINGType.GetTOTALINT: UnicodeString;
begin
  Result := ChildNodes['TOTALINT'].Text;
end;

procedure TXMLCLOSINGType.SetTOTALINT(Value: UnicodeString);
begin
  ChildNodes['TOTALINT'].NodeValue := Value;
end;

function TXMLCLOSINGType.GetDTPOSTSTART: UnicodeString;
begin
  Result := ChildNodes['DTPOSTSTART'].Text;
end;

procedure TXMLCLOSINGType.SetDTPOSTSTART(Value: UnicodeString);
begin
  ChildNodes['DTPOSTSTART'].NodeValue := Value;
end;

function TXMLCLOSINGType.GetDTPOSTEND: UnicodeString;
begin
  Result := ChildNodes['DTPOSTEND'].Text;
end;

procedure TXMLCLOSINGType.SetDTPOSTEND(Value: UnicodeString);
begin
  ChildNodes['DTPOSTEND'].NodeValue := Value;
end;

function TXMLCLOSINGType.GetMKTGINFO: UnicodeString;
begin
  Result := ChildNodes['MKTGINFO'].Text;
end;

procedure TXMLCLOSINGType.SetMKTGINFO(Value: UnicodeString);
begin
  ChildNodes['MKTGINFO'].NodeValue := Value;
end;

function TXMLCLOSINGType.GetCURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLCLOSINGType.SetCURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLCLOSINGType.GetORIGCURRENCY: UnicodeString;
begin
  Result := ChildNodes['ORIGCURRENCY'].Text;
end;

procedure TXMLCLOSINGType.SetORIGCURRENCY(Value: UnicodeString);
begin
  ChildNodes['ORIGCURRENCY'].NodeValue := Value;
end;

{ TXMLCLOSINGTypeList }

function TXMLCLOSINGTypeList.Add: IXMLCLOSINGType;
begin
  Result := AddItem(-1) as IXMLCLOSINGType;
end;

function TXMLCLOSINGTypeList.Insert(const Index: Integer): IXMLCLOSINGType;
begin
  Result := AddItem(Index) as IXMLCLOSINGType;
end;

function TXMLCLOSINGTypeList.GetItem(Index: Integer): IXMLCLOSINGType;
begin
  Result := List[Index] as IXMLCLOSINGType;
end;

{ TXMLINTRATRNRSType }

procedure TXMLINTRATRNRSType.AfterConstruction;
begin
  RegisterChildNode('INTRARS', TXMLINTRARSType);
  RegisterChildNode('INTRAMODRS', TXMLINTRAMODRSType);
  RegisterChildNode('INTRACANRS', TXMLINTRACANRSType);
  inherited;
end;

function TXMLINTRATRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLINTRATRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLINTRATRNRSType.GetINTRARS: IXMLINTRARSType;
begin
  Result := ChildNodes['INTRARS'] as IXMLINTRARSType;
end;

function TXMLINTRATRNRSType.GetINTRAMODRS: IXMLINTRAMODRSType;
begin
  Result := ChildNodes['INTRAMODRS'] as IXMLINTRAMODRSType;
end;

function TXMLINTRATRNRSType.GetINTRACANRS: IXMLINTRACANRSType;
begin
  Result := ChildNodes['INTRACANRS'] as IXMLINTRACANRSType;
end;

{ TXMLINTRATRNRSTypeList }

function TXMLINTRATRNRSTypeList.Add: IXMLINTRATRNRSType;
begin
  Result := AddItem(-1) as IXMLINTRATRNRSType;
end;

function TXMLINTRATRNRSTypeList.Insert(const Index: Integer): IXMLINTRATRNRSType;
begin
  Result := AddItem(Index) as IXMLINTRATRNRSType;
end;

function TXMLINTRATRNRSTypeList.GetItem(Index: Integer): IXMLINTRATRNRSType;
begin
  Result := List[Index] as IXMLINTRATRNRSType;
end;

{ TXMLINTRARSType }

procedure TXMLINTRARSType.AfterConstruction;
begin
  RegisterChildNode('XFERINFO', TXMLXFERINFOType);
  RegisterChildNode('XFERPRCSTS', TXMLXFERPRCSTSType);
  inherited;
end;

function TXMLINTRARSType.GetCURDEF: UnicodeString;
begin
  Result := ChildNodes['CURDEF'].Text;
end;

procedure TXMLINTRARSType.SetCURDEF(Value: UnicodeString);
begin
  ChildNodes['CURDEF'].NodeValue := Value;
end;

function TXMLINTRARSType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLINTRARSType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

function TXMLINTRARSType.GetXFERINFO: IXMLXFERINFOType;
begin
  Result := ChildNodes['XFERINFO'] as IXMLXFERINFOType;
end;

function TXMLINTRARSType.GetDTXFERPRJ: UnicodeString;
begin
  Result := ChildNodes['DTXFERPRJ'].Text;
end;

procedure TXMLINTRARSType.SetDTXFERPRJ(Value: UnicodeString);
begin
  ChildNodes['DTXFERPRJ'].NodeValue := Value;
end;

function TXMLINTRARSType.GetDTPOSTED: UnicodeString;
begin
  Result := ChildNodes['DTPOSTED'].Text;
end;

procedure TXMLINTRARSType.SetDTPOSTED(Value: UnicodeString);
begin
  ChildNodes['DTPOSTED'].NodeValue := Value;
end;

function TXMLINTRARSType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLINTRARSType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

function TXMLINTRARSType.GetXFERPRCSTS: IXMLXFERPRCSTSType;
begin
  Result := ChildNodes['XFERPRCSTS'] as IXMLXFERPRCSTSType;
end;

{ TXMLXFERPRCSTSType }

function TXMLXFERPRCSTSType.GetXFERPRCCODE: UnicodeString;
begin
  Result := ChildNodes['XFERPRCCODE'].Text;
end;

procedure TXMLXFERPRCSTSType.SetXFERPRCCODE(Value: UnicodeString);
begin
  ChildNodes['XFERPRCCODE'].NodeValue := Value;
end;

function TXMLXFERPRCSTSType.GetDTXFERPRC: UnicodeString;
begin
  Result := ChildNodes['DTXFERPRC'].Text;
end;

procedure TXMLXFERPRCSTSType.SetDTXFERPRC(Value: UnicodeString);
begin
  ChildNodes['DTXFERPRC'].NodeValue := Value;
end;

{ TXMLINTRAMODRSType }

procedure TXMLINTRAMODRSType.AfterConstruction;
begin
  RegisterChildNode('XFERINFO', TXMLXFERINFOType);
  RegisterChildNode('XFERPRCSTS', TXMLXFERPRCSTSType);
  inherited;
end;

function TXMLINTRAMODRSType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLINTRAMODRSType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

function TXMLINTRAMODRSType.GetXFERINFO: IXMLXFERINFOType;
begin
  Result := ChildNodes['XFERINFO'] as IXMLXFERINFOType;
end;

function TXMLINTRAMODRSType.GetXFERPRCSTS: IXMLXFERPRCSTSType;
begin
  Result := ChildNodes['XFERPRCSTS'] as IXMLXFERPRCSTSType;
end;

{ TXMLINTRACANRSType }

function TXMLINTRACANRSType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLINTRACANRSType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

{ TXMLRECINTRATRNRSType }

procedure TXMLRECINTRATRNRSType.AfterConstruction;
begin
  RegisterChildNode('RECINTRARS', TXMLRECINTRARSType);
  RegisterChildNode('RECINTRAMODRS', TXMLRECINTRAMODRSType);
  RegisterChildNode('RECINTRACANRS', TXMLRECINTRACANRSType);
  inherited;
end;

function TXMLRECINTRATRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLRECINTRATRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLRECINTRATRNRSType.GetRECINTRARS: IXMLRECINTRARSType;
begin
  Result := ChildNodes['RECINTRARS'] as IXMLRECINTRARSType;
end;

function TXMLRECINTRATRNRSType.GetRECINTRAMODRS: IXMLRECINTRAMODRSType;
begin
  Result := ChildNodes['RECINTRAMODRS'] as IXMLRECINTRAMODRSType;
end;

function TXMLRECINTRATRNRSType.GetRECINTRACANRS: IXMLRECINTRACANRSType;
begin
  Result := ChildNodes['RECINTRACANRS'] as IXMLRECINTRACANRSType;
end;

{ TXMLRECINTRATRNRSTypeList }

function TXMLRECINTRATRNRSTypeList.Add: IXMLRECINTRATRNRSType;
begin
  Result := AddItem(-1) as IXMLRECINTRATRNRSType;
end;

function TXMLRECINTRATRNRSTypeList.Insert(const Index: Integer): IXMLRECINTRATRNRSType;
begin
  Result := AddItem(Index) as IXMLRECINTRATRNRSType;
end;

function TXMLRECINTRATRNRSTypeList.GetItem(Index: Integer): IXMLRECINTRATRNRSType;
begin
  Result := List[Index] as IXMLRECINTRATRNRSType;
end;

{ TXMLRECINTRARSType }

procedure TXMLRECINTRARSType.AfterConstruction;
begin
  RegisterChildNode('RECURRINST', TXMLRECURRINSTType);
  RegisterChildNode('INTRARS', TXMLINTRARSType);
  inherited;
end;

function TXMLRECINTRARSType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLRECINTRARSType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

function TXMLRECINTRARSType.GetRECURRINST: IXMLRECURRINSTType;
begin
  Result := ChildNodes['RECURRINST'] as IXMLRECURRINSTType;
end;

function TXMLRECINTRARSType.GetINTRARS: IXMLINTRARSType;
begin
  Result := ChildNodes['INTRARS'] as IXMLINTRARSType;
end;

{ TXMLRECINTRAMODRSType }

procedure TXMLRECINTRAMODRSType.AfterConstruction;
begin
  RegisterChildNode('RECURRINST', TXMLRECURRINSTType);
  RegisterChildNode('INTRARS', TXMLINTRARSType);
  inherited;
end;

function TXMLRECINTRAMODRSType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLRECINTRAMODRSType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

function TXMLRECINTRAMODRSType.GetRECURRINST: IXMLRECURRINSTType;
begin
  Result := ChildNodes['RECURRINST'] as IXMLRECURRINSTType;
end;

function TXMLRECINTRAMODRSType.GetINTRARS: IXMLINTRARSType;
begin
  Result := ChildNodes['INTRARS'] as IXMLINTRARSType;
end;

function TXMLRECINTRAMODRSType.GetMODPENDING: UnicodeString;
begin
  Result := ChildNodes['MODPENDING'].Text;
end;

procedure TXMLRECINTRAMODRSType.SetMODPENDING(Value: UnicodeString);
begin
  ChildNodes['MODPENDING'].NodeValue := Value;
end;

{ TXMLRECINTRACANRSType }

function TXMLRECINTRACANRSType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLRECINTRACANRSType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

function TXMLRECINTRACANRSType.GetCANPENDING: UnicodeString;
begin
  Result := ChildNodes['CANPENDING'].Text;
end;

procedure TXMLRECINTRACANRSType.SetCANPENDING(Value: UnicodeString);
begin
  ChildNodes['CANPENDING'].NodeValue := Value;
end;

{ TXMLSTPCHKTRNRSType }

procedure TXMLSTPCHKTRNRSType.AfterConstruction;
begin
  RegisterChildNode('STPCHKRS', TXMLSTPCHKRSType);
  inherited;
end;

function TXMLSTPCHKTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLSTPCHKTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLSTPCHKTRNRSType.GetSTPCHKRS: IXMLSTPCHKRSType;
begin
  Result := ChildNodes['STPCHKRS'] as IXMLSTPCHKRSType;
end;

{ TXMLSTPCHKTRNRSTypeList }

function TXMLSTPCHKTRNRSTypeList.Add: IXMLSTPCHKTRNRSType;
begin
  Result := AddItem(-1) as IXMLSTPCHKTRNRSType;
end;

function TXMLSTPCHKTRNRSTypeList.Insert(const Index: Integer): IXMLSTPCHKTRNRSType;
begin
  Result := AddItem(Index) as IXMLSTPCHKTRNRSType;
end;

function TXMLSTPCHKTRNRSTypeList.GetItem(Index: Integer): IXMLSTPCHKTRNRSType;
begin
  Result := List[Index] as IXMLSTPCHKTRNRSType;
end;

{ TXMLSTPCHKRSType }

procedure TXMLSTPCHKRSType.AfterConstruction;
begin
  RegisterChildNode('STPCHKNUM', TXMLSTPCHKNUMType);
  FSTPCHKNUM := CreateCollection(TXMLSTPCHKNUMTypeList, IXMLSTPCHKNUMType, 'STPCHKNUM') as IXMLSTPCHKNUMTypeList;
  inherited;
end;

function TXMLSTPCHKRSType.GetCURDEF: UnicodeString;
begin
  Result := ChildNodes['CURDEF'].Text;
end;

procedure TXMLSTPCHKRSType.SetCURDEF(Value: UnicodeString);
begin
  ChildNodes['CURDEF'].NodeValue := Value;
end;

function TXMLSTPCHKRSType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLSTPCHKRSType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLSTPCHKRSType.GetSTPCHKNUM: IXMLSTPCHKNUMTypeList;
begin
  Result := FSTPCHKNUM;
end;

function TXMLSTPCHKRSType.GetFEE: UnicodeString;
begin
  Result := ChildNodes['FEE'].Text;
end;

procedure TXMLSTPCHKRSType.SetFEE(Value: UnicodeString);
begin
  ChildNodes['FEE'].NodeValue := Value;
end;

function TXMLSTPCHKRSType.GetFEEMSG: UnicodeString;
begin
  Result := ChildNodes['FEEMSG'].Text;
end;

procedure TXMLSTPCHKRSType.SetFEEMSG(Value: UnicodeString);
begin
  ChildNodes['FEEMSG'].NodeValue := Value;
end;

{ TXMLSTPCHKNUMType }

function TXMLSTPCHKNUMType.GetCHECKNUM: UnicodeString;
begin
  Result := ChildNodes['CHECKNUM'].Text;
end;

procedure TXMLSTPCHKNUMType.SetCHECKNUM(Value: UnicodeString);
begin
  ChildNodes['CHECKNUM'].NodeValue := Value;
end;

function TXMLSTPCHKNUMType.GetNAME: UnicodeString;
begin
  Result := ChildNodes['NAME'].Text;
end;

procedure TXMLSTPCHKNUMType.SetNAME(Value: UnicodeString);
begin
  ChildNodes['NAME'].NodeValue := Value;
end;

function TXMLSTPCHKNUMType.GetDTUSER: UnicodeString;
begin
  Result := ChildNodes['DTUSER'].Text;
end;

procedure TXMLSTPCHKNUMType.SetDTUSER(Value: UnicodeString);
begin
  ChildNodes['DTUSER'].NodeValue := Value;
end;

function TXMLSTPCHKNUMType.GetTRNAMT: UnicodeString;
begin
  Result := ChildNodes['TRNAMT'].Text;
end;

procedure TXMLSTPCHKNUMType.SetTRNAMT(Value: UnicodeString);
begin
  ChildNodes['TRNAMT'].NodeValue := Value;
end;

function TXMLSTPCHKNUMType.GetCHKSTATUS: UnicodeString;
begin
  Result := ChildNodes['CHKSTATUS'].Text;
end;

procedure TXMLSTPCHKNUMType.SetCHKSTATUS(Value: UnicodeString);
begin
  ChildNodes['CHKSTATUS'].NodeValue := Value;
end;

function TXMLSTPCHKNUMType.GetCHKERROR: UnicodeString;
begin
  Result := ChildNodes['CHKERROR'].Text;
end;

procedure TXMLSTPCHKNUMType.SetCHKERROR(Value: UnicodeString);
begin
  ChildNodes['CHKERROR'].NodeValue := Value;
end;

function TXMLSTPCHKNUMType.GetCURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLSTPCHKNUMType.SetCURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLSTPCHKNUMType.GetORIGCURRENCY: UnicodeString;
begin
  Result := ChildNodes['ORIGCURRENCY'].Text;
end;

procedure TXMLSTPCHKNUMType.SetORIGCURRENCY(Value: UnicodeString);
begin
  ChildNodes['ORIGCURRENCY'].NodeValue := Value;
end;

{ TXMLSTPCHKNUMTypeList }

function TXMLSTPCHKNUMTypeList.Add: IXMLSTPCHKNUMType;
begin
  Result := AddItem(-1) as IXMLSTPCHKNUMType;
end;

function TXMLSTPCHKNUMTypeList.Insert(const Index: Integer): IXMLSTPCHKNUMType;
begin
  Result := AddItem(Index) as IXMLSTPCHKNUMType;
end;

function TXMLSTPCHKNUMTypeList.GetItem(Index: Integer): IXMLSTPCHKNUMType;
begin
  Result := List[Index] as IXMLSTPCHKNUMType;
end;

{ TXMLBANKMAILTRNRSType }

procedure TXMLBANKMAILTRNRSType.AfterConstruction;
begin
  RegisterChildNode('BANKMAILRS', TXMLBANKMAILRSType);
  RegisterChildNode('CHKMAILRS', TXMLCHKMAILRSType);
  RegisterChildNode('DEPMAILRS', TXMLDEPMAILRSType);
  inherited;
end;

function TXMLBANKMAILTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLBANKMAILTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLBANKMAILTRNRSType.GetBANKMAILRS: IXMLBANKMAILRSType;
begin
  Result := ChildNodes['BANKMAILRS'] as IXMLBANKMAILRSType;
end;

function TXMLBANKMAILTRNRSType.GetCHKMAILRS: IXMLCHKMAILRSType;
begin
  Result := ChildNodes['CHKMAILRS'] as IXMLCHKMAILRSType;
end;

function TXMLBANKMAILTRNRSType.GetDEPMAILRS: IXMLDEPMAILRSType;
begin
  Result := ChildNodes['DEPMAILRS'] as IXMLDEPMAILRSType;
end;

{ TXMLBANKMAILTRNRSTypeList }

function TXMLBANKMAILTRNRSTypeList.Add: IXMLBANKMAILTRNRSType;
begin
  Result := AddItem(-1) as IXMLBANKMAILTRNRSType;
end;

function TXMLBANKMAILTRNRSTypeList.Insert(const Index: Integer): IXMLBANKMAILTRNRSType;
begin
  Result := AddItem(Index) as IXMLBANKMAILTRNRSType;
end;

function TXMLBANKMAILTRNRSTypeList.GetItem(Index: Integer): IXMLBANKMAILTRNRSType;
begin
  Result := List[Index] as IXMLBANKMAILTRNRSType;
end;

{ TXMLBANKMAILRSType }

procedure TXMLBANKMAILRSType.AfterConstruction;
begin
  RegisterChildNode('MAIL', TXMLMAILType);
  inherited;
end;

function TXMLBANKMAILRSType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLBANKMAILRSType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLBANKMAILRSType.GetCCACCTFROM: UnicodeString;
begin
  Result := ChildNodes['CCACCTFROM'].Text;
end;

procedure TXMLBANKMAILRSType.SetCCACCTFROM(Value: UnicodeString);
begin
  ChildNodes['CCACCTFROM'].NodeValue := Value;
end;

function TXMLBANKMAILRSType.GetMAIL: IXMLMAILType;
begin
  Result := ChildNodes['MAIL'] as IXMLMAILType;
end;

{ TXMLCHKMAILRSType }

procedure TXMLCHKMAILRSType.AfterConstruction;
begin
  RegisterChildNode('MAIL', TXMLMAILType);
  inherited;
end;

function TXMLCHKMAILRSType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLCHKMAILRSType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLCHKMAILRSType.GetMAIL: IXMLMAILType;
begin
  Result := ChildNodes['MAIL'] as IXMLMAILType;
end;

function TXMLCHKMAILRSType.GetCHECKNUM: UnicodeString;
begin
  Result := ChildNodes['CHECKNUM'].Text;
end;

procedure TXMLCHKMAILRSType.SetCHECKNUM(Value: UnicodeString);
begin
  ChildNodes['CHECKNUM'].NodeValue := Value;
end;

function TXMLCHKMAILRSType.GetTRNAMT: UnicodeString;
begin
  Result := ChildNodes['TRNAMT'].Text;
end;

procedure TXMLCHKMAILRSType.SetTRNAMT(Value: UnicodeString);
begin
  ChildNodes['TRNAMT'].NodeValue := Value;
end;

function TXMLCHKMAILRSType.GetDTUSER: UnicodeString;
begin
  Result := ChildNodes['DTUSER'].Text;
end;

procedure TXMLCHKMAILRSType.SetDTUSER(Value: UnicodeString);
begin
  ChildNodes['DTUSER'].NodeValue := Value;
end;

function TXMLCHKMAILRSType.GetFEE: UnicodeString;
begin
  Result := ChildNodes['FEE'].Text;
end;

procedure TXMLCHKMAILRSType.SetFEE(Value: UnicodeString);
begin
  ChildNodes['FEE'].NodeValue := Value;
end;

{ TXMLDEPMAILRSType }

procedure TXMLDEPMAILRSType.AfterConstruction;
begin
  RegisterChildNode('MAIL', TXMLMAILType);
  inherited;
end;

function TXMLDEPMAILRSType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLDEPMAILRSType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLDEPMAILRSType.GetMAIL: IXMLMAILType;
begin
  Result := ChildNodes['MAIL'] as IXMLMAILType;
end;

function TXMLDEPMAILRSType.GetTRNAMT: UnicodeString;
begin
  Result := ChildNodes['TRNAMT'].Text;
end;

procedure TXMLDEPMAILRSType.SetTRNAMT(Value: UnicodeString);
begin
  ChildNodes['TRNAMT'].NodeValue := Value;
end;

function TXMLDEPMAILRSType.GetDTUSER: UnicodeString;
begin
  Result := ChildNodes['DTUSER'].Text;
end;

procedure TXMLDEPMAILRSType.SetDTUSER(Value: UnicodeString);
begin
  ChildNodes['DTUSER'].NodeValue := Value;
end;

function TXMLDEPMAILRSType.GetFEE: UnicodeString;
begin
  Result := ChildNodes['FEE'].Text;
end;

procedure TXMLDEPMAILRSType.SetFEE(Value: UnicodeString);
begin
  ChildNodes['FEE'].NodeValue := Value;
end;

{ TXMLBANKMAILSYNCRSType }

procedure TXMLBANKMAILSYNCRSType.AfterConstruction;
begin
  RegisterChildNode('BANKMAILTRNRS', TXMLBANKMAILTRNRSType);
  FBANKMAILTRNRS := CreateCollection(TXMLBANKMAILTRNRSTypeList, IXMLBANKMAILTRNRSType, 'BANKMAILTRNRS') as IXMLBANKMAILTRNRSTypeList;
  inherited;
end;

function TXMLBANKMAILSYNCRSType.GetSYNCRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRSMACRO'].Text;
end;

procedure TXMLBANKMAILSYNCRSType.SetSYNCRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRSMACRO'].NodeValue := Value;
end;

function TXMLBANKMAILSYNCRSType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLBANKMAILSYNCRSType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLBANKMAILSYNCRSType.GetCCACCTFROM: UnicodeString;
begin
  Result := ChildNodes['CCACCTFROM'].Text;
end;

procedure TXMLBANKMAILSYNCRSType.SetCCACCTFROM(Value: UnicodeString);
begin
  ChildNodes['CCACCTFROM'].NodeValue := Value;
end;

function TXMLBANKMAILSYNCRSType.GetBANKMAILTRNRS: IXMLBANKMAILTRNRSTypeList;
begin
  Result := FBANKMAILTRNRS;
end;

{ TXMLBANKMAILSYNCRSTypeList }

function TXMLBANKMAILSYNCRSTypeList.Add: IXMLBANKMAILSYNCRSType;
begin
  Result := AddItem(-1) as IXMLBANKMAILSYNCRSType;
end;

function TXMLBANKMAILSYNCRSTypeList.Insert(const Index: Integer): IXMLBANKMAILSYNCRSType;
begin
  Result := AddItem(Index) as IXMLBANKMAILSYNCRSType;
end;

function TXMLBANKMAILSYNCRSTypeList.GetItem(Index: Integer): IXMLBANKMAILSYNCRSType;
begin
  Result := List[Index] as IXMLBANKMAILSYNCRSType;
end;

{ TXMLSTPCHKSYNCRSType }

procedure TXMLSTPCHKSYNCRSType.AfterConstruction;
begin
  RegisterChildNode('STPCHKTRNRS', TXMLSTPCHKTRNRSType);
  FSTPCHKTRNRS := CreateCollection(TXMLSTPCHKTRNRSTypeList, IXMLSTPCHKTRNRSType, 'STPCHKTRNRS') as IXMLSTPCHKTRNRSTypeList;
  inherited;
end;

function TXMLSTPCHKSYNCRSType.GetSYNCRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRSMACRO'].Text;
end;

procedure TXMLSTPCHKSYNCRSType.SetSYNCRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRSMACRO'].NodeValue := Value;
end;

function TXMLSTPCHKSYNCRSType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLSTPCHKSYNCRSType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLSTPCHKSYNCRSType.GetSTPCHKTRNRS: IXMLSTPCHKTRNRSTypeList;
begin
  Result := FSTPCHKTRNRS;
end;

{ TXMLSTPCHKSYNCRSTypeList }

function TXMLSTPCHKSYNCRSTypeList.Add: IXMLSTPCHKSYNCRSType;
begin
  Result := AddItem(-1) as IXMLSTPCHKSYNCRSType;
end;

function TXMLSTPCHKSYNCRSTypeList.Insert(const Index: Integer): IXMLSTPCHKSYNCRSType;
begin
  Result := AddItem(Index) as IXMLSTPCHKSYNCRSType;
end;

function TXMLSTPCHKSYNCRSTypeList.GetItem(Index: Integer): IXMLSTPCHKSYNCRSType;
begin
  Result := List[Index] as IXMLSTPCHKSYNCRSType;
end;

{ TXMLINTRASYNCRSType }

procedure TXMLINTRASYNCRSType.AfterConstruction;
begin
  RegisterChildNode('INTRATRNRS', TXMLINTRATRNRSType);
  FINTRATRNRS := CreateCollection(TXMLINTRATRNRSTypeList, IXMLINTRATRNRSType, 'INTRATRNRS') as IXMLINTRATRNRSTypeList;
  inherited;
end;

function TXMLINTRASYNCRSType.GetSYNCRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRSMACRO'].Text;
end;

procedure TXMLINTRASYNCRSType.SetSYNCRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRSMACRO'].NodeValue := Value;
end;

function TXMLINTRASYNCRSType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLINTRASYNCRSType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLINTRASYNCRSType.GetINTRATRNRS: IXMLINTRATRNRSTypeList;
begin
  Result := FINTRATRNRS;
end;

{ TXMLINTRASYNCRSTypeList }

function TXMLINTRASYNCRSTypeList.Add: IXMLINTRASYNCRSType;
begin
  Result := AddItem(-1) as IXMLINTRASYNCRSType;
end;

function TXMLINTRASYNCRSTypeList.Insert(const Index: Integer): IXMLINTRASYNCRSType;
begin
  Result := AddItem(Index) as IXMLINTRASYNCRSType;
end;

function TXMLINTRASYNCRSTypeList.GetItem(Index: Integer): IXMLINTRASYNCRSType;
begin
  Result := List[Index] as IXMLINTRASYNCRSType;
end;

{ TXMLRECINTRASYNCRSType }

procedure TXMLRECINTRASYNCRSType.AfterConstruction;
begin
  RegisterChildNode('RECINTRATRNRS', TXMLRECINTRATRNRSType);
  FRECINTRATRNRS := CreateCollection(TXMLRECINTRATRNRSTypeList, IXMLRECINTRATRNRSType, 'RECINTRATRNRS') as IXMLRECINTRATRNRSTypeList;
  inherited;
end;

function TXMLRECINTRASYNCRSType.GetSYNCRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRSMACRO'].Text;
end;

procedure TXMLRECINTRASYNCRSType.SetSYNCRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRSMACRO'].NodeValue := Value;
end;

function TXMLRECINTRASYNCRSType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLRECINTRASYNCRSType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLRECINTRASYNCRSType.GetRECINTRATRNRS: IXMLRECINTRATRNRSTypeList;
begin
  Result := FRECINTRATRNRS;
end;

{ TXMLRECINTRASYNCRSTypeList }

function TXMLRECINTRASYNCRSTypeList.Add: IXMLRECINTRASYNCRSType;
begin
  Result := AddItem(-1) as IXMLRECINTRASYNCRSType;
end;

function TXMLRECINTRASYNCRSTypeList.Insert(const Index: Integer): IXMLRECINTRASYNCRSType;
begin
  Result := AddItem(Index) as IXMLRECINTRASYNCRSType;
end;

function TXMLRECINTRASYNCRSTypeList.GetItem(Index: Integer): IXMLRECINTRASYNCRSType;
begin
  Result := List[Index] as IXMLRECINTRASYNCRSType;
end;

{ TXMLCREDITCARDMSGSRSV1Type }

procedure TXMLCREDITCARDMSGSRSV1Type.AfterConstruction;
begin
  RegisterChildNode('CCSTMTTRNRS', TXMLCCSTMTTRNRSType);
  RegisterChildNode('CCSTMTENDTRNRS', TXMLCCSTMTENDTRNRSType);
  FCCSTMTTRNRS := CreateCollection(TXMLCCSTMTTRNRSTypeList, IXMLCCSTMTTRNRSType, 'CCSTMTTRNRS') as IXMLCCSTMTTRNRSTypeList;
  FCCSTMTENDTRNRS := CreateCollection(TXMLCCSTMTENDTRNRSTypeList, IXMLCCSTMTENDTRNRSType, 'CCSTMTENDTRNRS') as IXMLCCSTMTENDTRNRSTypeList;
  inherited;
end;

function TXMLCREDITCARDMSGSRSV1Type.GetCCSTMTTRNRS: IXMLCCSTMTTRNRSTypeList;
begin
  Result := FCCSTMTTRNRS;
end;

function TXMLCREDITCARDMSGSRSV1Type.GetCCSTMTENDTRNRS: IXMLCCSTMTENDTRNRSTypeList;
begin
  Result := FCCSTMTENDTRNRS;
end;

{ TXMLCCSTMTTRNRSType }

procedure TXMLCCSTMTTRNRSType.AfterConstruction;
begin
  RegisterChildNode('CCSTMTRS', TXMLCCSTMTRSType);
  inherited;
end;

function TXMLCCSTMTTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLCCSTMTTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLCCSTMTTRNRSType.GetCCSTMTRS: IXMLCCSTMTRSType;
begin
  Result := ChildNodes['CCSTMTRS'] as IXMLCCSTMTRSType;
end;

{ TXMLCCSTMTTRNRSTypeList }

function TXMLCCSTMTTRNRSTypeList.Add: IXMLCCSTMTTRNRSType;
begin
  Result := AddItem(-1) as IXMLCCSTMTTRNRSType;
end;

function TXMLCCSTMTTRNRSTypeList.Insert(const Index: Integer): IXMLCCSTMTTRNRSType;
begin
  Result := AddItem(Index) as IXMLCCSTMTTRNRSType;
end;

function TXMLCCSTMTTRNRSTypeList.GetItem(Index: Integer): IXMLCCSTMTTRNRSType;
begin
  Result := List[Index] as IXMLCCSTMTTRNRSType;
end;

{ TXMLCCSTMTRSType }

procedure TXMLCCSTMTRSType.AfterConstruction;
begin
  RegisterChildNode('BANKTRANLIST', TXMLBANKTRANLISTType);
  RegisterChildNode('LEDGERBAL', TXMLLEDGERBALType);
  RegisterChildNode('AVAILBAL', TXMLAVAILBALType);
  inherited;
end;

function TXMLCCSTMTRSType.GetCURDEF: UnicodeString;
begin
  Result := ChildNodes['CURDEF'].Text;
end;

procedure TXMLCCSTMTRSType.SetCURDEF(Value: UnicodeString);
begin
  ChildNodes['CURDEF'].NodeValue := Value;
end;

function TXMLCCSTMTRSType.GetCCACCTFROM: UnicodeString;
begin
  Result := ChildNodes['CCACCTFROM'].Text;
end;

procedure TXMLCCSTMTRSType.SetCCACCTFROM(Value: UnicodeString);
begin
  ChildNodes['CCACCTFROM'].NodeValue := Value;
end;

function TXMLCCSTMTRSType.GetBANKTRANLIST: IXMLBANKTRANLISTType;
begin
  Result := ChildNodes['BANKTRANLIST'] as IXMLBANKTRANLISTType;
end;

function TXMLCCSTMTRSType.GetLEDGERBAL: IXMLLEDGERBALType;
begin
  Result := ChildNodes['LEDGERBAL'] as IXMLLEDGERBALType;
end;

function TXMLCCSTMTRSType.GetAVAILBAL: IXMLAVAILBALType;
begin
  Result := ChildNodes['AVAILBAL'] as IXMLAVAILBALType;
end;

function TXMLCCSTMTRSType.GetMKTGINFO: UnicodeString;
begin
  Result := ChildNodes['MKTGINFO'].Text;
end;

procedure TXMLCCSTMTRSType.SetMKTGINFO(Value: UnicodeString);
begin
  ChildNodes['MKTGINFO'].NodeValue := Value;
end;

{ TXMLCCSTMTENDTRNRSType }

procedure TXMLCCSTMTENDTRNRSType.AfterConstruction;
begin
  RegisterChildNode('CCSTMTENDRS', TXMLCCSTMTENDRSType);
  inherited;
end;

function TXMLCCSTMTENDTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLCCSTMTENDTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLCCSTMTENDTRNRSType.GetCCSTMTENDRS: IXMLCCSTMTENDRSType;
begin
  Result := ChildNodes['CCSTMTENDRS'] as IXMLCCSTMTENDRSType;
end;

{ TXMLCCSTMTENDTRNRSTypeList }

function TXMLCCSTMTENDTRNRSTypeList.Add: IXMLCCSTMTENDTRNRSType;
begin
  Result := AddItem(-1) as IXMLCCSTMTENDTRNRSType;
end;

function TXMLCCSTMTENDTRNRSTypeList.Insert(const Index: Integer): IXMLCCSTMTENDTRNRSType;
begin
  Result := AddItem(Index) as IXMLCCSTMTENDTRNRSType;
end;

function TXMLCCSTMTENDTRNRSTypeList.GetItem(Index: Integer): IXMLCCSTMTENDTRNRSType;
begin
  Result := List[Index] as IXMLCCSTMTENDTRNRSType;
end;

{ TXMLCCSTMTENDRSType }

procedure TXMLCCSTMTENDRSType.AfterConstruction;
begin
  RegisterChildNode('CCCLOSING', TXMLCCCLOSINGType);
  FCCCLOSING := CreateCollection(TXMLCCCLOSINGTypeList, IXMLCCCLOSINGType, 'CCCLOSING') as IXMLCCCLOSINGTypeList;
  inherited;
end;

function TXMLCCSTMTENDRSType.GetCURDEF: UnicodeString;
begin
  Result := ChildNodes['CURDEF'].Text;
end;

procedure TXMLCCSTMTENDRSType.SetCURDEF(Value: UnicodeString);
begin
  ChildNodes['CURDEF'].NodeValue := Value;
end;

function TXMLCCSTMTENDRSType.GetCCACCTFROM: UnicodeString;
begin
  Result := ChildNodes['CCACCTFROM'].Text;
end;

procedure TXMLCCSTMTENDRSType.SetCCACCTFROM(Value: UnicodeString);
begin
  ChildNodes['CCACCTFROM'].NodeValue := Value;
end;

function TXMLCCSTMTENDRSType.GetCCCLOSING: IXMLCCCLOSINGTypeList;
begin
  Result := FCCCLOSING;
end;

{ TXMLCCCLOSINGType }

function TXMLCCCLOSINGType.GetFITID: UnicodeString;
begin
  Result := ChildNodes['FITID'].Text;
end;

procedure TXMLCCCLOSINGType.SetFITID(Value: UnicodeString);
begin
  ChildNodes['FITID'].NodeValue := Value;
end;

function TXMLCCCLOSINGType.GetDTOPEN: UnicodeString;
begin
  Result := ChildNodes['DTOPEN'].Text;
end;

procedure TXMLCCCLOSINGType.SetDTOPEN(Value: UnicodeString);
begin
  ChildNodes['DTOPEN'].NodeValue := Value;
end;

function TXMLCCCLOSINGType.GetDTCLOSE: UnicodeString;
begin
  Result := ChildNodes['DTCLOSE'].Text;
end;

procedure TXMLCCCLOSINGType.SetDTCLOSE(Value: UnicodeString);
begin
  ChildNodes['DTCLOSE'].NodeValue := Value;
end;

function TXMLCCCLOSINGType.GetDTNEXT: UnicodeString;
begin
  Result := ChildNodes['DTNEXT'].Text;
end;

procedure TXMLCCCLOSINGType.SetDTNEXT(Value: UnicodeString);
begin
  ChildNodes['DTNEXT'].NodeValue := Value;
end;

function TXMLCCCLOSINGType.GetBALOPEN: UnicodeString;
begin
  Result := ChildNodes['BALOPEN'].Text;
end;

procedure TXMLCCCLOSINGType.SetBALOPEN(Value: UnicodeString);
begin
  ChildNodes['BALOPEN'].NodeValue := Value;
end;

function TXMLCCCLOSINGType.GetBALCLOSE: UnicodeString;
begin
  Result := ChildNodes['BALCLOSE'].Text;
end;

procedure TXMLCCCLOSINGType.SetBALCLOSE(Value: UnicodeString);
begin
  ChildNodes['BALCLOSE'].NodeValue := Value;
end;

function TXMLCCCLOSINGType.GetDTPMTDUE: UnicodeString;
begin
  Result := ChildNodes['DTPMTDUE'].Text;
end;

procedure TXMLCCCLOSINGType.SetDTPMTDUE(Value: UnicodeString);
begin
  ChildNodes['DTPMTDUE'].NodeValue := Value;
end;

function TXMLCCCLOSINGType.GetMINPMTDUE: UnicodeString;
begin
  Result := ChildNodes['MINPMTDUE'].Text;
end;

procedure TXMLCCCLOSINGType.SetMINPMTDUE(Value: UnicodeString);
begin
  ChildNodes['MINPMTDUE'].NodeValue := Value;
end;

function TXMLCCCLOSINGType.GetFINCHG: UnicodeString;
begin
  Result := ChildNodes['FINCHG'].Text;
end;

procedure TXMLCCCLOSINGType.SetFINCHG(Value: UnicodeString);
begin
  ChildNodes['FINCHG'].NodeValue := Value;
end;

function TXMLCCCLOSINGType.GetPAYANDCREDIT: UnicodeString;
begin
  Result := ChildNodes['PAYANDCREDIT'].Text;
end;

procedure TXMLCCCLOSINGType.SetPAYANDCREDIT(Value: UnicodeString);
begin
  ChildNodes['PAYANDCREDIT'].NodeValue := Value;
end;

function TXMLCCCLOSINGType.GetPURANDADV: UnicodeString;
begin
  Result := ChildNodes['PURANDADV'].Text;
end;

procedure TXMLCCCLOSINGType.SetPURANDADV(Value: UnicodeString);
begin
  ChildNodes['PURANDADV'].NodeValue := Value;
end;

function TXMLCCCLOSINGType.GetDEBADJ: UnicodeString;
begin
  Result := ChildNodes['DEBADJ'].Text;
end;

procedure TXMLCCCLOSINGType.SetDEBADJ(Value: UnicodeString);
begin
  ChildNodes['DEBADJ'].NodeValue := Value;
end;

function TXMLCCCLOSINGType.GetCREDITLIMIT: UnicodeString;
begin
  Result := ChildNodes['CREDITLIMIT'].Text;
end;

procedure TXMLCCCLOSINGType.SetCREDITLIMIT(Value: UnicodeString);
begin
  ChildNodes['CREDITLIMIT'].NodeValue := Value;
end;

function TXMLCCCLOSINGType.GetDTPOSTSTART: UnicodeString;
begin
  Result := ChildNodes['DTPOSTSTART'].Text;
end;

procedure TXMLCCCLOSINGType.SetDTPOSTSTART(Value: UnicodeString);
begin
  ChildNodes['DTPOSTSTART'].NodeValue := Value;
end;

function TXMLCCCLOSINGType.GetDTPOSTEND: UnicodeString;
begin
  Result := ChildNodes['DTPOSTEND'].Text;
end;

procedure TXMLCCCLOSINGType.SetDTPOSTEND(Value: UnicodeString);
begin
  ChildNodes['DTPOSTEND'].NodeValue := Value;
end;

function TXMLCCCLOSINGType.GetMKTGINFO: UnicodeString;
begin
  Result := ChildNodes['MKTGINFO'].Text;
end;

procedure TXMLCCCLOSINGType.SetMKTGINFO(Value: UnicodeString);
begin
  ChildNodes['MKTGINFO'].NodeValue := Value;
end;

function TXMLCCCLOSINGType.GetCURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLCCCLOSINGType.SetCURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLCCCLOSINGType.GetORIGCURRENCY: UnicodeString;
begin
  Result := ChildNodes['ORIGCURRENCY'].Text;
end;

procedure TXMLCCCLOSINGType.SetORIGCURRENCY(Value: UnicodeString);
begin
  ChildNodes['ORIGCURRENCY'].NodeValue := Value;
end;

{ TXMLCCCLOSINGTypeList }

function TXMLCCCLOSINGTypeList.Add: IXMLCCCLOSINGType;
begin
  Result := AddItem(-1) as IXMLCCCLOSINGType;
end;

function TXMLCCCLOSINGTypeList.Insert(const Index: Integer): IXMLCCCLOSINGType;
begin
  Result := AddItem(Index) as IXMLCCCLOSINGType;
end;

function TXMLCCCLOSINGTypeList.GetItem(Index: Integer): IXMLCCCLOSINGType;
begin
  Result := List[Index] as IXMLCCCLOSINGType;
end;

{ TXMLINTERXFERMSGSRSV1Type }

procedure TXMLINTERXFERMSGSRSV1Type.AfterConstruction;
begin
  RegisterChildNode('INTERTRNRS', TXMLINTERTRNRSType);
  RegisterChildNode('RECINTERTRNRS', TXMLRECINTERTRNRSType);
  RegisterChildNode('INTERSYNCRS', TXMLINTERSYNCRSType);
  RegisterChildNode('RECINTERSYNCRS', TXMLRECINTERSYNCRSType);
  FINTERTRNRS := CreateCollection(TXMLINTERTRNRSTypeList, IXMLINTERTRNRSType, 'INTERTRNRS') as IXMLINTERTRNRSTypeList;
  FRECINTERTRNRS := CreateCollection(TXMLRECINTERTRNRSTypeList, IXMLRECINTERTRNRSType, 'RECINTERTRNRS') as IXMLRECINTERTRNRSTypeList;
  FINTERSYNCRS := CreateCollection(TXMLINTERSYNCRSTypeList, IXMLINTERSYNCRSType, 'INTERSYNCRS') as IXMLINTERSYNCRSTypeList;
  FRECINTERSYNCRS := CreateCollection(TXMLRECINTERSYNCRSTypeList, IXMLRECINTERSYNCRSType, 'RECINTERSYNCRS') as IXMLRECINTERSYNCRSTypeList;
  inherited;
end;

function TXMLINTERXFERMSGSRSV1Type.GetINTERTRNRS: IXMLINTERTRNRSTypeList;
begin
  Result := FINTERTRNRS;
end;

function TXMLINTERXFERMSGSRSV1Type.GetRECINTERTRNRS: IXMLRECINTERTRNRSTypeList;
begin
  Result := FRECINTERTRNRS;
end;

function TXMLINTERXFERMSGSRSV1Type.GetINTERSYNCRS: IXMLINTERSYNCRSTypeList;
begin
  Result := FINTERSYNCRS;
end;

function TXMLINTERXFERMSGSRSV1Type.GetRECINTERSYNCRS: IXMLRECINTERSYNCRSTypeList;
begin
  Result := FRECINTERSYNCRS;
end;

{ TXMLINTERTRNRSType }

procedure TXMLINTERTRNRSType.AfterConstruction;
begin
  RegisterChildNode('INTERRS', TXMLINTERRSType);
  RegisterChildNode('INTERMODRS', TXMLINTERMODRSType);
  RegisterChildNode('INTERCANRS', TXMLINTERCANRSType);
  inherited;
end;

function TXMLINTERTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLINTERTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLINTERTRNRSType.GetINTERRS: IXMLINTERRSType;
begin
  Result := ChildNodes['INTERRS'] as IXMLINTERRSType;
end;

function TXMLINTERTRNRSType.GetINTERMODRS: IXMLINTERMODRSType;
begin
  Result := ChildNodes['INTERMODRS'] as IXMLINTERMODRSType;
end;

function TXMLINTERTRNRSType.GetINTERCANRS: IXMLINTERCANRSType;
begin
  Result := ChildNodes['INTERCANRS'] as IXMLINTERCANRSType;
end;

{ TXMLINTERTRNRSTypeList }

function TXMLINTERTRNRSTypeList.Add: IXMLINTERTRNRSType;
begin
  Result := AddItem(-1) as IXMLINTERTRNRSType;
end;

function TXMLINTERTRNRSTypeList.Insert(const Index: Integer): IXMLINTERTRNRSType;
begin
  Result := AddItem(Index) as IXMLINTERTRNRSType;
end;

function TXMLINTERTRNRSTypeList.GetItem(Index: Integer): IXMLINTERTRNRSType;
begin
  Result := List[Index] as IXMLINTERTRNRSType;
end;

{ TXMLINTERRSType }

procedure TXMLINTERRSType.AfterConstruction;
begin
  RegisterChildNode('XFERINFO', TXMLXFERINFOType);
  RegisterChildNode('XFERPRCSTS', TXMLXFERPRCSTSType);
  inherited;
end;

function TXMLINTERRSType.GetCURDEF: UnicodeString;
begin
  Result := ChildNodes['CURDEF'].Text;
end;

procedure TXMLINTERRSType.SetCURDEF(Value: UnicodeString);
begin
  ChildNodes['CURDEF'].NodeValue := Value;
end;

function TXMLINTERRSType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLINTERRSType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

function TXMLINTERRSType.GetXFERINFO: IXMLXFERINFOType;
begin
  Result := ChildNodes['XFERINFO'] as IXMLXFERINFOType;
end;

function TXMLINTERRSType.GetDTXFERPRJ: UnicodeString;
begin
  Result := ChildNodes['DTXFERPRJ'].Text;
end;

procedure TXMLINTERRSType.SetDTXFERPRJ(Value: UnicodeString);
begin
  ChildNodes['DTXFERPRJ'].NodeValue := Value;
end;

function TXMLINTERRSType.GetDTPOSTED: UnicodeString;
begin
  Result := ChildNodes['DTPOSTED'].Text;
end;

procedure TXMLINTERRSType.SetDTPOSTED(Value: UnicodeString);
begin
  ChildNodes['DTPOSTED'].NodeValue := Value;
end;

function TXMLINTERRSType.GetREFNUM: UnicodeString;
begin
  Result := ChildNodes['REFNUM'].Text;
end;

procedure TXMLINTERRSType.SetREFNUM(Value: UnicodeString);
begin
  ChildNodes['REFNUM'].NodeValue := Value;
end;

function TXMLINTERRSType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLINTERRSType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

function TXMLINTERRSType.GetXFERPRCSTS: IXMLXFERPRCSTSType;
begin
  Result := ChildNodes['XFERPRCSTS'] as IXMLXFERPRCSTSType;
end;

{ TXMLINTERMODRSType }

procedure TXMLINTERMODRSType.AfterConstruction;
begin
  RegisterChildNode('XFERINFO', TXMLXFERINFOType);
  RegisterChildNode('XFERPRCSTS', TXMLXFERPRCSTSType);
  inherited;
end;

function TXMLINTERMODRSType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLINTERMODRSType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

function TXMLINTERMODRSType.GetXFERINFO: IXMLXFERINFOType;
begin
  Result := ChildNodes['XFERINFO'] as IXMLXFERINFOType;
end;

function TXMLINTERMODRSType.GetXFERPRCSTS: IXMLXFERPRCSTSType;
begin
  Result := ChildNodes['XFERPRCSTS'] as IXMLXFERPRCSTSType;
end;

{ TXMLINTERCANRSType }

function TXMLINTERCANRSType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLINTERCANRSType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

{ TXMLRECINTERTRNRSType }

procedure TXMLRECINTERTRNRSType.AfterConstruction;
begin
  RegisterChildNode('RECINTERRS', TXMLRECINTERRSType);
  RegisterChildNode('RECINTERMODRS', TXMLRECINTERMODRSType);
  RegisterChildNode('RECINTERCANRS', TXMLRECINTERCANRSType);
  inherited;
end;

function TXMLRECINTERTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLRECINTERTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLRECINTERTRNRSType.GetRECINTERRS: IXMLRECINTERRSType;
begin
  Result := ChildNodes['RECINTERRS'] as IXMLRECINTERRSType;
end;

function TXMLRECINTERTRNRSType.GetRECINTERMODRS: IXMLRECINTERMODRSType;
begin
  Result := ChildNodes['RECINTERMODRS'] as IXMLRECINTERMODRSType;
end;

function TXMLRECINTERTRNRSType.GetRECINTERCANRS: IXMLRECINTERCANRSType;
begin
  Result := ChildNodes['RECINTERCANRS'] as IXMLRECINTERCANRSType;
end;

{ TXMLRECINTERTRNRSTypeList }

function TXMLRECINTERTRNRSTypeList.Add: IXMLRECINTERTRNRSType;
begin
  Result := AddItem(-1) as IXMLRECINTERTRNRSType;
end;

function TXMLRECINTERTRNRSTypeList.Insert(const Index: Integer): IXMLRECINTERTRNRSType;
begin
  Result := AddItem(Index) as IXMLRECINTERTRNRSType;
end;

function TXMLRECINTERTRNRSTypeList.GetItem(Index: Integer): IXMLRECINTERTRNRSType;
begin
  Result := List[Index] as IXMLRECINTERTRNRSType;
end;

{ TXMLRECINTERRSType }

procedure TXMLRECINTERRSType.AfterConstruction;
begin
  RegisterChildNode('RECURRINST', TXMLRECURRINSTType);
  RegisterChildNode('INTERRS', TXMLINTERRSType);
  inherited;
end;

function TXMLRECINTERRSType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLRECINTERRSType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

function TXMLRECINTERRSType.GetRECURRINST: IXMLRECURRINSTType;
begin
  Result := ChildNodes['RECURRINST'] as IXMLRECURRINSTType;
end;

function TXMLRECINTERRSType.GetINTERRS: IXMLINTERRSType;
begin
  Result := ChildNodes['INTERRS'] as IXMLINTERRSType;
end;

{ TXMLRECINTERMODRSType }

procedure TXMLRECINTERMODRSType.AfterConstruction;
begin
  RegisterChildNode('RECURRINST', TXMLRECURRINSTType);
  RegisterChildNode('INTERRS', TXMLINTERRSType);
  inherited;
end;

function TXMLRECINTERMODRSType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLRECINTERMODRSType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

function TXMLRECINTERMODRSType.GetRECURRINST: IXMLRECURRINSTType;
begin
  Result := ChildNodes['RECURRINST'] as IXMLRECURRINSTType;
end;

function TXMLRECINTERMODRSType.GetINTERRS: IXMLINTERRSType;
begin
  Result := ChildNodes['INTERRS'] as IXMLINTERRSType;
end;

function TXMLRECINTERMODRSType.GetMODPENDING: UnicodeString;
begin
  Result := ChildNodes['MODPENDING'].Text;
end;

procedure TXMLRECINTERMODRSType.SetMODPENDING(Value: UnicodeString);
begin
  ChildNodes['MODPENDING'].NodeValue := Value;
end;

{ TXMLRECINTERCANRSType }

function TXMLRECINTERCANRSType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLRECINTERCANRSType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

function TXMLRECINTERCANRSType.GetCANPENDING: UnicodeString;
begin
  Result := ChildNodes['CANPENDING'].Text;
end;

procedure TXMLRECINTERCANRSType.SetCANPENDING(Value: UnicodeString);
begin
  ChildNodes['CANPENDING'].NodeValue := Value;
end;

{ TXMLINTERSYNCRSType }

procedure TXMLINTERSYNCRSType.AfterConstruction;
begin
  RegisterChildNode('INTERTRNRS', TXMLINTERTRNRSType);
  FINTERTRNRS := CreateCollection(TXMLINTERTRNRSTypeList, IXMLINTERTRNRSType, 'INTERTRNRS') as IXMLINTERTRNRSTypeList;
  inherited;
end;

function TXMLINTERSYNCRSType.GetSYNCRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRSMACRO'].Text;
end;

procedure TXMLINTERSYNCRSType.SetSYNCRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRSMACRO'].NodeValue := Value;
end;

function TXMLINTERSYNCRSType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLINTERSYNCRSType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLINTERSYNCRSType.GetINTERTRNRS: IXMLINTERTRNRSTypeList;
begin
  Result := FINTERTRNRS;
end;

{ TXMLINTERSYNCRSTypeList }

function TXMLINTERSYNCRSTypeList.Add: IXMLINTERSYNCRSType;
begin
  Result := AddItem(-1) as IXMLINTERSYNCRSType;
end;

function TXMLINTERSYNCRSTypeList.Insert(const Index: Integer): IXMLINTERSYNCRSType;
begin
  Result := AddItem(Index) as IXMLINTERSYNCRSType;
end;

function TXMLINTERSYNCRSTypeList.GetItem(Index: Integer): IXMLINTERSYNCRSType;
begin
  Result := List[Index] as IXMLINTERSYNCRSType;
end;

{ TXMLRECINTERSYNCRSType }

procedure TXMLRECINTERSYNCRSType.AfterConstruction;
begin
  RegisterChildNode('RECINTERTRNRS', TXMLRECINTERTRNRSType);
  FRECINTERTRNRS := CreateCollection(TXMLRECINTERTRNRSTypeList, IXMLRECINTERTRNRSType, 'RECINTERTRNRS') as IXMLRECINTERTRNRSTypeList;
  inherited;
end;

function TXMLRECINTERSYNCRSType.GetSYNCRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRSMACRO'].Text;
end;

procedure TXMLRECINTERSYNCRSType.SetSYNCRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRSMACRO'].NodeValue := Value;
end;

function TXMLRECINTERSYNCRSType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLRECINTERSYNCRSType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLRECINTERSYNCRSType.GetRECINTERTRNRS: IXMLRECINTERTRNRSTypeList;
begin
  Result := FRECINTERTRNRS;
end;

{ TXMLRECINTERSYNCRSTypeList }

function TXMLRECINTERSYNCRSTypeList.Add: IXMLRECINTERSYNCRSType;
begin
  Result := AddItem(-1) as IXMLRECINTERSYNCRSType;
end;

function TXMLRECINTERSYNCRSTypeList.Insert(const Index: Integer): IXMLRECINTERSYNCRSType;
begin
  Result := AddItem(Index) as IXMLRECINTERSYNCRSType;
end;

function TXMLRECINTERSYNCRSTypeList.GetItem(Index: Integer): IXMLRECINTERSYNCRSType;
begin
  Result := List[Index] as IXMLRECINTERSYNCRSType;
end;

{ TXMLWIREXFERMSGSRSV1Type }

procedure TXMLWIREXFERMSGSRSV1Type.AfterConstruction;
begin
  RegisterChildNode('WIRETRNRS', TXMLWIRETRNRSType);
  RegisterChildNode('WIRESYNCRS', TXMLWIRESYNCRSType);
  FWIRETRNRS := CreateCollection(TXMLWIRETRNRSTypeList, IXMLWIRETRNRSType, 'WIRETRNRS') as IXMLWIRETRNRSTypeList;
  FWIRESYNCRS := CreateCollection(TXMLWIRESYNCRSTypeList, IXMLWIRESYNCRSType, 'WIRESYNCRS') as IXMLWIRESYNCRSTypeList;
  inherited;
end;

function TXMLWIREXFERMSGSRSV1Type.GetWIRETRNRS: IXMLWIRETRNRSTypeList;
begin
  Result := FWIRETRNRS;
end;

function TXMLWIREXFERMSGSRSV1Type.GetWIRESYNCRS: IXMLWIRESYNCRSTypeList;
begin
  Result := FWIRESYNCRS;
end;

{ TXMLWIRETRNRSType }

procedure TXMLWIRETRNRSType.AfterConstruction;
begin
  RegisterChildNode('WIRERS', TXMLWIRERSType);
  RegisterChildNode('WIRECANRS', TXMLWIRECANRSType);
  inherited;
end;

function TXMLWIRETRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLWIRETRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLWIRETRNRSType.GetWIRERS: IXMLWIRERSType;
begin
  Result := ChildNodes['WIRERS'] as IXMLWIRERSType;
end;

function TXMLWIRETRNRSType.GetWIRECANRS: IXMLWIRECANRSType;
begin
  Result := ChildNodes['WIRECANRS'] as IXMLWIRECANRSType;
end;

{ TXMLWIRETRNRSTypeList }

function TXMLWIRETRNRSTypeList.Add: IXMLWIRETRNRSType;
begin
  Result := AddItem(-1) as IXMLWIRETRNRSType;
end;

function TXMLWIRETRNRSTypeList.Insert(const Index: Integer): IXMLWIRETRNRSType;
begin
  Result := AddItem(Index) as IXMLWIRETRNRSType;
end;

function TXMLWIRETRNRSTypeList.GetItem(Index: Integer): IXMLWIRETRNRSType;
begin
  Result := List[Index] as IXMLWIRETRNRSType;
end;

{ TXMLWIRERSType }

procedure TXMLWIRERSType.AfterConstruction;
begin
  RegisterChildNode('WIREBENEFICIARY', TXMLWIREBENEFICIARYType);
  RegisterChildNode('WIREDESTBANK', TXMLWIREDESTBANKType);
  inherited;
end;

function TXMLWIRERSType.GetCURDEF: UnicodeString;
begin
  Result := ChildNodes['CURDEF'].Text;
end;

procedure TXMLWIRERSType.SetCURDEF(Value: UnicodeString);
begin
  ChildNodes['CURDEF'].NodeValue := Value;
end;

function TXMLWIRERSType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLWIRERSType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

function TXMLWIRERSType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLWIRERSType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLWIRERSType.GetWIREBENEFICIARY: IXMLWIREBENEFICIARYType;
begin
  Result := ChildNodes['WIREBENEFICIARY'] as IXMLWIREBENEFICIARYType;
end;

function TXMLWIRERSType.GetWIREDESTBANK: IXMLWIREDESTBANKType;
begin
  Result := ChildNodes['WIREDESTBANK'] as IXMLWIREDESTBANKType;
end;

function TXMLWIRERSType.GetTRNAMT: UnicodeString;
begin
  Result := ChildNodes['TRNAMT'].Text;
end;

procedure TXMLWIRERSType.SetTRNAMT(Value: UnicodeString);
begin
  ChildNodes['TRNAMT'].NodeValue := Value;
end;

function TXMLWIRERSType.GetDTDUE: UnicodeString;
begin
  Result := ChildNodes['DTDUE'].Text;
end;

procedure TXMLWIRERSType.SetDTDUE(Value: UnicodeString);
begin
  ChildNodes['DTDUE'].NodeValue := Value;
end;

function TXMLWIRERSType.GetPAYINSTRUCT: UnicodeString;
begin
  Result := ChildNodes['PAYINSTRUCT'].Text;
end;

procedure TXMLWIRERSType.SetPAYINSTRUCT(Value: UnicodeString);
begin
  ChildNodes['PAYINSTRUCT'].NodeValue := Value;
end;

function TXMLWIRERSType.GetDTXFERPRJ: UnicodeString;
begin
  Result := ChildNodes['DTXFERPRJ'].Text;
end;

procedure TXMLWIRERSType.SetDTXFERPRJ(Value: UnicodeString);
begin
  ChildNodes['DTXFERPRJ'].NodeValue := Value;
end;

function TXMLWIRERSType.GetDTPOSTED: UnicodeString;
begin
  Result := ChildNodes['DTPOSTED'].Text;
end;

procedure TXMLWIRERSType.SetDTPOSTED(Value: UnicodeString);
begin
  ChildNodes['DTPOSTED'].NodeValue := Value;
end;

function TXMLWIRERSType.GetFEE: UnicodeString;
begin
  Result := ChildNodes['FEE'].Text;
end;

procedure TXMLWIRERSType.SetFEE(Value: UnicodeString);
begin
  ChildNodes['FEE'].NodeValue := Value;
end;

function TXMLWIRERSType.GetCONFMSG: UnicodeString;
begin
  Result := ChildNodes['CONFMSG'].Text;
end;

procedure TXMLWIRERSType.SetCONFMSG(Value: UnicodeString);
begin
  ChildNodes['CONFMSG'].NodeValue := Value;
end;

{ TXMLWIRECANRSType }

function TXMLWIRECANRSType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLWIRECANRSType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

{ TXMLWIRESYNCRSType }

procedure TXMLWIRESYNCRSType.AfterConstruction;
begin
  RegisterChildNode('WIRETRNRS', TXMLWIRETRNRSType);
  FWIRETRNRS := CreateCollection(TXMLWIRETRNRSTypeList, IXMLWIRETRNRSType, 'WIRETRNRS') as IXMLWIRETRNRSTypeList;
  inherited;
end;

function TXMLWIRESYNCRSType.GetSYNCRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRSMACRO'].Text;
end;

procedure TXMLWIRESYNCRSType.SetSYNCRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRSMACRO'].NodeValue := Value;
end;

function TXMLWIRESYNCRSType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLWIRESYNCRSType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLWIRESYNCRSType.GetWIRETRNRS: IXMLWIRETRNRSTypeList;
begin
  Result := FWIRETRNRS;
end;

{ TXMLWIRESYNCRSTypeList }

function TXMLWIRESYNCRSTypeList.Add: IXMLWIRESYNCRSType;
begin
  Result := AddItem(-1) as IXMLWIRESYNCRSType;
end;

function TXMLWIRESYNCRSTypeList.Insert(const Index: Integer): IXMLWIRESYNCRSType;
begin
  Result := AddItem(Index) as IXMLWIRESYNCRSType;
end;

function TXMLWIRESYNCRSTypeList.GetItem(Index: Integer): IXMLWIRESYNCRSType;
begin
  Result := List[Index] as IXMLWIRESYNCRSType;
end;

{ TXMLBANKACCTINFOType }

function TXMLBANKACCTINFOType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLBANKACCTINFOType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLBANKACCTINFOType.GetSUPTXDL: UnicodeString;
begin
  Result := ChildNodes['SUPTXDL'].Text;
end;

procedure TXMLBANKACCTINFOType.SetSUPTXDL(Value: UnicodeString);
begin
  ChildNodes['SUPTXDL'].NodeValue := Value;
end;

function TXMLBANKACCTINFOType.GetXFERSRC: UnicodeString;
begin
  Result := ChildNodes['XFERSRC'].Text;
end;

procedure TXMLBANKACCTINFOType.SetXFERSRC(Value: UnicodeString);
begin
  ChildNodes['XFERSRC'].NodeValue := Value;
end;

function TXMLBANKACCTINFOType.GetXFERDEST: UnicodeString;
begin
  Result := ChildNodes['XFERDEST'].Text;
end;

procedure TXMLBANKACCTINFOType.SetXFERDEST(Value: UnicodeString);
begin
  ChildNodes['XFERDEST'].NodeValue := Value;
end;

function TXMLBANKACCTINFOType.GetSVCSTATUS: UnicodeString;
begin
  Result := ChildNodes['SVCSTATUS'].Text;
end;

procedure TXMLBANKACCTINFOType.SetSVCSTATUS(Value: UnicodeString);
begin
  ChildNodes['SVCSTATUS'].NodeValue := Value;
end;

{ TXMLCCACCTINFOType }

function TXMLCCACCTINFOType.GetCCACCTFROM: UnicodeString;
begin
  Result := ChildNodes['CCACCTFROM'].Text;
end;

procedure TXMLCCACCTINFOType.SetCCACCTFROM(Value: UnicodeString);
begin
  ChildNodes['CCACCTFROM'].NodeValue := Value;
end;

function TXMLCCACCTINFOType.GetSUPTXDL: UnicodeString;
begin
  Result := ChildNodes['SUPTXDL'].Text;
end;

procedure TXMLCCACCTINFOType.SetSUPTXDL(Value: UnicodeString);
begin
  ChildNodes['SUPTXDL'].NodeValue := Value;
end;

function TXMLCCACCTINFOType.GetXFERSRC: UnicodeString;
begin
  Result := ChildNodes['XFERSRC'].Text;
end;

procedure TXMLCCACCTINFOType.SetXFERSRC(Value: UnicodeString);
begin
  ChildNodes['XFERSRC'].NodeValue := Value;
end;

function TXMLCCACCTINFOType.GetXFERDEST: UnicodeString;
begin
  Result := ChildNodes['XFERDEST'].Text;
end;

procedure TXMLCCACCTINFOType.SetXFERDEST(Value: UnicodeString);
begin
  ChildNodes['XFERDEST'].NodeValue := Value;
end;

function TXMLCCACCTINFOType.GetSVCSTATUS: UnicodeString;
begin
  Result := ChildNodes['SVCSTATUS'].Text;
end;

procedure TXMLCCACCTINFOType.SetSVCSTATUS(Value: UnicodeString);
begin
  ChildNodes['SVCSTATUS'].NodeValue := Value;
end;

{ TXMLBILLPAYMSGSRQV1Type }

procedure TXMLBILLPAYMSGSRQV1Type.AfterConstruction;
begin
  RegisterChildNode('PAYEETRNRQ', TXMLPAYEETRNRQType);
  RegisterChildNode('PAYEESYNCRQ', TXMLPAYEESYNCRQType);
  RegisterChildNode('PMTTRNRQ', TXMLPMTTRNRQType);
  RegisterChildNode('RECPMTTRNRQ', TXMLRECPMTTRNRQType);
  RegisterChildNode('PMTINQTRNRQ', TXMLPMTINQTRNRQType);
  RegisterChildNode('PMTMAILTRNRQ', TXMLPMTMAILTRNRQType);
  RegisterChildNode('PMTSYNCRQ', TXMLPMTSYNCRQType);
  RegisterChildNode('RECPMTSYNCRQ', TXMLRECPMTSYNCRQType);
  RegisterChildNode('PMTMAILSYNCRQ', TXMLPMTMAILSYNCRQType);
  FPAYEETRNRQ := CreateCollection(TXMLPAYEETRNRQTypeList, IXMLPAYEETRNRQType, 'PAYEETRNRQ') as IXMLPAYEETRNRQTypeList;
  FPAYEESYNCRQ := CreateCollection(TXMLPAYEESYNCRQTypeList, IXMLPAYEESYNCRQType, 'PAYEESYNCRQ') as IXMLPAYEESYNCRQTypeList;
  FPMTTRNRQ := CreateCollection(TXMLPMTTRNRQTypeList, IXMLPMTTRNRQType, 'PMTTRNRQ') as IXMLPMTTRNRQTypeList;
  FRECPMTTRNRQ := CreateCollection(TXMLRECPMTTRNRQTypeList, IXMLRECPMTTRNRQType, 'RECPMTTRNRQ') as IXMLRECPMTTRNRQTypeList;
  FPMTINQTRNRQ := CreateCollection(TXMLPMTINQTRNRQTypeList, IXMLPMTINQTRNRQType, 'PMTINQTRNRQ') as IXMLPMTINQTRNRQTypeList;
  FPMTMAILTRNRQ := CreateCollection(TXMLPMTMAILTRNRQTypeList, IXMLPMTMAILTRNRQType, 'PMTMAILTRNRQ') as IXMLPMTMAILTRNRQTypeList;
  FPMTSYNCRQ := CreateCollection(TXMLPMTSYNCRQTypeList, IXMLPMTSYNCRQType, 'PMTSYNCRQ') as IXMLPMTSYNCRQTypeList;
  FRECPMTSYNCRQ := CreateCollection(TXMLRECPMTSYNCRQTypeList, IXMLRECPMTSYNCRQType, 'RECPMTSYNCRQ') as IXMLRECPMTSYNCRQTypeList;
  FPMTMAILSYNCRQ := CreateCollection(TXMLPMTMAILSYNCRQTypeList, IXMLPMTMAILSYNCRQType, 'PMTMAILSYNCRQ') as IXMLPMTMAILSYNCRQTypeList;
  inherited;
end;

function TXMLBILLPAYMSGSRQV1Type.GetPAYEETRNRQ: IXMLPAYEETRNRQTypeList;
begin
  Result := FPAYEETRNRQ;
end;

function TXMLBILLPAYMSGSRQV1Type.GetPAYEESYNCRQ: IXMLPAYEESYNCRQTypeList;
begin
  Result := FPAYEESYNCRQ;
end;

function TXMLBILLPAYMSGSRQV1Type.GetPMTTRNRQ: IXMLPMTTRNRQTypeList;
begin
  Result := FPMTTRNRQ;
end;

function TXMLBILLPAYMSGSRQV1Type.GetRECPMTTRNRQ: IXMLRECPMTTRNRQTypeList;
begin
  Result := FRECPMTTRNRQ;
end;

function TXMLBILLPAYMSGSRQV1Type.GetPMTINQTRNRQ: IXMLPMTINQTRNRQTypeList;
begin
  Result := FPMTINQTRNRQ;
end;

function TXMLBILLPAYMSGSRQV1Type.GetPMTMAILTRNRQ: IXMLPMTMAILTRNRQTypeList;
begin
  Result := FPMTMAILTRNRQ;
end;

function TXMLBILLPAYMSGSRQV1Type.GetPMTSYNCRQ: IXMLPMTSYNCRQTypeList;
begin
  Result := FPMTSYNCRQ;
end;

function TXMLBILLPAYMSGSRQV1Type.GetRECPMTSYNCRQ: IXMLRECPMTSYNCRQTypeList;
begin
  Result := FRECPMTSYNCRQ;
end;

function TXMLBILLPAYMSGSRQV1Type.GetPMTMAILSYNCRQ: IXMLPMTMAILSYNCRQTypeList;
begin
  Result := FPMTMAILSYNCRQ;
end;

{ TXMLPAYEETRNRQType }

procedure TXMLPAYEETRNRQType.AfterConstruction;
begin
  RegisterChildNode('PAYEERQ', TXMLPAYEERQType);
  RegisterChildNode('PAYEEMODRQ', TXMLPAYEEMODRQType);
  RegisterChildNode('PAYEEDELRQ', TXMLPAYEEDELRQType);
  inherited;
end;

function TXMLPAYEETRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLPAYEETRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLPAYEETRNRQType.GetPAYEERQ: IXMLPAYEERQType;
begin
  Result := ChildNodes['PAYEERQ'] as IXMLPAYEERQType;
end;

function TXMLPAYEETRNRQType.GetPAYEEMODRQ: IXMLPAYEEMODRQType;
begin
  Result := ChildNodes['PAYEEMODRQ'] as IXMLPAYEEMODRQType;
end;

function TXMLPAYEETRNRQType.GetPAYEEDELRQ: IXMLPAYEEDELRQType;
begin
  Result := ChildNodes['PAYEEDELRQ'] as IXMLPAYEEDELRQType;
end;

{ TXMLPAYEETRNRQTypeList }

function TXMLPAYEETRNRQTypeList.Add: IXMLPAYEETRNRQType;
begin
  Result := AddItem(-1) as IXMLPAYEETRNRQType;
end;

function TXMLPAYEETRNRQTypeList.Insert(const Index: Integer): IXMLPAYEETRNRQType;
begin
  Result := AddItem(Index) as IXMLPAYEETRNRQType;
end;

function TXMLPAYEETRNRQTypeList.GetItem(Index: Integer): IXMLPAYEETRNRQType;
begin
  Result := List[Index] as IXMLPAYEETRNRQType;
end;

{ TXMLPAYEERQType }

procedure TXMLPAYEERQType.AfterConstruction;
begin
  RegisterChildNode('PAYEE', TXMLPAYEEType);
  FPAYACCT := CreateCollection(TXMLString_List, IXMLNode, 'PAYACCT') as IXMLString_List;
  inherited;
end;

function TXMLPAYEERQType.GetPAYEEID: UnicodeString;
begin
  Result := ChildNodes['PAYEEID'].Text;
end;

procedure TXMLPAYEERQType.SetPAYEEID(Value: UnicodeString);
begin
  ChildNodes['PAYEEID'].NodeValue := Value;
end;

function TXMLPAYEERQType.GetPAYEE: IXMLPAYEEType;
begin
  Result := ChildNodes['PAYEE'] as IXMLPAYEEType;
end;

function TXMLPAYEERQType.GetBANKACCTTO: UnicodeString;
begin
  Result := ChildNodes['BANKACCTTO'].Text;
end;

procedure TXMLPAYEERQType.SetBANKACCTTO(Value: UnicodeString);
begin
  ChildNodes['BANKACCTTO'].NodeValue := Value;
end;

function TXMLPAYEERQType.GetPAYACCT: IXMLString_List;
begin
  Result := FPAYACCT;
end;

{ TXMLPAYEEMODRQType }

procedure TXMLPAYEEMODRQType.AfterConstruction;
begin
  RegisterChildNode('PAYEE', TXMLPAYEEType);
  FPAYACCT := CreateCollection(TXMLString_List, IXMLNode, 'PAYACCT') as IXMLString_List;
  inherited;
end;

function TXMLPAYEEMODRQType.GetPAYEELSTID: UnicodeString;
begin
  Result := ChildNodes['PAYEELSTID'].Text;
end;

procedure TXMLPAYEEMODRQType.SetPAYEELSTID(Value: UnicodeString);
begin
  ChildNodes['PAYEELSTID'].NodeValue := Value;
end;

function TXMLPAYEEMODRQType.GetPAYEE: IXMLPAYEEType;
begin
  Result := ChildNodes['PAYEE'] as IXMLPAYEEType;
end;

function TXMLPAYEEMODRQType.GetBANKACCTTO: UnicodeString;
begin
  Result := ChildNodes['BANKACCTTO'].Text;
end;

procedure TXMLPAYEEMODRQType.SetBANKACCTTO(Value: UnicodeString);
begin
  ChildNodes['BANKACCTTO'].NodeValue := Value;
end;

function TXMLPAYEEMODRQType.GetPAYACCT: IXMLString_List;
begin
  Result := FPAYACCT;
end;

{ TXMLPAYEEDELRQType }

function TXMLPAYEEDELRQType.GetPAYEELSTID: UnicodeString;
begin
  Result := ChildNodes['PAYEELSTID'].Text;
end;

procedure TXMLPAYEEDELRQType.SetPAYEELSTID(Value: UnicodeString);
begin
  ChildNodes['PAYEELSTID'].NodeValue := Value;
end;

{ TXMLPAYEESYNCRQType }

procedure TXMLPAYEESYNCRQType.AfterConstruction;
begin
  RegisterChildNode('PAYEETRNRQ', TXMLPAYEETRNRQType);
  FPAYEETRNRQ := CreateCollection(TXMLPAYEETRNRQTypeList, IXMLPAYEETRNRQType, 'PAYEETRNRQ') as IXMLPAYEETRNRQTypeList;
  inherited;
end;

function TXMLPAYEESYNCRQType.GetSYNCRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRQMACRO'].Text;
end;

procedure TXMLPAYEESYNCRQType.SetSYNCRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRQMACRO'].NodeValue := Value;
end;

function TXMLPAYEESYNCRQType.GetPAYEETRNRQ: IXMLPAYEETRNRQTypeList;
begin
  Result := FPAYEETRNRQ;
end;

{ TXMLPAYEESYNCRQTypeList }

function TXMLPAYEESYNCRQTypeList.Add: IXMLPAYEESYNCRQType;
begin
  Result := AddItem(-1) as IXMLPAYEESYNCRQType;
end;

function TXMLPAYEESYNCRQTypeList.Insert(const Index: Integer): IXMLPAYEESYNCRQType;
begin
  Result := AddItem(Index) as IXMLPAYEESYNCRQType;
end;

function TXMLPAYEESYNCRQTypeList.GetItem(Index: Integer): IXMLPAYEESYNCRQType;
begin
  Result := List[Index] as IXMLPAYEESYNCRQType;
end;

{ TXMLPMTTRNRQType }

procedure TXMLPMTTRNRQType.AfterConstruction;
begin
  RegisterChildNode('PMTRQ', TXMLPMTRQType);
  RegisterChildNode('PMTMODRQ', TXMLPMTMODRQType);
  RegisterChildNode('PMTCANCRQ', TXMLPMTCANCRQType);
  inherited;
end;

function TXMLPMTTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLPMTTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLPMTTRNRQType.GetPMTRQ: IXMLPMTRQType;
begin
  Result := ChildNodes['PMTRQ'] as IXMLPMTRQType;
end;

function TXMLPMTTRNRQType.GetPMTMODRQ: IXMLPMTMODRQType;
begin
  Result := ChildNodes['PMTMODRQ'] as IXMLPMTMODRQType;
end;

function TXMLPMTTRNRQType.GetPMTCANCRQ: IXMLPMTCANCRQType;
begin
  Result := ChildNodes['PMTCANCRQ'] as IXMLPMTCANCRQType;
end;

{ TXMLPMTTRNRQTypeList }

function TXMLPMTTRNRQTypeList.Add: IXMLPMTTRNRQType;
begin
  Result := AddItem(-1) as IXMLPMTTRNRQType;
end;

function TXMLPMTTRNRQTypeList.Insert(const Index: Integer): IXMLPMTTRNRQType;
begin
  Result := AddItem(Index) as IXMLPMTTRNRQType;
end;

function TXMLPMTTRNRQTypeList.GetItem(Index: Integer): IXMLPMTTRNRQType;
begin
  Result := List[Index] as IXMLPMTTRNRQType;
end;

{ TXMLPMTRQType }

procedure TXMLPMTRQType.AfterConstruction;
begin
  RegisterChildNode('PMTINFO', TXMLPMTINFOType);
  inherited;
end;

function TXMLPMTRQType.GetPMTINFO: IXMLPMTINFOType;
begin
  Result := ChildNodes['PMTINFO'] as IXMLPMTINFOType;
end;

{ TXMLPMTINFOType }

procedure TXMLPMTINFOType.AfterConstruction;
begin
  RegisterChildNode('PAYEE', TXMLPAYEEType);
  RegisterChildNode('EXTDPMT', TXMLEXTDPMTType);
  FEXTDPMT := CreateCollection(TXMLEXTDPMTTypeList, IXMLEXTDPMTType, 'EXTDPMT') as IXMLEXTDPMTTypeList;
  inherited;
end;

function TXMLPMTINFOType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLPMTINFOType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLPMTINFOType.GetTRNAMT: UnicodeString;
begin
  Result := ChildNodes['TRNAMT'].Text;
end;

procedure TXMLPMTINFOType.SetTRNAMT(Value: UnicodeString);
begin
  ChildNodes['TRNAMT'].NodeValue := Value;
end;

function TXMLPMTINFOType.GetPAYEEID: UnicodeString;
begin
  Result := ChildNodes['PAYEEID'].Text;
end;

procedure TXMLPMTINFOType.SetPAYEEID(Value: UnicodeString);
begin
  ChildNodes['PAYEEID'].NodeValue := Value;
end;

function TXMLPMTINFOType.GetPAYEE: IXMLPAYEEType;
begin
  Result := ChildNodes['PAYEE'] as IXMLPAYEEType;
end;

function TXMLPMTINFOType.GetPAYEELSTID: UnicodeString;
begin
  Result := ChildNodes['PAYEELSTID'].Text;
end;

procedure TXMLPMTINFOType.SetPAYEELSTID(Value: UnicodeString);
begin
  ChildNodes['PAYEELSTID'].NodeValue := Value;
end;

function TXMLPMTINFOType.GetBANKACCTTO: UnicodeString;
begin
  Result := ChildNodes['BANKACCTTO'].Text;
end;

procedure TXMLPMTINFOType.SetBANKACCTTO(Value: UnicodeString);
begin
  ChildNodes['BANKACCTTO'].NodeValue := Value;
end;

function TXMLPMTINFOType.GetEXTDPMT: IXMLEXTDPMTTypeList;
begin
  Result := FEXTDPMT;
end;

function TXMLPMTINFOType.GetPAYACCT: UnicodeString;
begin
  Result := ChildNodes['PAYACCT'].Text;
end;

procedure TXMLPMTINFOType.SetPAYACCT(Value: UnicodeString);
begin
  ChildNodes['PAYACCT'].NodeValue := Value;
end;

function TXMLPMTINFOType.GetDTDUE: UnicodeString;
begin
  Result := ChildNodes['DTDUE'].Text;
end;

procedure TXMLPMTINFOType.SetDTDUE(Value: UnicodeString);
begin
  ChildNodes['DTDUE'].NodeValue := Value;
end;

function TXMLPMTINFOType.GetMEMO: UnicodeString;
begin
  Result := ChildNodes['MEMO'].Text;
end;

procedure TXMLPMTINFOType.SetMEMO(Value: UnicodeString);
begin
  ChildNodes['MEMO'].NodeValue := Value;
end;

function TXMLPMTINFOType.GetBILLREFINFO: UnicodeString;
begin
  Result := ChildNodes['BILLREFINFO'].Text;
end;

procedure TXMLPMTINFOType.SetBILLREFINFO(Value: UnicodeString);
begin
  ChildNodes['BILLREFINFO'].NodeValue := Value;
end;

{ TXMLEXTDPMTType }

procedure TXMLEXTDPMTType.AfterConstruction;
begin
  RegisterChildNode('EXTDPMTINV', TXMLEXTDPMTINVType);
  inherited;
end;

function TXMLEXTDPMTType.GetEXTDPMTFOR: UnicodeString;
begin
  Result := ChildNodes['EXTDPMTFOR'].Text;
end;

procedure TXMLEXTDPMTType.SetEXTDPMTFOR(Value: UnicodeString);
begin
  ChildNodes['EXTDPMTFOR'].NodeValue := Value;
end;

function TXMLEXTDPMTType.GetEXTDPMTCHK: UnicodeString;
begin
  Result := ChildNodes['EXTDPMTCHK'].Text;
end;

procedure TXMLEXTDPMTType.SetEXTDPMTCHK(Value: UnicodeString);
begin
  ChildNodes['EXTDPMTCHK'].NodeValue := Value;
end;

function TXMLEXTDPMTType.GetEXTDPMTDSC: UnicodeString;
begin
  Result := ChildNodes['EXTDPMTDSC'].Text;
end;

procedure TXMLEXTDPMTType.SetEXTDPMTDSC(Value: UnicodeString);
begin
  ChildNodes['EXTDPMTDSC'].NodeValue := Value;
end;

function TXMLEXTDPMTType.GetEXTDPMTINV: IXMLEXTDPMTINVType;
begin
  Result := ChildNodes['EXTDPMTINV'] as IXMLEXTDPMTINVType;
end;

{ TXMLEXTDPMTTypeList }

function TXMLEXTDPMTTypeList.Add: IXMLEXTDPMTType;
begin
  Result := AddItem(-1) as IXMLEXTDPMTType;
end;

function TXMLEXTDPMTTypeList.Insert(const Index: Integer): IXMLEXTDPMTType;
begin
  Result := AddItem(Index) as IXMLEXTDPMTType;
end;

function TXMLEXTDPMTTypeList.GetItem(Index: Integer): IXMLEXTDPMTType;
begin
  Result := List[Index] as IXMLEXTDPMTType;
end;

{ TXMLEXTDPMTINVType }

procedure TXMLEXTDPMTINVType.AfterConstruction;
begin
  RegisterChildNode('INVOICE', TXMLINVOICEType);
  ItemTag := 'INVOICE';
  ItemInterface := IXMLINVOICEType;
  inherited;
end;

function TXMLEXTDPMTINVType.GetINVOICE(Index: Integer): IXMLINVOICEType;
begin
  Result := List[Index] as IXMLINVOICEType;
end;

function TXMLEXTDPMTINVType.Add: IXMLINVOICEType;
begin
  Result := AddItem(-1) as IXMLINVOICEType;
end;

function TXMLEXTDPMTINVType.Insert(const Index: Integer): IXMLINVOICEType;
begin
  Result := AddItem(Index) as IXMLINVOICEType;
end;

{ TXMLINVOICEType }

procedure TXMLINVOICEType.AfterConstruction;
begin
  RegisterChildNode('DISCOUNT', TXMLDISCOUNTType);
  RegisterChildNode('ADJUSTMENT', TXMLADJUSTMENTType);
  RegisterChildNode('LINEITEM', TXMLLINEITEMType);
  FLINEITEM := CreateCollection(TXMLLINEITEMTypeList, IXMLLINEITEMType, 'LINEITEM') as IXMLLINEITEMTypeList;
  inherited;
end;

function TXMLINVOICEType.GetINVNO: UnicodeString;
begin
  Result := ChildNodes['INVNO'].Text;
end;

procedure TXMLINVOICEType.SetINVNO(Value: UnicodeString);
begin
  ChildNodes['INVNO'].NodeValue := Value;
end;

function TXMLINVOICEType.GetINVTOTALAMT: UnicodeString;
begin
  Result := ChildNodes['INVTOTALAMT'].Text;
end;

procedure TXMLINVOICEType.SetINVTOTALAMT(Value: UnicodeString);
begin
  ChildNodes['INVTOTALAMT'].NodeValue := Value;
end;

function TXMLINVOICEType.GetINVPAIDAMT: UnicodeString;
begin
  Result := ChildNodes['INVPAIDAMT'].Text;
end;

procedure TXMLINVOICEType.SetINVPAIDAMT(Value: UnicodeString);
begin
  ChildNodes['INVPAIDAMT'].NodeValue := Value;
end;

function TXMLINVOICEType.GetINVDATE: UnicodeString;
begin
  Result := ChildNodes['INVDATE'].Text;
end;

procedure TXMLINVOICEType.SetINVDATE(Value: UnicodeString);
begin
  ChildNodes['INVDATE'].NodeValue := Value;
end;

function TXMLINVOICEType.GetINVDESC: UnicodeString;
begin
  Result := ChildNodes['INVDESC'].Text;
end;

procedure TXMLINVOICEType.SetINVDESC(Value: UnicodeString);
begin
  ChildNodes['INVDESC'].NodeValue := Value;
end;

function TXMLINVOICEType.GetDISCOUNT: IXMLDISCOUNTType;
begin
  Result := ChildNodes['DISCOUNT'] as IXMLDISCOUNTType;
end;

function TXMLINVOICEType.GetADJUSTMENT: IXMLADJUSTMENTType;
begin
  Result := ChildNodes['ADJUSTMENT'] as IXMLADJUSTMENTType;
end;

function TXMLINVOICEType.GetLINEITEM: IXMLLINEITEMTypeList;
begin
  Result := FLINEITEM;
end;

{ TXMLDISCOUNTType }

function TXMLDISCOUNTType.GetDSCRATE: UnicodeString;
begin
  Result := ChildNodes['DSCRATE'].Text;
end;

procedure TXMLDISCOUNTType.SetDSCRATE(Value: UnicodeString);
begin
  ChildNodes['DSCRATE'].NodeValue := Value;
end;

function TXMLDISCOUNTType.GetDSCAMT: UnicodeString;
begin
  Result := ChildNodes['DSCAMT'].Text;
end;

procedure TXMLDISCOUNTType.SetDSCAMT(Value: UnicodeString);
begin
  ChildNodes['DSCAMT'].NodeValue := Value;
end;

function TXMLDISCOUNTType.GetDSCDATE: UnicodeString;
begin
  Result := ChildNodes['DSCDATE'].Text;
end;

procedure TXMLDISCOUNTType.SetDSCDATE(Value: UnicodeString);
begin
  ChildNodes['DSCDATE'].NodeValue := Value;
end;

function TXMLDISCOUNTType.GetDSCDESC: UnicodeString;
begin
  Result := ChildNodes['DSCDESC'].Text;
end;

procedure TXMLDISCOUNTType.SetDSCDESC(Value: UnicodeString);
begin
  ChildNodes['DSCDESC'].NodeValue := Value;
end;

{ TXMLADJUSTMENTType }

function TXMLADJUSTMENTType.GetADJNO: UnicodeString;
begin
  Result := ChildNodes['ADJNO'].Text;
end;

procedure TXMLADJUSTMENTType.SetADJNO(Value: UnicodeString);
begin
  ChildNodes['ADJNO'].NodeValue := Value;
end;

function TXMLADJUSTMENTType.GetADJDESC: UnicodeString;
begin
  Result := ChildNodes['ADJDESC'].Text;
end;

procedure TXMLADJUSTMENTType.SetADJDESC(Value: UnicodeString);
begin
  ChildNodes['ADJDESC'].NodeValue := Value;
end;

function TXMLADJUSTMENTType.GetADJAMT: UnicodeString;
begin
  Result := ChildNodes['ADJAMT'].Text;
end;

procedure TXMLADJUSTMENTType.SetADJAMT(Value: UnicodeString);
begin
  ChildNodes['ADJAMT'].NodeValue := Value;
end;

function TXMLADJUSTMENTType.GetADJDATE: UnicodeString;
begin
  Result := ChildNodes['ADJDATE'].Text;
end;

procedure TXMLADJUSTMENTType.SetADJDATE(Value: UnicodeString);
begin
  ChildNodes['ADJDATE'].NodeValue := Value;
end;

{ TXMLLINEITEMType }

function TXMLLINEITEMType.GetLITMAMT: UnicodeString;
begin
  Result := ChildNodes['LITMAMT'].Text;
end;

procedure TXMLLINEITEMType.SetLITMAMT(Value: UnicodeString);
begin
  ChildNodes['LITMAMT'].NodeValue := Value;
end;

function TXMLLINEITEMType.GetLITMDESC: UnicodeString;
begin
  Result := ChildNodes['LITMDESC'].Text;
end;

procedure TXMLLINEITEMType.SetLITMDESC(Value: UnicodeString);
begin
  ChildNodes['LITMDESC'].NodeValue := Value;
end;

{ TXMLLINEITEMTypeList }

function TXMLLINEITEMTypeList.Add: IXMLLINEITEMType;
begin
  Result := AddItem(-1) as IXMLLINEITEMType;
end;

function TXMLLINEITEMTypeList.Insert(const Index: Integer): IXMLLINEITEMType;
begin
  Result := AddItem(Index) as IXMLLINEITEMType;
end;

function TXMLLINEITEMTypeList.GetItem(Index: Integer): IXMLLINEITEMType;
begin
  Result := List[Index] as IXMLLINEITEMType;
end;

{ TXMLPMTMODRQType }

procedure TXMLPMTMODRQType.AfterConstruction;
begin
  RegisterChildNode('PMTINFO', TXMLPMTINFOType);
  inherited;
end;

function TXMLPMTMODRQType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLPMTMODRQType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

function TXMLPMTMODRQType.GetPMTINFO: IXMLPMTINFOType;
begin
  Result := ChildNodes['PMTINFO'] as IXMLPMTINFOType;
end;

{ TXMLPMTCANCRQType }

function TXMLPMTCANCRQType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLPMTCANCRQType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

{ TXMLRECPMTTRNRQType }

procedure TXMLRECPMTTRNRQType.AfterConstruction;
begin
  RegisterChildNode('RECPMTRQ', TXMLRECPMTRQType);
  RegisterChildNode('RECPMTMODRQ', TXMLRECPMTMODRQType);
  RegisterChildNode('RECPMTCANCRQ', TXMLRECPMTCANCRQType);
  inherited;
end;

function TXMLRECPMTTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLRECPMTTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLRECPMTTRNRQType.GetRECPMTRQ: IXMLRECPMTRQType;
begin
  Result := ChildNodes['RECPMTRQ'] as IXMLRECPMTRQType;
end;

function TXMLRECPMTTRNRQType.GetRECPMTMODRQ: IXMLRECPMTMODRQType;
begin
  Result := ChildNodes['RECPMTMODRQ'] as IXMLRECPMTMODRQType;
end;

function TXMLRECPMTTRNRQType.GetRECPMTCANCRQ: IXMLRECPMTCANCRQType;
begin
  Result := ChildNodes['RECPMTCANCRQ'] as IXMLRECPMTCANCRQType;
end;

{ TXMLRECPMTTRNRQTypeList }

function TXMLRECPMTTRNRQTypeList.Add: IXMLRECPMTTRNRQType;
begin
  Result := AddItem(-1) as IXMLRECPMTTRNRQType;
end;

function TXMLRECPMTTRNRQTypeList.Insert(const Index: Integer): IXMLRECPMTTRNRQType;
begin
  Result := AddItem(Index) as IXMLRECPMTTRNRQType;
end;

function TXMLRECPMTTRNRQTypeList.GetItem(Index: Integer): IXMLRECPMTTRNRQType;
begin
  Result := List[Index] as IXMLRECPMTTRNRQType;
end;

{ TXMLRECPMTRQType }

procedure TXMLRECPMTRQType.AfterConstruction;
begin
  RegisterChildNode('RECURRINST', TXMLRECURRINSTType);
  RegisterChildNode('PMTINFO', TXMLPMTINFOType);
  inherited;
end;

function TXMLRECPMTRQType.GetRECURRINST: IXMLRECURRINSTType;
begin
  Result := ChildNodes['RECURRINST'] as IXMLRECURRINSTType;
end;

function TXMLRECPMTRQType.GetPMTINFO: IXMLPMTINFOType;
begin
  Result := ChildNodes['PMTINFO'] as IXMLPMTINFOType;
end;

function TXMLRECPMTRQType.GetINITIALAMT: UnicodeString;
begin
  Result := ChildNodes['INITIALAMT'].Text;
end;

procedure TXMLRECPMTRQType.SetINITIALAMT(Value: UnicodeString);
begin
  ChildNodes['INITIALAMT'].NodeValue := Value;
end;

function TXMLRECPMTRQType.GetFINALAMT: UnicodeString;
begin
  Result := ChildNodes['FINALAMT'].Text;
end;

procedure TXMLRECPMTRQType.SetFINALAMT(Value: UnicodeString);
begin
  ChildNodes['FINALAMT'].NodeValue := Value;
end;

{ TXMLRECPMTMODRQType }

procedure TXMLRECPMTMODRQType.AfterConstruction;
begin
  RegisterChildNode('RECURRINST', TXMLRECURRINSTType);
  RegisterChildNode('PMTINFO', TXMLPMTINFOType);
  inherited;
end;

function TXMLRECPMTMODRQType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLRECPMTMODRQType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

function TXMLRECPMTMODRQType.GetRECURRINST: IXMLRECURRINSTType;
begin
  Result := ChildNodes['RECURRINST'] as IXMLRECURRINSTType;
end;

function TXMLRECPMTMODRQType.GetPMTINFO: IXMLPMTINFOType;
begin
  Result := ChildNodes['PMTINFO'] as IXMLPMTINFOType;
end;

function TXMLRECPMTMODRQType.GetINITIALAMT: UnicodeString;
begin
  Result := ChildNodes['INITIALAMT'].Text;
end;

procedure TXMLRECPMTMODRQType.SetINITIALAMT(Value: UnicodeString);
begin
  ChildNodes['INITIALAMT'].NodeValue := Value;
end;

function TXMLRECPMTMODRQType.GetFINALAMT: UnicodeString;
begin
  Result := ChildNodes['FINALAMT'].Text;
end;

procedure TXMLRECPMTMODRQType.SetFINALAMT(Value: UnicodeString);
begin
  ChildNodes['FINALAMT'].NodeValue := Value;
end;

function TXMLRECPMTMODRQType.GetMODPENDING: UnicodeString;
begin
  Result := ChildNodes['MODPENDING'].Text;
end;

procedure TXMLRECPMTMODRQType.SetMODPENDING(Value: UnicodeString);
begin
  ChildNodes['MODPENDING'].NodeValue := Value;
end;

{ TXMLRECPMTCANCRQType }

function TXMLRECPMTCANCRQType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLRECPMTCANCRQType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

function TXMLRECPMTCANCRQType.GetCANPENDING: UnicodeString;
begin
  Result := ChildNodes['CANPENDING'].Text;
end;

procedure TXMLRECPMTCANCRQType.SetCANPENDING(Value: UnicodeString);
begin
  ChildNodes['CANPENDING'].NodeValue := Value;
end;

{ TXMLPMTINQTRNRQType }

procedure TXMLPMTINQTRNRQType.AfterConstruction;
begin
  RegisterChildNode('PMTINQRQ', TXMLPMTINQRQType);
  inherited;
end;

function TXMLPMTINQTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLPMTINQTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLPMTINQTRNRQType.GetPMTINQRQ: IXMLPMTINQRQType;
begin
  Result := ChildNodes['PMTINQRQ'] as IXMLPMTINQRQType;
end;

{ TXMLPMTINQTRNRQTypeList }

function TXMLPMTINQTRNRQTypeList.Add: IXMLPMTINQTRNRQType;
begin
  Result := AddItem(-1) as IXMLPMTINQTRNRQType;
end;

function TXMLPMTINQTRNRQTypeList.Insert(const Index: Integer): IXMLPMTINQTRNRQType;
begin
  Result := AddItem(Index) as IXMLPMTINQTRNRQType;
end;

function TXMLPMTINQTRNRQTypeList.GetItem(Index: Integer): IXMLPMTINQTRNRQType;
begin
  Result := List[Index] as IXMLPMTINQTRNRQType;
end;

{ TXMLPMTINQRQType }

function TXMLPMTINQRQType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLPMTINQRQType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

{ TXMLPMTMAILTRNRQType }

procedure TXMLPMTMAILTRNRQType.AfterConstruction;
begin
  RegisterChildNode('PMTMAILRQ', TXMLPMTMAILRQType);
  inherited;
end;

function TXMLPMTMAILTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLPMTMAILTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLPMTMAILTRNRQType.GetPMTMAILRQ: IXMLPMTMAILRQType;
begin
  Result := ChildNodes['PMTMAILRQ'] as IXMLPMTMAILRQType;
end;

{ TXMLPMTMAILTRNRQTypeList }

function TXMLPMTMAILTRNRQTypeList.Add: IXMLPMTMAILTRNRQType;
begin
  Result := AddItem(-1) as IXMLPMTMAILTRNRQType;
end;

function TXMLPMTMAILTRNRQTypeList.Insert(const Index: Integer): IXMLPMTMAILTRNRQType;
begin
  Result := AddItem(Index) as IXMLPMTMAILTRNRQType;
end;

function TXMLPMTMAILTRNRQTypeList.GetItem(Index: Integer): IXMLPMTMAILTRNRQType;
begin
  Result := List[Index] as IXMLPMTMAILTRNRQType;
end;

{ TXMLPMTMAILRQType }

procedure TXMLPMTMAILRQType.AfterConstruction;
begin
  RegisterChildNode('MAIL', TXMLMAILType);
  RegisterChildNode('PMTINFO', TXMLPMTINFOType);
  inherited;
end;

function TXMLPMTMAILRQType.GetMAIL: IXMLMAILType;
begin
  Result := ChildNodes['MAIL'] as IXMLMAILType;
end;

function TXMLPMTMAILRQType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLPMTMAILRQType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

function TXMLPMTMAILRQType.GetPMTINFO: IXMLPMTINFOType;
begin
  Result := ChildNodes['PMTINFO'] as IXMLPMTINFOType;
end;

{ TXMLPMTSYNCRQType }

procedure TXMLPMTSYNCRQType.AfterConstruction;
begin
  RegisterChildNode('PMTTRNRQ', TXMLPMTTRNRQType);
  FPMTTRNRQ := CreateCollection(TXMLPMTTRNRQTypeList, IXMLPMTTRNRQType, 'PMTTRNRQ') as IXMLPMTTRNRQTypeList;
  inherited;
end;

function TXMLPMTSYNCRQType.GetSYNCRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRQMACRO'].Text;
end;

procedure TXMLPMTSYNCRQType.SetSYNCRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRQMACRO'].NodeValue := Value;
end;

function TXMLPMTSYNCRQType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLPMTSYNCRQType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLPMTSYNCRQType.GetPMTTRNRQ: IXMLPMTTRNRQTypeList;
begin
  Result := FPMTTRNRQ;
end;

{ TXMLPMTSYNCRQTypeList }

function TXMLPMTSYNCRQTypeList.Add: IXMLPMTSYNCRQType;
begin
  Result := AddItem(-1) as IXMLPMTSYNCRQType;
end;

function TXMLPMTSYNCRQTypeList.Insert(const Index: Integer): IXMLPMTSYNCRQType;
begin
  Result := AddItem(Index) as IXMLPMTSYNCRQType;
end;

function TXMLPMTSYNCRQTypeList.GetItem(Index: Integer): IXMLPMTSYNCRQType;
begin
  Result := List[Index] as IXMLPMTSYNCRQType;
end;

{ TXMLRECPMTSYNCRQType }

procedure TXMLRECPMTSYNCRQType.AfterConstruction;
begin
  RegisterChildNode('RECPMTTRNRQ', TXMLRECPMTTRNRQType);
  FRECPMTTRNRQ := CreateCollection(TXMLRECPMTTRNRQTypeList, IXMLRECPMTTRNRQType, 'RECPMTTRNRQ') as IXMLRECPMTTRNRQTypeList;
  inherited;
end;

function TXMLRECPMTSYNCRQType.GetSYNCRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRQMACRO'].Text;
end;

procedure TXMLRECPMTSYNCRQType.SetSYNCRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRQMACRO'].NodeValue := Value;
end;

function TXMLRECPMTSYNCRQType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLRECPMTSYNCRQType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLRECPMTSYNCRQType.GetRECPMTTRNRQ: IXMLRECPMTTRNRQTypeList;
begin
  Result := FRECPMTTRNRQ;
end;

{ TXMLRECPMTSYNCRQTypeList }

function TXMLRECPMTSYNCRQTypeList.Add: IXMLRECPMTSYNCRQType;
begin
  Result := AddItem(-1) as IXMLRECPMTSYNCRQType;
end;

function TXMLRECPMTSYNCRQTypeList.Insert(const Index: Integer): IXMLRECPMTSYNCRQType;
begin
  Result := AddItem(Index) as IXMLRECPMTSYNCRQType;
end;

function TXMLRECPMTSYNCRQTypeList.GetItem(Index: Integer): IXMLRECPMTSYNCRQType;
begin
  Result := List[Index] as IXMLRECPMTSYNCRQType;
end;

{ TXMLPMTMAILSYNCRQType }

procedure TXMLPMTMAILSYNCRQType.AfterConstruction;
begin
  RegisterChildNode('PMTMAILTRNRQ', TXMLPMTMAILTRNRQType);
  FPMTMAILTRNRQ := CreateCollection(TXMLPMTMAILTRNRQTypeList, IXMLPMTMAILTRNRQType, 'PMTMAILTRNRQ') as IXMLPMTMAILTRNRQTypeList;
  inherited;
end;

function TXMLPMTMAILSYNCRQType.GetSYNCRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRQMACRO'].Text;
end;

procedure TXMLPMTMAILSYNCRQType.SetSYNCRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRQMACRO'].NodeValue := Value;
end;

function TXMLPMTMAILSYNCRQType.GetINCIMAGES: UnicodeString;
begin
  Result := ChildNodes['INCIMAGES'].Text;
end;

procedure TXMLPMTMAILSYNCRQType.SetINCIMAGES(Value: UnicodeString);
begin
  ChildNodes['INCIMAGES'].NodeValue := Value;
end;

function TXMLPMTMAILSYNCRQType.GetUSEHTML: UnicodeString;
begin
  Result := ChildNodes['USEHTML'].Text;
end;

procedure TXMLPMTMAILSYNCRQType.SetUSEHTML(Value: UnicodeString);
begin
  ChildNodes['USEHTML'].NodeValue := Value;
end;

function TXMLPMTMAILSYNCRQType.GetPMTMAILTRNRQ: IXMLPMTMAILTRNRQTypeList;
begin
  Result := FPMTMAILTRNRQ;
end;

{ TXMLPMTMAILSYNCRQTypeList }

function TXMLPMTMAILSYNCRQTypeList.Add: IXMLPMTMAILSYNCRQType;
begin
  Result := AddItem(-1) as IXMLPMTMAILSYNCRQType;
end;

function TXMLPMTMAILSYNCRQTypeList.Insert(const Index: Integer): IXMLPMTMAILSYNCRQType;
begin
  Result := AddItem(Index) as IXMLPMTMAILSYNCRQType;
end;

function TXMLPMTMAILSYNCRQTypeList.GetItem(Index: Integer): IXMLPMTMAILSYNCRQType;
begin
  Result := List[Index] as IXMLPMTMAILSYNCRQType;
end;

{ TXMLBILLPAYMSGSRSV1Type }

procedure TXMLBILLPAYMSGSRSV1Type.AfterConstruction;
begin
  RegisterChildNode('PAYEETRNRS', TXMLPAYEETRNRSType);
  RegisterChildNode('PAYEESYNCRS', TXMLPAYEESYNCRSType);
  RegisterChildNode('PMTTRNRS', TXMLPMTTRNRSType);
  RegisterChildNode('RECPMTTRNRS', TXMLRECPMTTRNRSType);
  RegisterChildNode('PMTINQTRNRS', TXMLPMTINQTRNRSType);
  RegisterChildNode('PMTMAILTRNRS', TXMLPMTMAILTRNRSType);
  RegisterChildNode('PMTSYNCRS', TXMLPMTSYNCRSType);
  RegisterChildNode('RECPMTSYNCRS', TXMLRECPMTSYNCRSType);
  RegisterChildNode('PMTMAILSYNCRS', TXMLPMTMAILSYNCRSType);
  FPAYEETRNRS := CreateCollection(TXMLPAYEETRNRSTypeList, IXMLPAYEETRNRSType, 'PAYEETRNRS') as IXMLPAYEETRNRSTypeList;
  FPAYEESYNCRS := CreateCollection(TXMLPAYEESYNCRSTypeList, IXMLPAYEESYNCRSType, 'PAYEESYNCRS') as IXMLPAYEESYNCRSTypeList;
  FPMTTRNRS := CreateCollection(TXMLPMTTRNRSTypeList, IXMLPMTTRNRSType, 'PMTTRNRS') as IXMLPMTTRNRSTypeList;
  FRECPMTTRNRS := CreateCollection(TXMLRECPMTTRNRSTypeList, IXMLRECPMTTRNRSType, 'RECPMTTRNRS') as IXMLRECPMTTRNRSTypeList;
  FPMTINQTRNRS := CreateCollection(TXMLPMTINQTRNRSTypeList, IXMLPMTINQTRNRSType, 'PMTINQTRNRS') as IXMLPMTINQTRNRSTypeList;
  FPMTMAILTRNRS := CreateCollection(TXMLPMTMAILTRNRSTypeList, IXMLPMTMAILTRNRSType, 'PMTMAILTRNRS') as IXMLPMTMAILTRNRSTypeList;
  FPMTSYNCRS := CreateCollection(TXMLPMTSYNCRSTypeList, IXMLPMTSYNCRSType, 'PMTSYNCRS') as IXMLPMTSYNCRSTypeList;
  FRECPMTSYNCRS := CreateCollection(TXMLRECPMTSYNCRSTypeList, IXMLRECPMTSYNCRSType, 'RECPMTSYNCRS') as IXMLRECPMTSYNCRSTypeList;
  FPMTMAILSYNCRS := CreateCollection(TXMLPMTMAILSYNCRSTypeList, IXMLPMTMAILSYNCRSType, 'PMTMAILSYNCRS') as IXMLPMTMAILSYNCRSTypeList;
  inherited;
end;

function TXMLBILLPAYMSGSRSV1Type.GetPAYEETRNRS: IXMLPAYEETRNRSTypeList;
begin
  Result := FPAYEETRNRS;
end;

function TXMLBILLPAYMSGSRSV1Type.GetPAYEESYNCRS: IXMLPAYEESYNCRSTypeList;
begin
  Result := FPAYEESYNCRS;
end;

function TXMLBILLPAYMSGSRSV1Type.GetPMTTRNRS: IXMLPMTTRNRSTypeList;
begin
  Result := FPMTTRNRS;
end;

function TXMLBILLPAYMSGSRSV1Type.GetRECPMTTRNRS: IXMLRECPMTTRNRSTypeList;
begin
  Result := FRECPMTTRNRS;
end;

function TXMLBILLPAYMSGSRSV1Type.GetPMTINQTRNRS: IXMLPMTINQTRNRSTypeList;
begin
  Result := FPMTINQTRNRS;
end;

function TXMLBILLPAYMSGSRSV1Type.GetPMTMAILTRNRS: IXMLPMTMAILTRNRSTypeList;
begin
  Result := FPMTMAILTRNRS;
end;

function TXMLBILLPAYMSGSRSV1Type.GetPMTSYNCRS: IXMLPMTSYNCRSTypeList;
begin
  Result := FPMTSYNCRS;
end;

function TXMLBILLPAYMSGSRSV1Type.GetRECPMTSYNCRS: IXMLRECPMTSYNCRSTypeList;
begin
  Result := FRECPMTSYNCRS;
end;

function TXMLBILLPAYMSGSRSV1Type.GetPMTMAILSYNCRS: IXMLPMTMAILSYNCRSTypeList;
begin
  Result := FPMTMAILSYNCRS;
end;

{ TXMLPAYEETRNRSType }

procedure TXMLPAYEETRNRSType.AfterConstruction;
begin
  RegisterChildNode('PAYEERS', TXMLPAYEERSType);
  RegisterChildNode('PAYEEMODRS', TXMLPAYEEMODRSType);
  RegisterChildNode('PAYEEDELRS', TXMLPAYEEDELRSType);
  inherited;
end;

function TXMLPAYEETRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLPAYEETRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLPAYEETRNRSType.GetPAYEERS: IXMLPAYEERSType;
begin
  Result := ChildNodes['PAYEERS'] as IXMLPAYEERSType;
end;

function TXMLPAYEETRNRSType.GetPAYEEMODRS: IXMLPAYEEMODRSType;
begin
  Result := ChildNodes['PAYEEMODRS'] as IXMLPAYEEMODRSType;
end;

function TXMLPAYEETRNRSType.GetPAYEEDELRS: IXMLPAYEEDELRSType;
begin
  Result := ChildNodes['PAYEEDELRS'] as IXMLPAYEEDELRSType;
end;

{ TXMLPAYEETRNRSTypeList }

function TXMLPAYEETRNRSTypeList.Add: IXMLPAYEETRNRSType;
begin
  Result := AddItem(-1) as IXMLPAYEETRNRSType;
end;

function TXMLPAYEETRNRSTypeList.Insert(const Index: Integer): IXMLPAYEETRNRSType;
begin
  Result := AddItem(Index) as IXMLPAYEETRNRSType;
end;

function TXMLPAYEETRNRSTypeList.GetItem(Index: Integer): IXMLPAYEETRNRSType;
begin
  Result := List[Index] as IXMLPAYEETRNRSType;
end;

{ TXMLPAYEERSType }

procedure TXMLPAYEERSType.AfterConstruction;
begin
  RegisterChildNode('PAYEE', TXMLPAYEEType);
  RegisterChildNode('EXTDPAYEE', TXMLEXTDPAYEEType);
  FPAYACCT := CreateCollection(TXMLString_List, IXMLNode, 'PAYACCT') as IXMLString_List;
  inherited;
end;

function TXMLPAYEERSType.GetPAYEELSTID: UnicodeString;
begin
  Result := ChildNodes['PAYEELSTID'].Text;
end;

procedure TXMLPAYEERSType.SetPAYEELSTID(Value: UnicodeString);
begin
  ChildNodes['PAYEELSTID'].NodeValue := Value;
end;

function TXMLPAYEERSType.GetPAYEE: IXMLPAYEEType;
begin
  Result := ChildNodes['PAYEE'] as IXMLPAYEEType;
end;

function TXMLPAYEERSType.GetBANKACCTTO: UnicodeString;
begin
  Result := ChildNodes['BANKACCTTO'].Text;
end;

procedure TXMLPAYEERSType.SetBANKACCTTO(Value: UnicodeString);
begin
  ChildNodes['BANKACCTTO'].NodeValue := Value;
end;

function TXMLPAYEERSType.GetEXTDPAYEE: IXMLEXTDPAYEEType;
begin
  Result := ChildNodes['EXTDPAYEE'] as IXMLEXTDPAYEEType;
end;

function TXMLPAYEERSType.GetPAYACCT: IXMLString_List;
begin
  Result := FPAYACCT;
end;

{ TXMLEXTDPAYEEType }

function TXMLEXTDPAYEEType.GetPAYEEID: UnicodeString;
begin
  Result := ChildNodes['PAYEEID'].Text;
end;

procedure TXMLEXTDPAYEEType.SetPAYEEID(Value: UnicodeString);
begin
  ChildNodes['PAYEEID'].NodeValue := Value;
end;

function TXMLEXTDPAYEEType.GetIDSCOPE: UnicodeString;
begin
  Result := ChildNodes['IDSCOPE'].Text;
end;

procedure TXMLEXTDPAYEEType.SetIDSCOPE(Value: UnicodeString);
begin
  ChildNodes['IDSCOPE'].NodeValue := Value;
end;

function TXMLEXTDPAYEEType.GetNAME: UnicodeString;
begin
  Result := ChildNodes['NAME'].Text;
end;

procedure TXMLEXTDPAYEEType.SetNAME(Value: UnicodeString);
begin
  ChildNodes['NAME'].NodeValue := Value;
end;

function TXMLEXTDPAYEEType.GetDAYSTOPAY: UnicodeString;
begin
  Result := ChildNodes['DAYSTOPAY'].Text;
end;

procedure TXMLEXTDPAYEEType.SetDAYSTOPAY(Value: UnicodeString);
begin
  ChildNodes['DAYSTOPAY'].NodeValue := Value;
end;

{ TXMLPAYEEMODRSType }

procedure TXMLPAYEEMODRSType.AfterConstruction;
begin
  RegisterChildNode('PAYEE', TXMLPAYEEType);
  RegisterChildNode('EXTDPAYEE', TXMLEXTDPAYEEType);
  FPAYACCT := CreateCollection(TXMLString_List, IXMLNode, 'PAYACCT') as IXMLString_List;
  inherited;
end;

function TXMLPAYEEMODRSType.GetPAYEELSTID: UnicodeString;
begin
  Result := ChildNodes['PAYEELSTID'].Text;
end;

procedure TXMLPAYEEMODRSType.SetPAYEELSTID(Value: UnicodeString);
begin
  ChildNodes['PAYEELSTID'].NodeValue := Value;
end;

function TXMLPAYEEMODRSType.GetPAYEE: IXMLPAYEEType;
begin
  Result := ChildNodes['PAYEE'] as IXMLPAYEEType;
end;

function TXMLPAYEEMODRSType.GetBANKACCTTO: UnicodeString;
begin
  Result := ChildNodes['BANKACCTTO'].Text;
end;

procedure TXMLPAYEEMODRSType.SetBANKACCTTO(Value: UnicodeString);
begin
  ChildNodes['BANKACCTTO'].NodeValue := Value;
end;

function TXMLPAYEEMODRSType.GetPAYACCT: IXMLString_List;
begin
  Result := FPAYACCT;
end;

function TXMLPAYEEMODRSType.GetEXTDPAYEE: IXMLEXTDPAYEEType;
begin
  Result := ChildNodes['EXTDPAYEE'] as IXMLEXTDPAYEEType;
end;

{ TXMLPAYEEDELRSType }

function TXMLPAYEEDELRSType.GetPAYEELSTID: UnicodeString;
begin
  Result := ChildNodes['PAYEELSTID'].Text;
end;

procedure TXMLPAYEEDELRSType.SetPAYEELSTID(Value: UnicodeString);
begin
  ChildNodes['PAYEELSTID'].NodeValue := Value;
end;

{ TXMLPAYEESYNCRSType }

procedure TXMLPAYEESYNCRSType.AfterConstruction;
begin
  RegisterChildNode('PAYEETRNRS', TXMLPAYEETRNRSType);
  FPAYEETRNRS := CreateCollection(TXMLPAYEETRNRSTypeList, IXMLPAYEETRNRSType, 'PAYEETRNRS') as IXMLPAYEETRNRSTypeList;
  inherited;
end;

function TXMLPAYEESYNCRSType.GetSYNCRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRSMACRO'].Text;
end;

procedure TXMLPAYEESYNCRSType.SetSYNCRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRSMACRO'].NodeValue := Value;
end;

function TXMLPAYEESYNCRSType.GetPAYEETRNRS: IXMLPAYEETRNRSTypeList;
begin
  Result := FPAYEETRNRS;
end;

{ TXMLPAYEESYNCRSTypeList }

function TXMLPAYEESYNCRSTypeList.Add: IXMLPAYEESYNCRSType;
begin
  Result := AddItem(-1) as IXMLPAYEESYNCRSType;
end;

function TXMLPAYEESYNCRSTypeList.Insert(const Index: Integer): IXMLPAYEESYNCRSType;
begin
  Result := AddItem(Index) as IXMLPAYEESYNCRSType;
end;

function TXMLPAYEESYNCRSTypeList.GetItem(Index: Integer): IXMLPAYEESYNCRSType;
begin
  Result := List[Index] as IXMLPAYEESYNCRSType;
end;

{ TXMLPMTTRNRSType }

procedure TXMLPMTTRNRSType.AfterConstruction;
begin
  RegisterChildNode('PMTRS', TXMLPMTRSType);
  RegisterChildNode('PMTMODRS', TXMLPMTMODRSType);
  RegisterChildNode('PMTCANCRS', TXMLPMTCANCRSType);
  inherited;
end;

function TXMLPMTTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLPMTTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLPMTTRNRSType.GetPMTRS: IXMLPMTRSType;
begin
  Result := ChildNodes['PMTRS'] as IXMLPMTRSType;
end;

function TXMLPMTTRNRSType.GetPMTMODRS: IXMLPMTMODRSType;
begin
  Result := ChildNodes['PMTMODRS'] as IXMLPMTMODRSType;
end;

function TXMLPMTTRNRSType.GetPMTCANCRS: IXMLPMTCANCRSType;
begin
  Result := ChildNodes['PMTCANCRS'] as IXMLPMTCANCRSType;
end;

{ TXMLPMTTRNRSTypeList }

function TXMLPMTTRNRSTypeList.Add: IXMLPMTTRNRSType;
begin
  Result := AddItem(-1) as IXMLPMTTRNRSType;
end;

function TXMLPMTTRNRSTypeList.Insert(const Index: Integer): IXMLPMTTRNRSType;
begin
  Result := AddItem(Index) as IXMLPMTTRNRSType;
end;

function TXMLPMTTRNRSTypeList.GetItem(Index: Integer): IXMLPMTTRNRSType;
begin
  Result := List[Index] as IXMLPMTTRNRSType;
end;

{ TXMLPMTRSType }

procedure TXMLPMTRSType.AfterConstruction;
begin
  RegisterChildNode('PMTINFO', TXMLPMTINFOType);
  RegisterChildNode('EXTDPAYEE', TXMLEXTDPAYEEType);
  RegisterChildNode('PMTPRCSTS', TXMLPMTPRCSTSType);
  inherited;
end;

function TXMLPMTRSType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLPMTRSType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

function TXMLPMTRSType.GetPAYEELSTID: UnicodeString;
begin
  Result := ChildNodes['PAYEELSTID'].Text;
end;

procedure TXMLPMTRSType.SetPAYEELSTID(Value: UnicodeString);
begin
  ChildNodes['PAYEELSTID'].NodeValue := Value;
end;

function TXMLPMTRSType.GetCURDEF: UnicodeString;
begin
  Result := ChildNodes['CURDEF'].Text;
end;

procedure TXMLPMTRSType.SetCURDEF(Value: UnicodeString);
begin
  ChildNodes['CURDEF'].NodeValue := Value;
end;

function TXMLPMTRSType.GetPMTINFO: IXMLPMTINFOType;
begin
  Result := ChildNodes['PMTINFO'] as IXMLPMTINFOType;
end;

function TXMLPMTRSType.GetEXTDPAYEE: IXMLEXTDPAYEEType;
begin
  Result := ChildNodes['EXTDPAYEE'] as IXMLEXTDPAYEEType;
end;

function TXMLPMTRSType.GetCHECKNUM: UnicodeString;
begin
  Result := ChildNodes['CHECKNUM'].Text;
end;

procedure TXMLPMTRSType.SetCHECKNUM(Value: UnicodeString);
begin
  ChildNodes['CHECKNUM'].NodeValue := Value;
end;

function TXMLPMTRSType.GetPMTPRCSTS: IXMLPMTPRCSTSType;
begin
  Result := ChildNodes['PMTPRCSTS'] as IXMLPMTPRCSTSType;
end;

function TXMLPMTRSType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLPMTRSType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

{ TXMLPMTPRCSTSType }

function TXMLPMTPRCSTSType.GetPMTPRCCODE: UnicodeString;
begin
  Result := ChildNodes['PMTPRCCODE'].Text;
end;

procedure TXMLPMTPRCSTSType.SetPMTPRCCODE(Value: UnicodeString);
begin
  ChildNodes['PMTPRCCODE'].NodeValue := Value;
end;

function TXMLPMTPRCSTSType.GetDTPMTPRC: UnicodeString;
begin
  Result := ChildNodes['DTPMTPRC'].Text;
end;

procedure TXMLPMTPRCSTSType.SetDTPMTPRC(Value: UnicodeString);
begin
  ChildNodes['DTPMTPRC'].NodeValue := Value;
end;

{ TXMLPMTMODRSType }

procedure TXMLPMTMODRSType.AfterConstruction;
begin
  RegisterChildNode('PMTINFO', TXMLPMTINFOType);
  RegisterChildNode('PMTPRCSTS', TXMLPMTPRCSTSType);
  inherited;
end;

function TXMLPMTMODRSType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLPMTMODRSType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

function TXMLPMTMODRSType.GetPMTINFO: IXMLPMTINFOType;
begin
  Result := ChildNodes['PMTINFO'] as IXMLPMTINFOType;
end;

function TXMLPMTMODRSType.GetPMTPRCSTS: IXMLPMTPRCSTSType;
begin
  Result := ChildNodes['PMTPRCSTS'] as IXMLPMTPRCSTSType;
end;

{ TXMLPMTCANCRSType }

function TXMLPMTCANCRSType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLPMTCANCRSType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

{ TXMLRECPMTTRNRSType }

procedure TXMLRECPMTTRNRSType.AfterConstruction;
begin
  RegisterChildNode('RECPMTRS', TXMLRECPMTRSType);
  RegisterChildNode('RECPMTMODRS', TXMLRECPMTMODRSType);
  RegisterChildNode('RECPMTCANCRS', TXMLRECPMTCANCRSType);
  inherited;
end;

function TXMLRECPMTTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLRECPMTTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLRECPMTTRNRSType.GetRECPMTRS: IXMLRECPMTRSType;
begin
  Result := ChildNodes['RECPMTRS'] as IXMLRECPMTRSType;
end;

function TXMLRECPMTTRNRSType.GetRECPMTMODRS: IXMLRECPMTMODRSType;
begin
  Result := ChildNodes['RECPMTMODRS'] as IXMLRECPMTMODRSType;
end;

function TXMLRECPMTTRNRSType.GetRECPMTCANCRS: IXMLRECPMTCANCRSType;
begin
  Result := ChildNodes['RECPMTCANCRS'] as IXMLRECPMTCANCRSType;
end;

{ TXMLRECPMTTRNRSTypeList }

function TXMLRECPMTTRNRSTypeList.Add: IXMLRECPMTTRNRSType;
begin
  Result := AddItem(-1) as IXMLRECPMTTRNRSType;
end;

function TXMLRECPMTTRNRSTypeList.Insert(const Index: Integer): IXMLRECPMTTRNRSType;
begin
  Result := AddItem(Index) as IXMLRECPMTTRNRSType;
end;

function TXMLRECPMTTRNRSTypeList.GetItem(Index: Integer): IXMLRECPMTTRNRSType;
begin
  Result := List[Index] as IXMLRECPMTTRNRSType;
end;

{ TXMLRECPMTRSType }

procedure TXMLRECPMTRSType.AfterConstruction;
begin
  RegisterChildNode('RECURRINST', TXMLRECURRINSTType);
  RegisterChildNode('PMTINFO', TXMLPMTINFOType);
  RegisterChildNode('EXTDPAYEE', TXMLEXTDPAYEEType);
  inherited;
end;

function TXMLRECPMTRSType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLRECPMTRSType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

function TXMLRECPMTRSType.GetPAYEELSTID: UnicodeString;
begin
  Result := ChildNodes['PAYEELSTID'].Text;
end;

procedure TXMLRECPMTRSType.SetPAYEELSTID(Value: UnicodeString);
begin
  ChildNodes['PAYEELSTID'].NodeValue := Value;
end;

function TXMLRECPMTRSType.GetCURDEF: UnicodeString;
begin
  Result := ChildNodes['CURDEF'].Text;
end;

procedure TXMLRECPMTRSType.SetCURDEF(Value: UnicodeString);
begin
  ChildNodes['CURDEF'].NodeValue := Value;
end;

function TXMLRECPMTRSType.GetRECURRINST: IXMLRECURRINSTType;
begin
  Result := ChildNodes['RECURRINST'] as IXMLRECURRINSTType;
end;

function TXMLRECPMTRSType.GetPMTINFO: IXMLPMTINFOType;
begin
  Result := ChildNodes['PMTINFO'] as IXMLPMTINFOType;
end;

function TXMLRECPMTRSType.GetINITIALAMT: UnicodeString;
begin
  Result := ChildNodes['INITIALAMT'].Text;
end;

procedure TXMLRECPMTRSType.SetINITIALAMT(Value: UnicodeString);
begin
  ChildNodes['INITIALAMT'].NodeValue := Value;
end;

function TXMLRECPMTRSType.GetFINALAMT: UnicodeString;
begin
  Result := ChildNodes['FINALAMT'].Text;
end;

procedure TXMLRECPMTRSType.SetFINALAMT(Value: UnicodeString);
begin
  ChildNodes['FINALAMT'].NodeValue := Value;
end;

function TXMLRECPMTRSType.GetEXTDPAYEE: IXMLEXTDPAYEEType;
begin
  Result := ChildNodes['EXTDPAYEE'] as IXMLEXTDPAYEEType;
end;

{ TXMLRECPMTMODRSType }

procedure TXMLRECPMTMODRSType.AfterConstruction;
begin
  RegisterChildNode('RECURRINST', TXMLRECURRINSTType);
  RegisterChildNode('PMTINFO', TXMLPMTINFOType);
  inherited;
end;

function TXMLRECPMTMODRSType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLRECPMTMODRSType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

function TXMLRECPMTMODRSType.GetRECURRINST: IXMLRECURRINSTType;
begin
  Result := ChildNodes['RECURRINST'] as IXMLRECURRINSTType;
end;

function TXMLRECPMTMODRSType.GetPMTINFO: IXMLPMTINFOType;
begin
  Result := ChildNodes['PMTINFO'] as IXMLPMTINFOType;
end;

function TXMLRECPMTMODRSType.GetINITIALAMT: UnicodeString;
begin
  Result := ChildNodes['INITIALAMT'].Text;
end;

procedure TXMLRECPMTMODRSType.SetINITIALAMT(Value: UnicodeString);
begin
  ChildNodes['INITIALAMT'].NodeValue := Value;
end;

function TXMLRECPMTMODRSType.GetFINALAMT: UnicodeString;
begin
  Result := ChildNodes['FINALAMT'].Text;
end;

procedure TXMLRECPMTMODRSType.SetFINALAMT(Value: UnicodeString);
begin
  ChildNodes['FINALAMT'].NodeValue := Value;
end;

function TXMLRECPMTMODRSType.GetMODPENDING: UnicodeString;
begin
  Result := ChildNodes['MODPENDING'].Text;
end;

procedure TXMLRECPMTMODRSType.SetMODPENDING(Value: UnicodeString);
begin
  ChildNodes['MODPENDING'].NodeValue := Value;
end;

{ TXMLRECPMTCANCRSType }

function TXMLRECPMTCANCRSType.GetRECSRVRTID: UnicodeString;
begin
  Result := ChildNodes['RECSRVRTID'].Text;
end;

procedure TXMLRECPMTCANCRSType.SetRECSRVRTID(Value: UnicodeString);
begin
  ChildNodes['RECSRVRTID'].NodeValue := Value;
end;

function TXMLRECPMTCANCRSType.GetCANPENDING: UnicodeString;
begin
  Result := ChildNodes['CANPENDING'].Text;
end;

procedure TXMLRECPMTCANCRSType.SetCANPENDING(Value: UnicodeString);
begin
  ChildNodes['CANPENDING'].NodeValue := Value;
end;

{ TXMLPMTINQTRNRSType }

procedure TXMLPMTINQTRNRSType.AfterConstruction;
begin
  RegisterChildNode('PMTINQRS', TXMLPMTINQRSType);
  inherited;
end;

function TXMLPMTINQTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLPMTINQTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLPMTINQTRNRSType.GetPMTINQRS: IXMLPMTINQRSType;
begin
  Result := ChildNodes['PMTINQRS'] as IXMLPMTINQRSType;
end;

{ TXMLPMTINQTRNRSTypeList }

function TXMLPMTINQTRNRSTypeList.Add: IXMLPMTINQTRNRSType;
begin
  Result := AddItem(-1) as IXMLPMTINQTRNRSType;
end;

function TXMLPMTINQTRNRSTypeList.Insert(const Index: Integer): IXMLPMTINQTRNRSType;
begin
  Result := AddItem(Index) as IXMLPMTINQTRNRSType;
end;

function TXMLPMTINQTRNRSTypeList.GetItem(Index: Integer): IXMLPMTINQTRNRSType;
begin
  Result := List[Index] as IXMLPMTINQTRNRSType;
end;

{ TXMLPMTINQRSType }

procedure TXMLPMTINQRSType.AfterConstruction;
begin
  RegisterChildNode('PMTPRCSTS', TXMLPMTPRCSTSType);
  inherited;
end;

function TXMLPMTINQRSType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLPMTINQRSType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

function TXMLPMTINQRSType.GetPMTPRCSTS: IXMLPMTPRCSTSType;
begin
  Result := ChildNodes['PMTPRCSTS'] as IXMLPMTPRCSTSType;
end;

function TXMLPMTINQRSType.GetCHECKNUM: UnicodeString;
begin
  Result := ChildNodes['CHECKNUM'].Text;
end;

procedure TXMLPMTINQRSType.SetCHECKNUM(Value: UnicodeString);
begin
  ChildNodes['CHECKNUM'].NodeValue := Value;
end;

{ TXMLPMTMAILTRNRSType }

procedure TXMLPMTMAILTRNRSType.AfterConstruction;
begin
  RegisterChildNode('PMTMAILRS', TXMLPMTMAILRSType);
  inherited;
end;

function TXMLPMTMAILTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLPMTMAILTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLPMTMAILTRNRSType.GetPMTMAILRS: IXMLPMTMAILRSType;
begin
  Result := ChildNodes['PMTMAILRS'] as IXMLPMTMAILRSType;
end;

{ TXMLPMTMAILTRNRSTypeList }

function TXMLPMTMAILTRNRSTypeList.Add: IXMLPMTMAILTRNRSType;
begin
  Result := AddItem(-1) as IXMLPMTMAILTRNRSType;
end;

function TXMLPMTMAILTRNRSTypeList.Insert(const Index: Integer): IXMLPMTMAILTRNRSType;
begin
  Result := AddItem(Index) as IXMLPMTMAILTRNRSType;
end;

function TXMLPMTMAILTRNRSTypeList.GetItem(Index: Integer): IXMLPMTMAILTRNRSType;
begin
  Result := List[Index] as IXMLPMTMAILTRNRSType;
end;

{ TXMLPMTMAILRSType }

procedure TXMLPMTMAILRSType.AfterConstruction;
begin
  RegisterChildNode('MAIL', TXMLMAILType);
  RegisterChildNode('PMTINFO', TXMLPMTINFOType);
  inherited;
end;

function TXMLPMTMAILRSType.GetMAIL: IXMLMAILType;
begin
  Result := ChildNodes['MAIL'] as IXMLMAILType;
end;

function TXMLPMTMAILRSType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLPMTMAILRSType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

function TXMLPMTMAILRSType.GetPMTINFO: IXMLPMTINFOType;
begin
  Result := ChildNodes['PMTINFO'] as IXMLPMTINFOType;
end;

{ TXMLPMTSYNCRSType }

procedure TXMLPMTSYNCRSType.AfterConstruction;
begin
  RegisterChildNode('PMTTRNRS', TXMLPMTTRNRSType);
  FPMTTRNRS := CreateCollection(TXMLPMTTRNRSTypeList, IXMLPMTTRNRSType, 'PMTTRNRS') as IXMLPMTTRNRSTypeList;
  inherited;
end;

function TXMLPMTSYNCRSType.GetSYNCRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRSMACRO'].Text;
end;

procedure TXMLPMTSYNCRSType.SetSYNCRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRSMACRO'].NodeValue := Value;
end;

function TXMLPMTSYNCRSType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLPMTSYNCRSType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLPMTSYNCRSType.GetPMTTRNRS: IXMLPMTTRNRSTypeList;
begin
  Result := FPMTTRNRS;
end;

{ TXMLPMTSYNCRSTypeList }

function TXMLPMTSYNCRSTypeList.Add: IXMLPMTSYNCRSType;
begin
  Result := AddItem(-1) as IXMLPMTSYNCRSType;
end;

function TXMLPMTSYNCRSTypeList.Insert(const Index: Integer): IXMLPMTSYNCRSType;
begin
  Result := AddItem(Index) as IXMLPMTSYNCRSType;
end;

function TXMLPMTSYNCRSTypeList.GetItem(Index: Integer): IXMLPMTSYNCRSType;
begin
  Result := List[Index] as IXMLPMTSYNCRSType;
end;

{ TXMLRECPMTSYNCRSType }

procedure TXMLRECPMTSYNCRSType.AfterConstruction;
begin
  RegisterChildNode('RECPMTTRNRS', TXMLRECPMTTRNRSType);
  FRECPMTTRNRS := CreateCollection(TXMLRECPMTTRNRSTypeList, IXMLRECPMTTRNRSType, 'RECPMTTRNRS') as IXMLRECPMTTRNRSTypeList;
  inherited;
end;

function TXMLRECPMTSYNCRSType.GetSYNCRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRSMACRO'].Text;
end;

procedure TXMLRECPMTSYNCRSType.SetSYNCRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRSMACRO'].NodeValue := Value;
end;

function TXMLRECPMTSYNCRSType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLRECPMTSYNCRSType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLRECPMTSYNCRSType.GetRECPMTTRNRS: IXMLRECPMTTRNRSTypeList;
begin
  Result := FRECPMTTRNRS;
end;

{ TXMLRECPMTSYNCRSTypeList }

function TXMLRECPMTSYNCRSTypeList.Add: IXMLRECPMTSYNCRSType;
begin
  Result := AddItem(-1) as IXMLRECPMTSYNCRSType;
end;

function TXMLRECPMTSYNCRSTypeList.Insert(const Index: Integer): IXMLRECPMTSYNCRSType;
begin
  Result := AddItem(Index) as IXMLRECPMTSYNCRSType;
end;

function TXMLRECPMTSYNCRSTypeList.GetItem(Index: Integer): IXMLRECPMTSYNCRSType;
begin
  Result := List[Index] as IXMLRECPMTSYNCRSType;
end;

{ TXMLPMTMAILSYNCRSType }

procedure TXMLPMTMAILSYNCRSType.AfterConstruction;
begin
  RegisterChildNode('PMTMAILTRNRS', TXMLPMTMAILTRNRSType);
  FPMTMAILTRNRS := CreateCollection(TXMLPMTMAILTRNRSTypeList, IXMLPMTMAILTRNRSType, 'PMTMAILTRNRS') as IXMLPMTMAILTRNRSTypeList;
  inherited;
end;

function TXMLPMTMAILSYNCRSType.GetSYNCRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRSMACRO'].Text;
end;

procedure TXMLPMTMAILSYNCRSType.SetSYNCRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRSMACRO'].NodeValue := Value;
end;

function TXMLPMTMAILSYNCRSType.GetPMTMAILTRNRS: IXMLPMTMAILTRNRSTypeList;
begin
  Result := FPMTMAILTRNRS;
end;

{ TXMLPMTMAILSYNCRSTypeList }

function TXMLPMTMAILSYNCRSTypeList.Add: IXMLPMTMAILSYNCRSType;
begin
  Result := AddItem(-1) as IXMLPMTMAILSYNCRSType;
end;

function TXMLPMTMAILSYNCRSTypeList.Insert(const Index: Integer): IXMLPMTMAILSYNCRSType;
begin
  Result := AddItem(Index) as IXMLPMTMAILSYNCRSType;
end;

function TXMLPMTMAILSYNCRSTypeList.GetItem(Index: Integer): IXMLPMTMAILSYNCRSType;
begin
  Result := List[Index] as IXMLPMTMAILSYNCRSType;
end;

{ TXMLBILLPAYMSGSETType }

procedure TXMLBILLPAYMSGSETType.AfterConstruction;
begin
  RegisterChildNode('BILLPAYMSGSETV1', TXMLBILLPAYMSGSETV1Type);
  inherited;
end;

function TXMLBILLPAYMSGSETType.GetBILLPAYMSGSETV1: IXMLBILLPAYMSGSETV1Type;
begin
  Result := ChildNodes['BILLPAYMSGSETV1'] as IXMLBILLPAYMSGSETV1Type;
end;

{ TXMLBILLPAYMSGSETV1Type }

procedure TXMLBILLPAYMSGSETV1Type.AfterConstruction;
begin
  RegisterChildNode('MSGSETCORE', TXMLMSGSETCOREType);
  FPROCDAYSOFF := CreateCollection(TXMLString_List, IXMLNode, 'PROCDAYSOFF') as IXMLString_List;
  inherited;
end;

function TXMLBILLPAYMSGSETV1Type.GetMSGSETCORE: IXMLMSGSETCOREType;
begin
  Result := ChildNodes['MSGSETCORE'] as IXMLMSGSETCOREType;
end;

function TXMLBILLPAYMSGSETV1Type.GetDAYSWITH: UnicodeString;
begin
  Result := ChildNodes['DAYSWITH'].Text;
end;

procedure TXMLBILLPAYMSGSETV1Type.SetDAYSWITH(Value: UnicodeString);
begin
  ChildNodes['DAYSWITH'].NodeValue := Value;
end;

function TXMLBILLPAYMSGSETV1Type.GetDFLTDAYSTOPAY: UnicodeString;
begin
  Result := ChildNodes['DFLTDAYSTOPAY'].Text;
end;

procedure TXMLBILLPAYMSGSETV1Type.SetDFLTDAYSTOPAY(Value: UnicodeString);
begin
  ChildNodes['DFLTDAYSTOPAY'].NodeValue := Value;
end;

function TXMLBILLPAYMSGSETV1Type.GetXFERDAYSWITH: UnicodeString;
begin
  Result := ChildNodes['XFERDAYSWITH'].Text;
end;

procedure TXMLBILLPAYMSGSETV1Type.SetXFERDAYSWITH(Value: UnicodeString);
begin
  ChildNodes['XFERDAYSWITH'].NodeValue := Value;
end;

function TXMLBILLPAYMSGSETV1Type.GetXFERDFLTDAYSTOPAY: UnicodeString;
begin
  Result := ChildNodes['XFERDFLTDAYSTOPAY'].Text;
end;

procedure TXMLBILLPAYMSGSETV1Type.SetXFERDFLTDAYSTOPAY(Value: UnicodeString);
begin
  ChildNodes['XFERDFLTDAYSTOPAY'].NodeValue := Value;
end;

function TXMLBILLPAYMSGSETV1Type.GetPROCDAYSOFF: IXMLString_List;
begin
  Result := FPROCDAYSOFF;
end;

function TXMLBILLPAYMSGSETV1Type.GetPROCENDTM: UnicodeString;
begin
  Result := ChildNodes['PROCENDTM'].Text;
end;

procedure TXMLBILLPAYMSGSETV1Type.SetPROCENDTM(Value: UnicodeString);
begin
  ChildNodes['PROCENDTM'].NodeValue := Value;
end;

function TXMLBILLPAYMSGSETV1Type.GetMODELWND: UnicodeString;
begin
  Result := ChildNodes['MODELWND'].Text;
end;

procedure TXMLBILLPAYMSGSETV1Type.SetMODELWND(Value: UnicodeString);
begin
  ChildNodes['MODELWND'].NodeValue := Value;
end;

function TXMLBILLPAYMSGSETV1Type.GetPOSTPROCWND: UnicodeString;
begin
  Result := ChildNodes['POSTPROCWND'].Text;
end;

procedure TXMLBILLPAYMSGSETV1Type.SetPOSTPROCWND(Value: UnicodeString);
begin
  ChildNodes['POSTPROCWND'].NodeValue := Value;
end;

function TXMLBILLPAYMSGSETV1Type.GetSTSVIAMODS: UnicodeString;
begin
  Result := ChildNodes['STSVIAMODS'].Text;
end;

procedure TXMLBILLPAYMSGSETV1Type.SetSTSVIAMODS(Value: UnicodeString);
begin
  ChildNodes['STSVIAMODS'].NodeValue := Value;
end;

function TXMLBILLPAYMSGSETV1Type.GetPMTBYADDR: UnicodeString;
begin
  Result := ChildNodes['PMTBYADDR'].Text;
end;

procedure TXMLBILLPAYMSGSETV1Type.SetPMTBYADDR(Value: UnicodeString);
begin
  ChildNodes['PMTBYADDR'].NodeValue := Value;
end;

function TXMLBILLPAYMSGSETV1Type.GetPMTBYXFER: UnicodeString;
begin
  Result := ChildNodes['PMTBYXFER'].Text;
end;

procedure TXMLBILLPAYMSGSETV1Type.SetPMTBYXFER(Value: UnicodeString);
begin
  ChildNodes['PMTBYXFER'].NodeValue := Value;
end;

function TXMLBILLPAYMSGSETV1Type.GetPMTBYPAYEEID: UnicodeString;
begin
  Result := ChildNodes['PMTBYPAYEEID'].Text;
end;

procedure TXMLBILLPAYMSGSETV1Type.SetPMTBYPAYEEID(Value: UnicodeString);
begin
  ChildNodes['PMTBYPAYEEID'].NodeValue := Value;
end;

function TXMLBILLPAYMSGSETV1Type.GetCANADDPAYEE: UnicodeString;
begin
  Result := ChildNodes['CANADDPAYEE'].Text;
end;

procedure TXMLBILLPAYMSGSETV1Type.SetCANADDPAYEE(Value: UnicodeString);
begin
  ChildNodes['CANADDPAYEE'].NodeValue := Value;
end;

function TXMLBILLPAYMSGSETV1Type.GetHASEXTDPMT: UnicodeString;
begin
  Result := ChildNodes['HASEXTDPMT'].Text;
end;

procedure TXMLBILLPAYMSGSETV1Type.SetHASEXTDPMT(Value: UnicodeString);
begin
  ChildNodes['HASEXTDPMT'].NodeValue := Value;
end;

function TXMLBILLPAYMSGSETV1Type.GetCANMODPMTS: UnicodeString;
begin
  Result := ChildNodes['CANMODPMTS'].Text;
end;

procedure TXMLBILLPAYMSGSETV1Type.SetCANMODPMTS(Value: UnicodeString);
begin
  ChildNodes['CANMODPMTS'].NodeValue := Value;
end;

function TXMLBILLPAYMSGSETV1Type.GetCANMODMDLS: UnicodeString;
begin
  Result := ChildNodes['CANMODMDLS'].Text;
end;

procedure TXMLBILLPAYMSGSETV1Type.SetCANMODMDLS(Value: UnicodeString);
begin
  ChildNodes['CANMODMDLS'].NodeValue := Value;
end;

function TXMLBILLPAYMSGSETV1Type.GetDIFFFIRSTPMT: UnicodeString;
begin
  Result := ChildNodes['DIFFFIRSTPMT'].Text;
end;

procedure TXMLBILLPAYMSGSETV1Type.SetDIFFFIRSTPMT(Value: UnicodeString);
begin
  ChildNodes['DIFFFIRSTPMT'].NodeValue := Value;
end;

function TXMLBILLPAYMSGSETV1Type.GetDIFFLASTPMT: UnicodeString;
begin
  Result := ChildNodes['DIFFLASTPMT'].Text;
end;

procedure TXMLBILLPAYMSGSETV1Type.SetDIFFLASTPMT(Value: UnicodeString);
begin
  ChildNodes['DIFFLASTPMT'].NodeValue := Value;
end;

{ TXMLBPACCTINFOType }

function TXMLBPACCTINFOType.GetBANKACCTFROM: UnicodeString;
begin
  Result := ChildNodes['BANKACCTFROM'].Text;
end;

procedure TXMLBPACCTINFOType.SetBANKACCTFROM(Value: UnicodeString);
begin
  ChildNodes['BANKACCTFROM'].NodeValue := Value;
end;

function TXMLBPACCTINFOType.GetSVCSTATUS: UnicodeString;
begin
  Result := ChildNodes['SVCSTATUS'].Text;
end;

procedure TXMLBPACCTINFOType.SetSVCSTATUS(Value: UnicodeString);
begin
  ChildNodes['SVCSTATUS'].NodeValue := Value;
end;

{ TXMLSIGNUPMSGSRQV1Type }

procedure TXMLSIGNUPMSGSRQV1Type.AfterConstruction;
begin
  RegisterChildNode('ENROLLTRNRQ', TXMLENROLLTRNRQType);
  RegisterChildNode('ACCTINFOTRNRQ', TXMLACCTINFOTRNRQType);
  RegisterChildNode('CHGUSERINFOTRNRQ', TXMLCHGUSERINFOTRNRQType);
  RegisterChildNode('CHGUSERINFOSYNCRQ', TXMLCHGUSERINFOSYNCRQType);
  RegisterChildNode('ACCTTRNRQ', TXMLACCTTRNRQType);
  RegisterChildNode('ACCTSYNCRQ', TXMLACCTSYNCRQType);
  FENROLLTRNRQ := CreateCollection(TXMLENROLLTRNRQTypeList, IXMLENROLLTRNRQType, 'ENROLLTRNRQ') as IXMLENROLLTRNRQTypeList;
  FACCTINFOTRNRQ := CreateCollection(TXMLACCTINFOTRNRQTypeList, IXMLACCTINFOTRNRQType, 'ACCTINFOTRNRQ') as IXMLACCTINFOTRNRQTypeList;
  FCHGUSERINFOTRNRQ := CreateCollection(TXMLCHGUSERINFOTRNRQTypeList, IXMLCHGUSERINFOTRNRQType, 'CHGUSERINFOTRNRQ') as IXMLCHGUSERINFOTRNRQTypeList;
  FCHGUSERINFOSYNCRQ := CreateCollection(TXMLCHGUSERINFOSYNCRQTypeList, IXMLCHGUSERINFOSYNCRQType, 'CHGUSERINFOSYNCRQ') as IXMLCHGUSERINFOSYNCRQTypeList;
  FACCTTRNRQ := CreateCollection(TXMLACCTTRNRQTypeList, IXMLACCTTRNRQType, 'ACCTTRNRQ') as IXMLACCTTRNRQTypeList;
  FACCTSYNCRQ := CreateCollection(TXMLACCTSYNCRQTypeList, IXMLACCTSYNCRQType, 'ACCTSYNCRQ') as IXMLACCTSYNCRQTypeList;
  inherited;
end;

function TXMLSIGNUPMSGSRQV1Type.GetENROLLTRNRQ: IXMLENROLLTRNRQTypeList;
begin
  Result := FENROLLTRNRQ;
end;

function TXMLSIGNUPMSGSRQV1Type.GetACCTINFOTRNRQ: IXMLACCTINFOTRNRQTypeList;
begin
  Result := FACCTINFOTRNRQ;
end;

function TXMLSIGNUPMSGSRQV1Type.GetCHGUSERINFOTRNRQ: IXMLCHGUSERINFOTRNRQTypeList;
begin
  Result := FCHGUSERINFOTRNRQ;
end;

function TXMLSIGNUPMSGSRQV1Type.GetCHGUSERINFOSYNCRQ: IXMLCHGUSERINFOSYNCRQTypeList;
begin
  Result := FCHGUSERINFOSYNCRQ;
end;

function TXMLSIGNUPMSGSRQV1Type.GetACCTTRNRQ: IXMLACCTTRNRQTypeList;
begin
  Result := FACCTTRNRQ;
end;

function TXMLSIGNUPMSGSRQV1Type.GetACCTSYNCRQ: IXMLACCTSYNCRQTypeList;
begin
  Result := FACCTSYNCRQ;
end;

{ TXMLENROLLTRNRQType }

procedure TXMLENROLLTRNRQType.AfterConstruction;
begin
  RegisterChildNode('ENROLLRQ', TXMLENROLLRQType);
  inherited;
end;

function TXMLENROLLTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLENROLLTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLENROLLTRNRQType.GetENROLLRQ: IXMLENROLLRQType;
begin
  Result := ChildNodes['ENROLLRQ'] as IXMLENROLLRQType;
end;

{ TXMLENROLLTRNRQTypeList }

function TXMLENROLLTRNRQTypeList.Add: IXMLENROLLTRNRQType;
begin
  Result := AddItem(-1) as IXMLENROLLTRNRQType;
end;

function TXMLENROLLTRNRQTypeList.Insert(const Index: Integer): IXMLENROLLTRNRQType;
begin
  Result := AddItem(Index) as IXMLENROLLTRNRQType;
end;

function TXMLENROLLTRNRQTypeList.GetItem(Index: Integer): IXMLENROLLTRNRQType;
begin
  Result := List[Index] as IXMLENROLLTRNRQType;
end;

{ TXMLENROLLRQType }

function TXMLENROLLRQType.GetFIRSTNAME: UnicodeString;
begin
  Result := ChildNodes['FIRSTNAME'].Text;
end;

procedure TXMLENROLLRQType.SetFIRSTNAME(Value: UnicodeString);
begin
  ChildNodes['FIRSTNAME'].NodeValue := Value;
end;

function TXMLENROLLRQType.GetMIDDLENAME: UnicodeString;
begin
  Result := ChildNodes['MIDDLENAME'].Text;
end;

procedure TXMLENROLLRQType.SetMIDDLENAME(Value: UnicodeString);
begin
  ChildNodes['MIDDLENAME'].NodeValue := Value;
end;

function TXMLENROLLRQType.GetLASTNAME: UnicodeString;
begin
  Result := ChildNodes['LASTNAME'].Text;
end;

procedure TXMLENROLLRQType.SetLASTNAME(Value: UnicodeString);
begin
  ChildNodes['LASTNAME'].NodeValue := Value;
end;

function TXMLENROLLRQType.GetADDR1: UnicodeString;
begin
  Result := ChildNodes['ADDR1'].Text;
end;

procedure TXMLENROLLRQType.SetADDR1(Value: UnicodeString);
begin
  ChildNodes['ADDR1'].NodeValue := Value;
end;

function TXMLENROLLRQType.GetADDR2: UnicodeString;
begin
  Result := ChildNodes['ADDR2'].Text;
end;

procedure TXMLENROLLRQType.SetADDR2(Value: UnicodeString);
begin
  ChildNodes['ADDR2'].NodeValue := Value;
end;

function TXMLENROLLRQType.GetADDR3: UnicodeString;
begin
  Result := ChildNodes['ADDR3'].Text;
end;

procedure TXMLENROLLRQType.SetADDR3(Value: UnicodeString);
begin
  ChildNodes['ADDR3'].NodeValue := Value;
end;

function TXMLENROLLRQType.GetCITY: UnicodeString;
begin
  Result := ChildNodes['CITY'].Text;
end;

procedure TXMLENROLLRQType.SetCITY(Value: UnicodeString);
begin
  ChildNodes['CITY'].NodeValue := Value;
end;

function TXMLENROLLRQType.GetSTATE: UnicodeString;
begin
  Result := ChildNodes['STATE'].Text;
end;

procedure TXMLENROLLRQType.SetSTATE(Value: UnicodeString);
begin
  ChildNodes['STATE'].NodeValue := Value;
end;

function TXMLENROLLRQType.GetPOSTALCODE: UnicodeString;
begin
  Result := ChildNodes['POSTALCODE'].Text;
end;

procedure TXMLENROLLRQType.SetPOSTALCODE(Value: UnicodeString);
begin
  ChildNodes['POSTALCODE'].NodeValue := Value;
end;

function TXMLENROLLRQType.GetCOUNTRY: UnicodeString;
begin
  Result := ChildNodes['COUNTRY'].Text;
end;

procedure TXMLENROLLRQType.SetCOUNTRY(Value: UnicodeString);
begin
  ChildNodes['COUNTRY'].NodeValue := Value;
end;

function TXMLENROLLRQType.GetDAYPHONE: UnicodeString;
begin
  Result := ChildNodes['DAYPHONE'].Text;
end;

procedure TXMLENROLLRQType.SetDAYPHONE(Value: UnicodeString);
begin
  ChildNodes['DAYPHONE'].NodeValue := Value;
end;

function TXMLENROLLRQType.GetEVEPHONE: UnicodeString;
begin
  Result := ChildNodes['EVEPHONE'].Text;
end;

procedure TXMLENROLLRQType.SetEVEPHONE(Value: UnicodeString);
begin
  ChildNodes['EVEPHONE'].NodeValue := Value;
end;

function TXMLENROLLRQType.GetEMAIL: UnicodeString;
begin
  Result := ChildNodes['EMAIL'].Text;
end;

procedure TXMLENROLLRQType.SetEMAIL(Value: UnicodeString);
begin
  ChildNodes['EMAIL'].NodeValue := Value;
end;

function TXMLENROLLRQType.GetUSERID: UnicodeString;
begin
  Result := ChildNodes['USERID'].Text;
end;

procedure TXMLENROLLRQType.SetUSERID(Value: UnicodeString);
begin
  ChildNodes['USERID'].NodeValue := Value;
end;

function TXMLENROLLRQType.GetTAXID: UnicodeString;
begin
  Result := ChildNodes['TAXID'].Text;
end;

procedure TXMLENROLLRQType.SetTAXID(Value: UnicodeString);
begin
  ChildNodes['TAXID'].NodeValue := Value;
end;

function TXMLENROLLRQType.GetSECURITYNAME: UnicodeString;
begin
  Result := ChildNodes['SECURITYNAME'].Text;
end;

procedure TXMLENROLLRQType.SetSECURITYNAME(Value: UnicodeString);
begin
  ChildNodes['SECURITYNAME'].NodeValue := Value;
end;

function TXMLENROLLRQType.GetDATEBIRTH: UnicodeString;
begin
  Result := ChildNodes['DATEBIRTH'].Text;
end;

procedure TXMLENROLLRQType.SetDATEBIRTH(Value: UnicodeString);
begin
  ChildNodes['DATEBIRTH'].NodeValue := Value;
end;

function TXMLENROLLRQType.GetACCTFROMMACRO: UnicodeString;
begin
  Result := ChildNodes['%ACCTFROMMACRO'].Text;
end;

procedure TXMLENROLLRQType.SetACCTFROMMACRO(Value: UnicodeString);
begin
  ChildNodes['%ACCTFROMMACRO'].NodeValue := Value;
end;

{ TXMLACCTINFOTRNRQType }

procedure TXMLACCTINFOTRNRQType.AfterConstruction;
begin
  RegisterChildNode('ACCTINFORQ', TXMLACCTINFORQType);
  inherited;
end;

function TXMLACCTINFOTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLACCTINFOTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLACCTINFOTRNRQType.GetACCTINFORQ: IXMLACCTINFORQType;
begin
  Result := ChildNodes['ACCTINFORQ'] as IXMLACCTINFORQType;
end;

{ TXMLACCTINFOTRNRQTypeList }

function TXMLACCTINFOTRNRQTypeList.Add: IXMLACCTINFOTRNRQType;
begin
  Result := AddItem(-1) as IXMLACCTINFOTRNRQType;
end;

function TXMLACCTINFOTRNRQTypeList.Insert(const Index: Integer): IXMLACCTINFOTRNRQType;
begin
  Result := AddItem(Index) as IXMLACCTINFOTRNRQType;
end;

function TXMLACCTINFOTRNRQTypeList.GetItem(Index: Integer): IXMLACCTINFOTRNRQType;
begin
  Result := List[Index] as IXMLACCTINFOTRNRQType;
end;

{ TXMLACCTINFORQType }

function TXMLACCTINFORQType.GetDTACCTUP: UnicodeString;
begin
  Result := ChildNodes['DTACCTUP'].Text;
end;

procedure TXMLACCTINFORQType.SetDTACCTUP(Value: UnicodeString);
begin
  ChildNodes['DTACCTUP'].NodeValue := Value;
end;

{ TXMLCHGUSERINFOTRNRQType }

procedure TXMLCHGUSERINFOTRNRQType.AfterConstruction;
begin
  RegisterChildNode('CHGUSERINFORQ', TXMLCHGUSERINFORQType);
  inherited;
end;

function TXMLCHGUSERINFOTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLCHGUSERINFOTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLCHGUSERINFOTRNRQType.GetCHGUSERINFORQ: IXMLCHGUSERINFORQType;
begin
  Result := ChildNodes['CHGUSERINFORQ'] as IXMLCHGUSERINFORQType;
end;

{ TXMLCHGUSERINFOTRNRQTypeList }

function TXMLCHGUSERINFOTRNRQTypeList.Add: IXMLCHGUSERINFOTRNRQType;
begin
  Result := AddItem(-1) as IXMLCHGUSERINFOTRNRQType;
end;

function TXMLCHGUSERINFOTRNRQTypeList.Insert(const Index: Integer): IXMLCHGUSERINFOTRNRQType;
begin
  Result := AddItem(Index) as IXMLCHGUSERINFOTRNRQType;
end;

function TXMLCHGUSERINFOTRNRQTypeList.GetItem(Index: Integer): IXMLCHGUSERINFOTRNRQType;
begin
  Result := List[Index] as IXMLCHGUSERINFOTRNRQType;
end;

{ TXMLCHGUSERINFORQType }

function TXMLCHGUSERINFORQType.GetFIRSTNAME: UnicodeString;
begin
  Result := ChildNodes['FIRSTNAME'].Text;
end;

procedure TXMLCHGUSERINFORQType.SetFIRSTNAME(Value: UnicodeString);
begin
  ChildNodes['FIRSTNAME'].NodeValue := Value;
end;

function TXMLCHGUSERINFORQType.GetMIDDLENAME: UnicodeString;
begin
  Result := ChildNodes['MIDDLENAME'].Text;
end;

procedure TXMLCHGUSERINFORQType.SetMIDDLENAME(Value: UnicodeString);
begin
  ChildNodes['MIDDLENAME'].NodeValue := Value;
end;

function TXMLCHGUSERINFORQType.GetLASTNAME: UnicodeString;
begin
  Result := ChildNodes['LASTNAME'].Text;
end;

procedure TXMLCHGUSERINFORQType.SetLASTNAME(Value: UnicodeString);
begin
  ChildNodes['LASTNAME'].NodeValue := Value;
end;

function TXMLCHGUSERINFORQType.GetADDR1: UnicodeString;
begin
  Result := ChildNodes['ADDR1'].Text;
end;

procedure TXMLCHGUSERINFORQType.SetADDR1(Value: UnicodeString);
begin
  ChildNodes['ADDR1'].NodeValue := Value;
end;

function TXMLCHGUSERINFORQType.GetADDR2: UnicodeString;
begin
  Result := ChildNodes['ADDR2'].Text;
end;

procedure TXMLCHGUSERINFORQType.SetADDR2(Value: UnicodeString);
begin
  ChildNodes['ADDR2'].NodeValue := Value;
end;

function TXMLCHGUSERINFORQType.GetADDR3: UnicodeString;
begin
  Result := ChildNodes['ADDR3'].Text;
end;

procedure TXMLCHGUSERINFORQType.SetADDR3(Value: UnicodeString);
begin
  ChildNodes['ADDR3'].NodeValue := Value;
end;

function TXMLCHGUSERINFORQType.GetCITY: UnicodeString;
begin
  Result := ChildNodes['CITY'].Text;
end;

procedure TXMLCHGUSERINFORQType.SetCITY(Value: UnicodeString);
begin
  ChildNodes['CITY'].NodeValue := Value;
end;

function TXMLCHGUSERINFORQType.GetSTATE: UnicodeString;
begin
  Result := ChildNodes['STATE'].Text;
end;

procedure TXMLCHGUSERINFORQType.SetSTATE(Value: UnicodeString);
begin
  ChildNodes['STATE'].NodeValue := Value;
end;

function TXMLCHGUSERINFORQType.GetPOSTALCODE: UnicodeString;
begin
  Result := ChildNodes['POSTALCODE'].Text;
end;

procedure TXMLCHGUSERINFORQType.SetPOSTALCODE(Value: UnicodeString);
begin
  ChildNodes['POSTALCODE'].NodeValue := Value;
end;

function TXMLCHGUSERINFORQType.GetCOUNTRY: UnicodeString;
begin
  Result := ChildNodes['COUNTRY'].Text;
end;

procedure TXMLCHGUSERINFORQType.SetCOUNTRY(Value: UnicodeString);
begin
  ChildNodes['COUNTRY'].NodeValue := Value;
end;

function TXMLCHGUSERINFORQType.GetDAYPHONE: UnicodeString;
begin
  Result := ChildNodes['DAYPHONE'].Text;
end;

procedure TXMLCHGUSERINFORQType.SetDAYPHONE(Value: UnicodeString);
begin
  ChildNodes['DAYPHONE'].NodeValue := Value;
end;

function TXMLCHGUSERINFORQType.GetEVEPHONE: UnicodeString;
begin
  Result := ChildNodes['EVEPHONE'].Text;
end;

procedure TXMLCHGUSERINFORQType.SetEVEPHONE(Value: UnicodeString);
begin
  ChildNodes['EVEPHONE'].NodeValue := Value;
end;

function TXMLCHGUSERINFORQType.GetEMAIL: UnicodeString;
begin
  Result := ChildNodes['EMAIL'].Text;
end;

procedure TXMLCHGUSERINFORQType.SetEMAIL(Value: UnicodeString);
begin
  ChildNodes['EMAIL'].NodeValue := Value;
end;

{ TXMLCHGUSERINFOSYNCRQType }

procedure TXMLCHGUSERINFOSYNCRQType.AfterConstruction;
begin
  RegisterChildNode('CHGUSERINFOTRNRQ', TXMLCHGUSERINFOTRNRQType);
  FCHGUSERINFOTRNRQ := CreateCollection(TXMLCHGUSERINFOTRNRQTypeList, IXMLCHGUSERINFOTRNRQType, 'CHGUSERINFOTRNRQ') as IXMLCHGUSERINFOTRNRQTypeList;
  inherited;
end;

function TXMLCHGUSERINFOSYNCRQType.GetSYNCRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRQMACRO'].Text;
end;

procedure TXMLCHGUSERINFOSYNCRQType.SetSYNCRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRQMACRO'].NodeValue := Value;
end;

function TXMLCHGUSERINFOSYNCRQType.GetCHGUSERINFOTRNRQ: IXMLCHGUSERINFOTRNRQTypeList;
begin
  Result := FCHGUSERINFOTRNRQ;
end;

{ TXMLCHGUSERINFOSYNCRQTypeList }

function TXMLCHGUSERINFOSYNCRQTypeList.Add: IXMLCHGUSERINFOSYNCRQType;
begin
  Result := AddItem(-1) as IXMLCHGUSERINFOSYNCRQType;
end;

function TXMLCHGUSERINFOSYNCRQTypeList.Insert(const Index: Integer): IXMLCHGUSERINFOSYNCRQType;
begin
  Result := AddItem(Index) as IXMLCHGUSERINFOSYNCRQType;
end;

function TXMLCHGUSERINFOSYNCRQTypeList.GetItem(Index: Integer): IXMLCHGUSERINFOSYNCRQType;
begin
  Result := List[Index] as IXMLCHGUSERINFOSYNCRQType;
end;

{ TXMLACCTTRNRQType }

procedure TXMLACCTTRNRQType.AfterConstruction;
begin
  RegisterChildNode('ACCTRQ', TXMLACCTRQType);
  inherited;
end;

function TXMLACCTTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLACCTTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLACCTTRNRQType.GetACCTRQ: IXMLACCTRQType;
begin
  Result := ChildNodes['ACCTRQ'] as IXMLACCTRQType;
end;

{ TXMLACCTTRNRQTypeList }

function TXMLACCTTRNRQTypeList.Add: IXMLACCTTRNRQType;
begin
  Result := AddItem(-1) as IXMLACCTTRNRQType;
end;

function TXMLACCTTRNRQTypeList.Insert(const Index: Integer): IXMLACCTTRNRQType;
begin
  Result := AddItem(Index) as IXMLACCTTRNRQType;
end;

function TXMLACCTTRNRQTypeList.GetItem(Index: Integer): IXMLACCTTRNRQType;
begin
  Result := List[Index] as IXMLACCTTRNRQType;
end;

{ TXMLACCTRQType }

procedure TXMLACCTRQType.AfterConstruction;
begin
  RegisterChildNode('SVCADD', TXMLSVCADDType);
  RegisterChildNode('SVCCHG', TXMLSVCCHGType);
  RegisterChildNode('SVCDEL', TXMLSVCDELType);
  inherited;
end;

function TXMLACCTRQType.GetSVCADD: IXMLSVCADDType;
begin
  Result := ChildNodes['SVCADD'] as IXMLSVCADDType;
end;

function TXMLACCTRQType.GetSVCCHG: IXMLSVCCHGType;
begin
  Result := ChildNodes['SVCCHG'] as IXMLSVCCHGType;
end;

function TXMLACCTRQType.GetSVCDEL: IXMLSVCDELType;
begin
  Result := ChildNodes['SVCDEL'] as IXMLSVCDELType;
end;

function TXMLACCTRQType.GetSVC: UnicodeString;
begin
  Result := ChildNodes['SVC'].Text;
end;

procedure TXMLACCTRQType.SetSVC(Value: UnicodeString);
begin
  ChildNodes['SVC'].NodeValue := Value;
end;

{ TXMLSVCADDType }

function TXMLSVCADDType.GetACCTTOMACRO: UnicodeString;
begin
  Result := ChildNodes['%ACCTTOMACRO'].Text;
end;

procedure TXMLSVCADDType.SetACCTTOMACRO(Value: UnicodeString);
begin
  ChildNodes['%ACCTTOMACRO'].NodeValue := Value;
end;

{ TXMLSVCCHGType }

function TXMLSVCCHGType.GetACCTFROMMACRO: UnicodeString;
begin
  Result := ChildNodes['%ACCTFROMMACRO'].Text;
end;

procedure TXMLSVCCHGType.SetACCTFROMMACRO(Value: UnicodeString);
begin
  ChildNodes['%ACCTFROMMACRO'].NodeValue := Value;
end;

function TXMLSVCCHGType.GetACCTTOMACRO: UnicodeString;
begin
  Result := ChildNodes['%ACCTTOMACRO'].Text;
end;

procedure TXMLSVCCHGType.SetACCTTOMACRO(Value: UnicodeString);
begin
  ChildNodes['%ACCTTOMACRO'].NodeValue := Value;
end;

{ TXMLSVCDELType }

function TXMLSVCDELType.GetACCTFROMMACRO: UnicodeString;
begin
  Result := ChildNodes['%ACCTFROMMACRO'].Text;
end;

procedure TXMLSVCDELType.SetACCTFROMMACRO(Value: UnicodeString);
begin
  ChildNodes['%ACCTFROMMACRO'].NodeValue := Value;
end;

{ TXMLACCTSYNCRQType }

procedure TXMLACCTSYNCRQType.AfterConstruction;
begin
  RegisterChildNode('ACCTTRNRQ', TXMLACCTTRNRQType);
  FACCTTRNRQ := CreateCollection(TXMLACCTTRNRQTypeList, IXMLACCTTRNRQType, 'ACCTTRNRQ') as IXMLACCTTRNRQTypeList;
  inherited;
end;

function TXMLACCTSYNCRQType.GetSYNCRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRQMACRO'].Text;
end;

procedure TXMLACCTSYNCRQType.SetSYNCRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRQMACRO'].NodeValue := Value;
end;

function TXMLACCTSYNCRQType.GetACCTTRNRQ: IXMLACCTTRNRQTypeList;
begin
  Result := FACCTTRNRQ;
end;

{ TXMLACCTSYNCRQTypeList }

function TXMLACCTSYNCRQTypeList.Add: IXMLACCTSYNCRQType;
begin
  Result := AddItem(-1) as IXMLACCTSYNCRQType;
end;

function TXMLACCTSYNCRQTypeList.Insert(const Index: Integer): IXMLACCTSYNCRQType;
begin
  Result := AddItem(Index) as IXMLACCTSYNCRQType;
end;

function TXMLACCTSYNCRQTypeList.GetItem(Index: Integer): IXMLACCTSYNCRQType;
begin
  Result := List[Index] as IXMLACCTSYNCRQType;
end;

{ TXMLSIGNUPMSGSRSV1Type }

procedure TXMLSIGNUPMSGSRSV1Type.AfterConstruction;
begin
  RegisterChildNode('ENROLLTRNRS', TXMLENROLLTRNRSType);
  RegisterChildNode('ACCTINFOTRNRS', TXMLACCTINFOTRNRSType);
  RegisterChildNode('CHGUSERINFOTRNRS', TXMLCHGUSERINFOTRNRSType);
  RegisterChildNode('CHGUSERINFOSYNCRS', TXMLCHGUSERINFOSYNCRSType);
  RegisterChildNode('ACCTTRNRS', TXMLACCTTRNRSType);
  RegisterChildNode('ACCTSYNCRS', TXMLACCTSYNCRSType);
  FENROLLTRNRS := CreateCollection(TXMLENROLLTRNRSTypeList, IXMLENROLLTRNRSType, 'ENROLLTRNRS') as IXMLENROLLTRNRSTypeList;
  FACCTINFOTRNRS := CreateCollection(TXMLACCTINFOTRNRSTypeList, IXMLACCTINFOTRNRSType, 'ACCTINFOTRNRS') as IXMLACCTINFOTRNRSTypeList;
  FCHGUSERINFOTRNRS := CreateCollection(TXMLCHGUSERINFOTRNRSTypeList, IXMLCHGUSERINFOTRNRSType, 'CHGUSERINFOTRNRS') as IXMLCHGUSERINFOTRNRSTypeList;
  FCHGUSERINFOSYNCRS := CreateCollection(TXMLCHGUSERINFOSYNCRSTypeList, IXMLCHGUSERINFOSYNCRSType, 'CHGUSERINFOSYNCRS') as IXMLCHGUSERINFOSYNCRSTypeList;
  FACCTTRNRS := CreateCollection(TXMLACCTTRNRSTypeList, IXMLACCTTRNRSType, 'ACCTTRNRS') as IXMLACCTTRNRSTypeList;
  FACCTSYNCRS := CreateCollection(TXMLACCTSYNCRSTypeList, IXMLACCTSYNCRSType, 'ACCTSYNCRS') as IXMLACCTSYNCRSTypeList;
  inherited;
end;

function TXMLSIGNUPMSGSRSV1Type.GetENROLLTRNRS: IXMLENROLLTRNRSTypeList;
begin
  Result := FENROLLTRNRS;
end;

function TXMLSIGNUPMSGSRSV1Type.GetACCTINFOTRNRS: IXMLACCTINFOTRNRSTypeList;
begin
  Result := FACCTINFOTRNRS;
end;

function TXMLSIGNUPMSGSRSV1Type.GetCHGUSERINFOTRNRS: IXMLCHGUSERINFOTRNRSTypeList;
begin
  Result := FCHGUSERINFOTRNRS;
end;

function TXMLSIGNUPMSGSRSV1Type.GetCHGUSERINFOSYNCRS: IXMLCHGUSERINFOSYNCRSTypeList;
begin
  Result := FCHGUSERINFOSYNCRS;
end;

function TXMLSIGNUPMSGSRSV1Type.GetACCTTRNRS: IXMLACCTTRNRSTypeList;
begin
  Result := FACCTTRNRS;
end;

function TXMLSIGNUPMSGSRSV1Type.GetACCTSYNCRS: IXMLACCTSYNCRSTypeList;
begin
  Result := FACCTSYNCRS;
end;

{ TXMLENROLLTRNRSType }

procedure TXMLENROLLTRNRSType.AfterConstruction;
begin
  RegisterChildNode('ENROLLRS', TXMLENROLLRSType);
  inherited;
end;

function TXMLENROLLTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLENROLLTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLENROLLTRNRSType.GetENROLLRS: IXMLENROLLRSType;
begin
  Result := ChildNodes['ENROLLRS'] as IXMLENROLLRSType;
end;

{ TXMLENROLLTRNRSTypeList }

function TXMLENROLLTRNRSTypeList.Add: IXMLENROLLTRNRSType;
begin
  Result := AddItem(-1) as IXMLENROLLTRNRSType;
end;

function TXMLENROLLTRNRSTypeList.Insert(const Index: Integer): IXMLENROLLTRNRSType;
begin
  Result := AddItem(Index) as IXMLENROLLTRNRSType;
end;

function TXMLENROLLTRNRSTypeList.GetItem(Index: Integer): IXMLENROLLTRNRSType;
begin
  Result := List[Index] as IXMLENROLLTRNRSType;
end;

{ TXMLENROLLRSType }

function TXMLENROLLRSType.GetTEMPPASS: UnicodeString;
begin
  Result := ChildNodes['TEMPPASS'].Text;
end;

procedure TXMLENROLLRSType.SetTEMPPASS(Value: UnicodeString);
begin
  ChildNodes['TEMPPASS'].NodeValue := Value;
end;

function TXMLENROLLRSType.GetUSERID: UnicodeString;
begin
  Result := ChildNodes['USERID'].Text;
end;

procedure TXMLENROLLRSType.SetUSERID(Value: UnicodeString);
begin
  ChildNodes['USERID'].NodeValue := Value;
end;

function TXMLENROLLRSType.GetDTEXPIRE: UnicodeString;
begin
  Result := ChildNodes['DTEXPIRE'].Text;
end;

procedure TXMLENROLLRSType.SetDTEXPIRE(Value: UnicodeString);
begin
  ChildNodes['DTEXPIRE'].NodeValue := Value;
end;

{ TXMLACCTINFOTRNRSType }

procedure TXMLACCTINFOTRNRSType.AfterConstruction;
begin
  RegisterChildNode('ACCTINFORS', TXMLACCTINFORSType);
  inherited;
end;

function TXMLACCTINFOTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLACCTINFOTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLACCTINFOTRNRSType.GetACCTINFORS: IXMLACCTINFORSType;
begin
  Result := ChildNodes['ACCTINFORS'] as IXMLACCTINFORSType;
end;

{ TXMLACCTINFOTRNRSTypeList }

function TXMLACCTINFOTRNRSTypeList.Add: IXMLACCTINFOTRNRSType;
begin
  Result := AddItem(-1) as IXMLACCTINFOTRNRSType;
end;

function TXMLACCTINFOTRNRSTypeList.Insert(const Index: Integer): IXMLACCTINFOTRNRSType;
begin
  Result := AddItem(Index) as IXMLACCTINFOTRNRSType;
end;

function TXMLACCTINFOTRNRSTypeList.GetItem(Index: Integer): IXMLACCTINFOTRNRSType;
begin
  Result := List[Index] as IXMLACCTINFOTRNRSType;
end;

{ TXMLACCTINFORSType }

procedure TXMLACCTINFORSType.AfterConstruction;
begin
  RegisterChildNode('ACCTINFO', TXMLACCTINFOType);
  FACCTINFO := CreateCollection(TXMLACCTINFOTypeList, IXMLACCTINFOType, 'ACCTINFO') as IXMLACCTINFOTypeList;
  inherited;
end;

function TXMLACCTINFORSType.GetDTACCTUP: UnicodeString;
begin
  Result := ChildNodes['DTACCTUP'].Text;
end;

procedure TXMLACCTINFORSType.SetDTACCTUP(Value: UnicodeString);
begin
  ChildNodes['DTACCTUP'].NodeValue := Value;
end;

function TXMLACCTINFORSType.GetACCTINFO: IXMLACCTINFOTypeList;
begin
  Result := FACCTINFO;
end;

{ TXMLACCTINFOType }

procedure TXMLACCTINFOType.AfterConstruction;
begin
  FACCTINFOMACRO := CreateCollection(TXMLString_List, IXMLNode, '%ACCTINFOMACRO') as IXMLString_List;
  inherited;
end;

function TXMLACCTINFOType.GetDESC: UnicodeString;
begin
  Result := ChildNodes['DESC'].Text;
end;

procedure TXMLACCTINFOType.SetDESC(Value: UnicodeString);
begin
  ChildNodes['DESC'].NodeValue := Value;
end;

function TXMLACCTINFOType.GetPHONE: UnicodeString;
begin
  Result := ChildNodes['PHONE'].Text;
end;

procedure TXMLACCTINFOType.SetPHONE(Value: UnicodeString);
begin
  ChildNodes['PHONE'].NodeValue := Value;
end;

function TXMLACCTINFOType.GetACCTINFOMACRO: IXMLString_List;
begin
  Result := FACCTINFOMACRO;
end;

{ TXMLACCTINFOTypeList }

function TXMLACCTINFOTypeList.Add: IXMLACCTINFOType;
begin
  Result := AddItem(-1) as IXMLACCTINFOType;
end;

function TXMLACCTINFOTypeList.Insert(const Index: Integer): IXMLACCTINFOType;
begin
  Result := AddItem(Index) as IXMLACCTINFOType;
end;

function TXMLACCTINFOTypeList.GetItem(Index: Integer): IXMLACCTINFOType;
begin
  Result := List[Index] as IXMLACCTINFOType;
end;

{ TXMLCHGUSERINFOTRNRSType }

procedure TXMLCHGUSERINFOTRNRSType.AfterConstruction;
begin
  RegisterChildNode('CHGUSERINFORS', TXMLCHGUSERINFORSType);
  inherited;
end;

function TXMLCHGUSERINFOTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLCHGUSERINFOTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLCHGUSERINFOTRNRSType.GetCHGUSERINFORS: IXMLCHGUSERINFORSType;
begin
  Result := ChildNodes['CHGUSERINFORS'] as IXMLCHGUSERINFORSType;
end;

{ TXMLCHGUSERINFOTRNRSTypeList }

function TXMLCHGUSERINFOTRNRSTypeList.Add: IXMLCHGUSERINFOTRNRSType;
begin
  Result := AddItem(-1) as IXMLCHGUSERINFOTRNRSType;
end;

function TXMLCHGUSERINFOTRNRSTypeList.Insert(const Index: Integer): IXMLCHGUSERINFOTRNRSType;
begin
  Result := AddItem(Index) as IXMLCHGUSERINFOTRNRSType;
end;

function TXMLCHGUSERINFOTRNRSTypeList.GetItem(Index: Integer): IXMLCHGUSERINFOTRNRSType;
begin
  Result := List[Index] as IXMLCHGUSERINFOTRNRSType;
end;

{ TXMLCHGUSERINFORSType }

function TXMLCHGUSERINFORSType.GetFIRSTNAME: UnicodeString;
begin
  Result := ChildNodes['FIRSTNAME'].Text;
end;

procedure TXMLCHGUSERINFORSType.SetFIRSTNAME(Value: UnicodeString);
begin
  ChildNodes['FIRSTNAME'].NodeValue := Value;
end;

function TXMLCHGUSERINFORSType.GetMIDDLENAME: UnicodeString;
begin
  Result := ChildNodes['MIDDLENAME'].Text;
end;

procedure TXMLCHGUSERINFORSType.SetMIDDLENAME(Value: UnicodeString);
begin
  ChildNodes['MIDDLENAME'].NodeValue := Value;
end;

function TXMLCHGUSERINFORSType.GetLASTNAME: UnicodeString;
begin
  Result := ChildNodes['LASTNAME'].Text;
end;

procedure TXMLCHGUSERINFORSType.SetLASTNAME(Value: UnicodeString);
begin
  ChildNodes['LASTNAME'].NodeValue := Value;
end;

function TXMLCHGUSERINFORSType.GetADDR1: UnicodeString;
begin
  Result := ChildNodes['ADDR1'].Text;
end;

procedure TXMLCHGUSERINFORSType.SetADDR1(Value: UnicodeString);
begin
  ChildNodes['ADDR1'].NodeValue := Value;
end;

function TXMLCHGUSERINFORSType.GetADDR2: UnicodeString;
begin
  Result := ChildNodes['ADDR2'].Text;
end;

procedure TXMLCHGUSERINFORSType.SetADDR2(Value: UnicodeString);
begin
  ChildNodes['ADDR2'].NodeValue := Value;
end;

function TXMLCHGUSERINFORSType.GetADDR3: UnicodeString;
begin
  Result := ChildNodes['ADDR3'].Text;
end;

procedure TXMLCHGUSERINFORSType.SetADDR3(Value: UnicodeString);
begin
  ChildNodes['ADDR3'].NodeValue := Value;
end;

function TXMLCHGUSERINFORSType.GetCITY: UnicodeString;
begin
  Result := ChildNodes['CITY'].Text;
end;

procedure TXMLCHGUSERINFORSType.SetCITY(Value: UnicodeString);
begin
  ChildNodes['CITY'].NodeValue := Value;
end;

function TXMLCHGUSERINFORSType.GetSTATE: UnicodeString;
begin
  Result := ChildNodes['STATE'].Text;
end;

procedure TXMLCHGUSERINFORSType.SetSTATE(Value: UnicodeString);
begin
  ChildNodes['STATE'].NodeValue := Value;
end;

function TXMLCHGUSERINFORSType.GetPOSTALCODE: UnicodeString;
begin
  Result := ChildNodes['POSTALCODE'].Text;
end;

procedure TXMLCHGUSERINFORSType.SetPOSTALCODE(Value: UnicodeString);
begin
  ChildNodes['POSTALCODE'].NodeValue := Value;
end;

function TXMLCHGUSERINFORSType.GetCOUNTRY: UnicodeString;
begin
  Result := ChildNodes['COUNTRY'].Text;
end;

procedure TXMLCHGUSERINFORSType.SetCOUNTRY(Value: UnicodeString);
begin
  ChildNodes['COUNTRY'].NodeValue := Value;
end;

function TXMLCHGUSERINFORSType.GetDAYPHONE: UnicodeString;
begin
  Result := ChildNodes['DAYPHONE'].Text;
end;

procedure TXMLCHGUSERINFORSType.SetDAYPHONE(Value: UnicodeString);
begin
  ChildNodes['DAYPHONE'].NodeValue := Value;
end;

function TXMLCHGUSERINFORSType.GetEVEPHONE: UnicodeString;
begin
  Result := ChildNodes['EVEPHONE'].Text;
end;

procedure TXMLCHGUSERINFORSType.SetEVEPHONE(Value: UnicodeString);
begin
  ChildNodes['EVEPHONE'].NodeValue := Value;
end;

function TXMLCHGUSERINFORSType.GetEMAIL: UnicodeString;
begin
  Result := ChildNodes['EMAIL'].Text;
end;

procedure TXMLCHGUSERINFORSType.SetEMAIL(Value: UnicodeString);
begin
  ChildNodes['EMAIL'].NodeValue := Value;
end;

function TXMLCHGUSERINFORSType.GetDTINFOCHG: UnicodeString;
begin
  Result := ChildNodes['DTINFOCHG'].Text;
end;

procedure TXMLCHGUSERINFORSType.SetDTINFOCHG(Value: UnicodeString);
begin
  ChildNodes['DTINFOCHG'].NodeValue := Value;
end;

{ TXMLCHGUSERINFOSYNCRSType }

procedure TXMLCHGUSERINFOSYNCRSType.AfterConstruction;
begin
  RegisterChildNode('CHGUSERINFOTRNRS', TXMLCHGUSERINFOTRNRSType);
  FCHGUSERINFOTRNRS := CreateCollection(TXMLCHGUSERINFOTRNRSTypeList, IXMLCHGUSERINFOTRNRSType, 'CHGUSERINFOTRNRS') as IXMLCHGUSERINFOTRNRSTypeList;
  inherited;
end;

function TXMLCHGUSERINFOSYNCRSType.GetSYNCRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRSMACRO'].Text;
end;

procedure TXMLCHGUSERINFOSYNCRSType.SetSYNCRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRSMACRO'].NodeValue := Value;
end;

function TXMLCHGUSERINFOSYNCRSType.GetCHGUSERINFOTRNRS: IXMLCHGUSERINFOTRNRSTypeList;
begin
  Result := FCHGUSERINFOTRNRS;
end;

{ TXMLCHGUSERINFOSYNCRSTypeList }

function TXMLCHGUSERINFOSYNCRSTypeList.Add: IXMLCHGUSERINFOSYNCRSType;
begin
  Result := AddItem(-1) as IXMLCHGUSERINFOSYNCRSType;
end;

function TXMLCHGUSERINFOSYNCRSTypeList.Insert(const Index: Integer): IXMLCHGUSERINFOSYNCRSType;
begin
  Result := AddItem(Index) as IXMLCHGUSERINFOSYNCRSType;
end;

function TXMLCHGUSERINFOSYNCRSTypeList.GetItem(Index: Integer): IXMLCHGUSERINFOSYNCRSType;
begin
  Result := List[Index] as IXMLCHGUSERINFOSYNCRSType;
end;

{ TXMLACCTTRNRSType }

procedure TXMLACCTTRNRSType.AfterConstruction;
begin
  RegisterChildNode('ACCTRS', TXMLACCTRSType);
  inherited;
end;

function TXMLACCTTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLACCTTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLACCTTRNRSType.GetACCTRS: IXMLACCTRSType;
begin
  Result := ChildNodes['ACCTRS'] as IXMLACCTRSType;
end;

{ TXMLACCTTRNRSTypeList }

function TXMLACCTTRNRSTypeList.Add: IXMLACCTTRNRSType;
begin
  Result := AddItem(-1) as IXMLACCTTRNRSType;
end;

function TXMLACCTTRNRSTypeList.Insert(const Index: Integer): IXMLACCTTRNRSType;
begin
  Result := AddItem(Index) as IXMLACCTTRNRSType;
end;

function TXMLACCTTRNRSTypeList.GetItem(Index: Integer): IXMLACCTTRNRSType;
begin
  Result := List[Index] as IXMLACCTTRNRSType;
end;

{ TXMLACCTRSType }

procedure TXMLACCTRSType.AfterConstruction;
begin
  RegisterChildNode('SVCADD', TXMLSVCADDType);
  RegisterChildNode('SVCCHG', TXMLSVCCHGType);
  RegisterChildNode('SVCDEL', TXMLSVCDELType);
  inherited;
end;

function TXMLACCTRSType.GetSVCADD: IXMLSVCADDType;
begin
  Result := ChildNodes['SVCADD'] as IXMLSVCADDType;
end;

function TXMLACCTRSType.GetSVCCHG: IXMLSVCCHGType;
begin
  Result := ChildNodes['SVCCHG'] as IXMLSVCCHGType;
end;

function TXMLACCTRSType.GetSVCDEL: IXMLSVCDELType;
begin
  Result := ChildNodes['SVCDEL'] as IXMLSVCDELType;
end;

function TXMLACCTRSType.GetSVC: UnicodeString;
begin
  Result := ChildNodes['SVC'].Text;
end;

procedure TXMLACCTRSType.SetSVC(Value: UnicodeString);
begin
  ChildNodes['SVC'].NodeValue := Value;
end;

function TXMLACCTRSType.GetSVCSTATUS: UnicodeString;
begin
  Result := ChildNodes['SVCSTATUS'].Text;
end;

procedure TXMLACCTRSType.SetSVCSTATUS(Value: UnicodeString);
begin
  ChildNodes['SVCSTATUS'].NodeValue := Value;
end;

{ TXMLACCTSYNCRSType }

procedure TXMLACCTSYNCRSType.AfterConstruction;
begin
  RegisterChildNode('ACCTTRNRS', TXMLACCTTRNRSType);
  FACCTTRNRS := CreateCollection(TXMLACCTTRNRSTypeList, IXMLACCTTRNRSType, 'ACCTTRNRS') as IXMLACCTTRNRSTypeList;
  inherited;
end;

function TXMLACCTSYNCRSType.GetSYNCRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRSMACRO'].Text;
end;

procedure TXMLACCTSYNCRSType.SetSYNCRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRSMACRO'].NodeValue := Value;
end;

function TXMLACCTSYNCRSType.GetACCTTRNRS: IXMLACCTTRNRSTypeList;
begin
  Result := FACCTTRNRS;
end;

{ TXMLACCTSYNCRSTypeList }

function TXMLACCTSYNCRSTypeList.Add: IXMLACCTSYNCRSType;
begin
  Result := AddItem(-1) as IXMLACCTSYNCRSType;
end;

function TXMLACCTSYNCRSTypeList.Insert(const Index: Integer): IXMLACCTSYNCRSType;
begin
  Result := AddItem(Index) as IXMLACCTSYNCRSType;
end;

function TXMLACCTSYNCRSTypeList.GetItem(Index: Integer): IXMLACCTSYNCRSType;
begin
  Result := List[Index] as IXMLACCTSYNCRSType;
end;

{ TXMLSIGNUPMSGSETType }

procedure TXMLSIGNUPMSGSETType.AfterConstruction;
begin
  RegisterChildNode('SIGNUPMSGSETV1', TXMLSIGNUPMSGSETV1Type);
  inherited;
end;

function TXMLSIGNUPMSGSETType.GetSIGNUPMSGSETV1: IXMLSIGNUPMSGSETV1Type;
begin
  Result := ChildNodes['SIGNUPMSGSETV1'] as IXMLSIGNUPMSGSETV1Type;
end;

{ TXMLSIGNUPMSGSETV1Type }

procedure TXMLSIGNUPMSGSETV1Type.AfterConstruction;
begin
  RegisterChildNode('MSGSETCORE', TXMLMSGSETCOREType);
  RegisterChildNode('CLIENTENROLL', TXMLCLIENTENROLLType);
  RegisterChildNode('WEBENROLL', TXMLWEBENROLLType);
  RegisterChildNode('OTHERENROLL', TXMLOTHERENROLLType);
  inherited;
end;

function TXMLSIGNUPMSGSETV1Type.GetMSGSETCORE: IXMLMSGSETCOREType;
begin
  Result := ChildNodes['MSGSETCORE'] as IXMLMSGSETCOREType;
end;

function TXMLSIGNUPMSGSETV1Type.GetCLIENTENROLL: IXMLCLIENTENROLLType;
begin
  Result := ChildNodes['CLIENTENROLL'] as IXMLCLIENTENROLLType;
end;

function TXMLSIGNUPMSGSETV1Type.GetWEBENROLL: IXMLWEBENROLLType;
begin
  Result := ChildNodes['WEBENROLL'] as IXMLWEBENROLLType;
end;

function TXMLSIGNUPMSGSETV1Type.GetOTHERENROLL: IXMLOTHERENROLLType;
begin
  Result := ChildNodes['OTHERENROLL'] as IXMLOTHERENROLLType;
end;

function TXMLSIGNUPMSGSETV1Type.GetCHGUSERINFO: UnicodeString;
begin
  Result := ChildNodes['CHGUSERINFO'].Text;
end;

procedure TXMLSIGNUPMSGSETV1Type.SetCHGUSERINFO(Value: UnicodeString);
begin
  ChildNodes['CHGUSERINFO'].NodeValue := Value;
end;

function TXMLSIGNUPMSGSETV1Type.GetAVAILACCTS: UnicodeString;
begin
  Result := ChildNodes['AVAILACCTS'].Text;
end;

procedure TXMLSIGNUPMSGSETV1Type.SetAVAILACCTS(Value: UnicodeString);
begin
  ChildNodes['AVAILACCTS'].NodeValue := Value;
end;

function TXMLSIGNUPMSGSETV1Type.GetCLIENTACTREQ: UnicodeString;
begin
  Result := ChildNodes['CLIENTACTREQ'].Text;
end;

procedure TXMLSIGNUPMSGSETV1Type.SetCLIENTACTREQ(Value: UnicodeString);
begin
  ChildNodes['CLIENTACTREQ'].NodeValue := Value;
end;

{ TXMLCLIENTENROLLType }

function TXMLCLIENTENROLLType.GetACCTREQUIRED: UnicodeString;
begin
  Result := ChildNodes['ACCTREQUIRED'].Text;
end;

procedure TXMLCLIENTENROLLType.SetACCTREQUIRED(Value: UnicodeString);
begin
  ChildNodes['ACCTREQUIRED'].NodeValue := Value;
end;

{ TXMLWEBENROLLType }

function TXMLWEBENROLLType.GetURL: UnicodeString;
begin
  Result := ChildNodes['URL'].Text;
end;

procedure TXMLWEBENROLLType.SetURL(Value: UnicodeString);
begin
  ChildNodes['URL'].NodeValue := Value;
end;

{ TXMLOTHERENROLLType }

function TXMLOTHERENROLLType.GetMESSAGE: UnicodeString;
begin
  Result := ChildNodes['MESSAGE'].Text;
end;

procedure TXMLOTHERENROLLType.SetMESSAGE(Value: UnicodeString);
begin
  ChildNodes['MESSAGE'].NodeValue := Value;
end;

{ TXMLINVSTMTMSGSRQV1Type }

procedure TXMLINVSTMTMSGSRQV1Type.AfterConstruction;
begin
  RegisterChildNode('INVSTMTTRNRQ', TXMLINVSTMTTRNRQType);
  RegisterChildNode('INVMAILTRNRQ', TXMLINVMAILTRNRQType);
  RegisterChildNode('INVMAILSYNCRQ', TXMLINVMAILSYNCRQType);
  FINVMAILTRNRQ := CreateCollection(TXMLINVMAILTRNRQTypeList, IXMLINVMAILTRNRQType, 'INVMAILTRNRQ') as IXMLINVMAILTRNRQTypeList;
  FINVMAILSYNCRQ := CreateCollection(TXMLINVMAILSYNCRQTypeList, IXMLINVMAILSYNCRQType, 'INVMAILSYNCRQ') as IXMLINVMAILSYNCRQTypeList;
  inherited;
end;

function TXMLINVSTMTMSGSRQV1Type.GetINVSTMTTRNRQ: IXMLINVSTMTTRNRQType;
begin
  Result := ChildNodes['INVSTMTTRNRQ'] as IXMLINVSTMTTRNRQType;
end;

function TXMLINVSTMTMSGSRQV1Type.GetINVMAILTRNRQ: IXMLINVMAILTRNRQTypeList;
begin
  Result := FINVMAILTRNRQ;
end;

function TXMLINVSTMTMSGSRQV1Type.GetINVMAILSYNCRQ: IXMLINVMAILSYNCRQTypeList;
begin
  Result := FINVMAILSYNCRQ;
end;

{ TXMLINVSTMTTRNRQType }

procedure TXMLINVSTMTTRNRQType.AfterConstruction;
begin
  RegisterChildNode('INVSTMTRQ', TXMLINVSTMTRQType);
  inherited;
end;

function TXMLINVSTMTTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLINVSTMTTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLINVSTMTTRNRQType.GetINVSTMTRQ: IXMLINVSTMTRQType;
begin
  Result := ChildNodes['INVSTMTRQ'] as IXMLINVSTMTRQType;
end;

{ TXMLINVSTMTRQType }

procedure TXMLINVSTMTRQType.AfterConstruction;
begin
  RegisterChildNode('INVACCTFROM', TXMLINVACCTFROMType);
  RegisterChildNode('INCTRAN', TXMLINCTRANType);
  RegisterChildNode('INCPOS', TXMLINCPOSType);
  inherited;
end;

function TXMLINVSTMTRQType.GetINVACCTFROM: IXMLINVACCTFROMType;
begin
  Result := ChildNodes['INVACCTFROM'] as IXMLINVACCTFROMType;
end;

function TXMLINVSTMTRQType.GetINCTRAN: IXMLINCTRANType;
begin
  Result := ChildNodes['INCTRAN'] as IXMLINCTRANType;
end;

function TXMLINVSTMTRQType.GetINCOO: UnicodeString;
begin
  Result := ChildNodes['INCOO'].Text;
end;

procedure TXMLINVSTMTRQType.SetINCOO(Value: UnicodeString);
begin
  ChildNodes['INCOO'].NodeValue := Value;
end;

function TXMLINVSTMTRQType.GetINCPOS: IXMLINCPOSType;
begin
  Result := ChildNodes['INCPOS'] as IXMLINCPOSType;
end;

function TXMLINVSTMTRQType.GetINCBAL: UnicodeString;
begin
  Result := ChildNodes['INCBAL'].Text;
end;

procedure TXMLINVSTMTRQType.SetINCBAL(Value: UnicodeString);
begin
  ChildNodes['INCBAL'].NodeValue := Value;
end;

{ TXMLINVACCTFROMType }

function TXMLINVACCTFROMType.GetBROKERID: UnicodeString;
begin
  Result := ChildNodes['BROKERID'].Text;
end;

procedure TXMLINVACCTFROMType.SetBROKERID(Value: UnicodeString);
begin
  ChildNodes['BROKERID'].NodeValue := Value;
end;

function TXMLINVACCTFROMType.GetACCTID: UnicodeString;
begin
  Result := ChildNodes['ACCTID'].Text;
end;

procedure TXMLINVACCTFROMType.SetACCTID(Value: UnicodeString);
begin
  ChildNodes['ACCTID'].NodeValue := Value;
end;

{ TXMLINCPOSType }

function TXMLINCPOSType.GetDTASOF: UnicodeString;
begin
  Result := ChildNodes['DTASOF'].Text;
end;

procedure TXMLINCPOSType.SetDTASOF(Value: UnicodeString);
begin
  ChildNodes['DTASOF'].NodeValue := Value;
end;

function TXMLINCPOSType.GetINCLUDE: UnicodeString;
begin
  Result := ChildNodes['INCLUDE'].Text;
end;

procedure TXMLINCPOSType.SetINCLUDE(Value: UnicodeString);
begin
  ChildNodes['INCLUDE'].NodeValue := Value;
end;

{ TXMLINVMAILTRNRQType }

procedure TXMLINVMAILTRNRQType.AfterConstruction;
begin
  RegisterChildNode('INVMAILRQ', TXMLINVMAILRQType);
  inherited;
end;

function TXMLINVMAILTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLINVMAILTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLINVMAILTRNRQType.GetINVMAILRQ: IXMLINVMAILRQType;
begin
  Result := ChildNodes['INVMAILRQ'] as IXMLINVMAILRQType;
end;

{ TXMLINVMAILTRNRQTypeList }

function TXMLINVMAILTRNRQTypeList.Add: IXMLINVMAILTRNRQType;
begin
  Result := AddItem(-1) as IXMLINVMAILTRNRQType;
end;

function TXMLINVMAILTRNRQTypeList.Insert(const Index: Integer): IXMLINVMAILTRNRQType;
begin
  Result := AddItem(Index) as IXMLINVMAILTRNRQType;
end;

function TXMLINVMAILTRNRQTypeList.GetItem(Index: Integer): IXMLINVMAILTRNRQType;
begin
  Result := List[Index] as IXMLINVMAILTRNRQType;
end;

{ TXMLINVMAILRQType }

procedure TXMLINVMAILRQType.AfterConstruction;
begin
  RegisterChildNode('INVACCTFROM', TXMLINVACCTFROMType);
  RegisterChildNode('MAIL', TXMLMAILType);
  inherited;
end;

function TXMLINVMAILRQType.GetINVACCTFROM: IXMLINVACCTFROMType;
begin
  Result := ChildNodes['INVACCTFROM'] as IXMLINVACCTFROMType;
end;

function TXMLINVMAILRQType.GetMAIL: IXMLMAILType;
begin
  Result := ChildNodes['MAIL'] as IXMLMAILType;
end;

{ TXMLINVMAILSYNCRQType }

procedure TXMLINVMAILSYNCRQType.AfterConstruction;
begin
  RegisterChildNode('INVACCTFROM', TXMLINVACCTFROMType);
  RegisterChildNode('INVMAILTRNRQ', TXMLINVMAILTRNRQType);
  FINVMAILTRNRQ := CreateCollection(TXMLINVMAILTRNRQTypeList, IXMLINVMAILTRNRQType, 'INVMAILTRNRQ') as IXMLINVMAILTRNRQTypeList;
  inherited;
end;

function TXMLINVMAILSYNCRQType.GetSYNCRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRQMACRO'].Text;
end;

procedure TXMLINVMAILSYNCRQType.SetSYNCRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRQMACRO'].NodeValue := Value;
end;

function TXMLINVMAILSYNCRQType.GetINCIMAGES: UnicodeString;
begin
  Result := ChildNodes['INCIMAGES'].Text;
end;

procedure TXMLINVMAILSYNCRQType.SetINCIMAGES(Value: UnicodeString);
begin
  ChildNodes['INCIMAGES'].NodeValue := Value;
end;

function TXMLINVMAILSYNCRQType.GetUSEHTML: UnicodeString;
begin
  Result := ChildNodes['USEHTML'].Text;
end;

procedure TXMLINVMAILSYNCRQType.SetUSEHTML(Value: UnicodeString);
begin
  ChildNodes['USEHTML'].NodeValue := Value;
end;

function TXMLINVMAILSYNCRQType.GetINVACCTFROM: IXMLINVACCTFROMType;
begin
  Result := ChildNodes['INVACCTFROM'] as IXMLINVACCTFROMType;
end;

function TXMLINVMAILSYNCRQType.GetINVMAILTRNRQ: IXMLINVMAILTRNRQTypeList;
begin
  Result := FINVMAILTRNRQ;
end;

{ TXMLINVMAILSYNCRQTypeList }

function TXMLINVMAILSYNCRQTypeList.Add: IXMLINVMAILSYNCRQType;
begin
  Result := AddItem(-1) as IXMLINVMAILSYNCRQType;
end;

function TXMLINVMAILSYNCRQTypeList.Insert(const Index: Integer): IXMLINVMAILSYNCRQType;
begin
  Result := AddItem(Index) as IXMLINVMAILSYNCRQType;
end;

function TXMLINVMAILSYNCRQTypeList.GetItem(Index: Integer): IXMLINVMAILSYNCRQType;
begin
  Result := List[Index] as IXMLINVMAILSYNCRQType;
end;

{ TXMLINVSTMTMSGSRSV1Type }

procedure TXMLINVSTMTMSGSRSV1Type.AfterConstruction;
begin
  RegisterChildNode('INVSTMTTRNRS', TXMLINVSTMTTRNRSType);
  RegisterChildNode('INVMAILTRNRS', TXMLINVMAILTRNRSType);
  RegisterChildNode('INVMAILSYNCRS', TXMLINVMAILSYNCRSType);
  FINVSTMTTRNRS := CreateCollection(TXMLINVSTMTTRNRSTypeList, IXMLINVSTMTTRNRSType, 'INVSTMTTRNRS') as IXMLINVSTMTTRNRSTypeList;
  FINVMAILTRNRS := CreateCollection(TXMLINVMAILTRNRSTypeList, IXMLINVMAILTRNRSType, 'INVMAILTRNRS') as IXMLINVMAILTRNRSTypeList;
  FINVMAILSYNCRS := CreateCollection(TXMLINVMAILSYNCRSTypeList, IXMLINVMAILSYNCRSType, 'INVMAILSYNCRS') as IXMLINVMAILSYNCRSTypeList;
  inherited;
end;

function TXMLINVSTMTMSGSRSV1Type.GetINVSTMTTRNRS: IXMLINVSTMTTRNRSTypeList;
begin
  Result := FINVSTMTTRNRS;
end;

function TXMLINVSTMTMSGSRSV1Type.GetINVMAILTRNRS: IXMLINVMAILTRNRSTypeList;
begin
  Result := FINVMAILTRNRS;
end;

function TXMLINVSTMTMSGSRSV1Type.GetINVMAILSYNCRS: IXMLINVMAILSYNCRSTypeList;
begin
  Result := FINVMAILSYNCRS;
end;

{ TXMLINVSTMTTRNRSType }

procedure TXMLINVSTMTTRNRSType.AfterConstruction;
begin
  RegisterChildNode('INVSTMTRS', TXMLINVSTMTRSType);
  inherited;
end;

function TXMLINVSTMTTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLINVSTMTTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLINVSTMTTRNRSType.GetINVSTMTRS: IXMLINVSTMTRSType;
begin
  Result := ChildNodes['INVSTMTRS'] as IXMLINVSTMTRSType;
end;

{ TXMLINVSTMTTRNRSTypeList }

function TXMLINVSTMTTRNRSTypeList.Add: IXMLINVSTMTTRNRSType;
begin
  Result := AddItem(-1) as IXMLINVSTMTTRNRSType;
end;

function TXMLINVSTMTTRNRSTypeList.Insert(const Index: Integer): IXMLINVSTMTTRNRSType;
begin
  Result := AddItem(Index) as IXMLINVSTMTTRNRSType;
end;

function TXMLINVSTMTTRNRSTypeList.GetItem(Index: Integer): IXMLINVSTMTTRNRSType;
begin
  Result := List[Index] as IXMLINVSTMTTRNRSType;
end;

{ TXMLINVSTMTRSType }

procedure TXMLINVSTMTRSType.AfterConstruction;
begin
  RegisterChildNode('INVACCTFROM', TXMLINVACCTFROMType);
  RegisterChildNode('INVTRANLIST', TXMLINVTRANLISTType);
  RegisterChildNode('INVPOSLIST', TXMLINVPOSLISTType);
  RegisterChildNode('INVBAL', TXMLINVBALType);
  RegisterChildNode('INVOOLIST', TXMLINVOOLISTType);
  inherited;
end;

function TXMLINVSTMTRSType.GetDTASOF: UnicodeString;
begin
  Result := ChildNodes['DTASOF'].Text;
end;

procedure TXMLINVSTMTRSType.SetDTASOF(Value: UnicodeString);
begin
  ChildNodes['DTASOF'].NodeValue := Value;
end;

function TXMLINVSTMTRSType.GetCURDEF: UnicodeString;
begin
  Result := ChildNodes['CURDEF'].Text;
end;

procedure TXMLINVSTMTRSType.SetCURDEF(Value: UnicodeString);
begin
  ChildNodes['CURDEF'].NodeValue := Value;
end;

function TXMLINVSTMTRSType.GetINVACCTFROM: IXMLINVACCTFROMType;
begin
  Result := ChildNodes['INVACCTFROM'] as IXMLINVACCTFROMType;
end;

function TXMLINVSTMTRSType.GetINVTRANLIST: IXMLINVTRANLISTType;
begin
  Result := ChildNodes['INVTRANLIST'] as IXMLINVTRANLISTType;
end;

function TXMLINVSTMTRSType.GetINVPOSLIST: IXMLINVPOSLISTType;
begin
  Result := ChildNodes['INVPOSLIST'] as IXMLINVPOSLISTType;
end;

function TXMLINVSTMTRSType.GetINVBAL: IXMLINVBALType;
begin
  Result := ChildNodes['INVBAL'] as IXMLINVBALType;
end;

function TXMLINVSTMTRSType.GetINVOOLIST: IXMLINVOOLISTType;
begin
  Result := ChildNodes['INVOOLIST'] as IXMLINVOOLISTType;
end;

function TXMLINVSTMTRSType.GetMKTGINFO: UnicodeString;
begin
  Result := ChildNodes['MKTGINFO'].Text;
end;

procedure TXMLINVSTMTRSType.SetMKTGINFO(Value: UnicodeString);
begin
  ChildNodes['MKTGINFO'].NodeValue := Value;
end;

{ TXMLINVTRANLISTType }

procedure TXMLINVTRANLISTType.AfterConstruction;
begin
  RegisterChildNode('BUYDEBT', TXMLBUYDEBTType);
  RegisterChildNode('BUYMF', TXMLBUYMFType);
  RegisterChildNode('BUYOPT', TXMLBUYOPTType);
  RegisterChildNode('BUYOTHER', TXMLBUYOTHERType);
  RegisterChildNode('BUYSTOCK', TXMLBUYSTOCKType);
  RegisterChildNode('CLOSUREOPT', TXMLCLOSUREOPTType);
  RegisterChildNode('INCOME', TXMLINCOMEType);
  RegisterChildNode('INVEXPENSE', TXMLINVEXPENSEType);
  RegisterChildNode('JRNLFUND', TXMLJRNLFUNDType);
  RegisterChildNode('JRNLSEC', TXMLJRNLSECType);
  RegisterChildNode('MARGININTEREST', TXMLMARGININTERESTType);
  RegisterChildNode('REINVEST', TXMLREINVESTType);
  RegisterChildNode('RETOFCAP', TXMLRETOFCAPType);
  RegisterChildNode('SELLDEBT', TXMLSELLDEBTType);
  RegisterChildNode('SELLMF', TXMLSELLMFType);
  RegisterChildNode('SELLOPT', TXMLSELLOPTType);
  RegisterChildNode('SELLOTHER', TXMLSELLOTHERType);
  RegisterChildNode('SELLSTOCK', TXMLSELLSTOCKType);
  RegisterChildNode('SPLIT', TXMLSPLITType);
  RegisterChildNode('TRANSFER', TXMLTRANSFERType);
  RegisterChildNode('INVBANKTRAN', TXMLINVBANKTRANType);
  FBUYDEBT := CreateCollection(TXMLBUYDEBTTypeList, IXMLBUYDEBTType, 'BUYDEBT') as IXMLBUYDEBTTypeList;
  FBUYMF := CreateCollection(TXMLBUYMFTypeList, IXMLBUYMFType, 'BUYMF') as IXMLBUYMFTypeList;
  FBUYOPT := CreateCollection(TXMLBUYOPTTypeList, IXMLBUYOPTType, 'BUYOPT') as IXMLBUYOPTTypeList;
  FBUYOTHER := CreateCollection(TXMLBUYOTHERTypeList, IXMLBUYOTHERType, 'BUYOTHER') as IXMLBUYOTHERTypeList;
  FBUYSTOCK := CreateCollection(TXMLBUYSTOCKTypeList, IXMLBUYSTOCKType, 'BUYSTOCK') as IXMLBUYSTOCKTypeList;
  FCLOSUREOPT := CreateCollection(TXMLCLOSUREOPTTypeList, IXMLCLOSUREOPTType, 'CLOSUREOPT') as IXMLCLOSUREOPTTypeList;
  FINCOME := CreateCollection(TXMLINCOMETypeList, IXMLINCOMEType, 'INCOME') as IXMLINCOMETypeList;
  FINVEXPENSE := CreateCollection(TXMLINVEXPENSETypeList, IXMLINVEXPENSEType, 'INVEXPENSE') as IXMLINVEXPENSETypeList;
  FJRNLFUND := CreateCollection(TXMLJRNLFUNDTypeList, IXMLJRNLFUNDType, 'JRNLFUND') as IXMLJRNLFUNDTypeList;
  FJRNLSEC := CreateCollection(TXMLJRNLSECTypeList, IXMLJRNLSECType, 'JRNLSEC') as IXMLJRNLSECTypeList;
  FMARGININTEREST := CreateCollection(TXMLMARGININTERESTTypeList, IXMLMARGININTERESTType, 'MARGININTEREST') as IXMLMARGININTERESTTypeList;
  FREINVEST := CreateCollection(TXMLREINVESTTypeList, IXMLREINVESTType, 'REINVEST') as IXMLREINVESTTypeList;
  FRETOFCAP := CreateCollection(TXMLRETOFCAPTypeList, IXMLRETOFCAPType, 'RETOFCAP') as IXMLRETOFCAPTypeList;
  FSELLDEBT := CreateCollection(TXMLSELLDEBTTypeList, IXMLSELLDEBTType, 'SELLDEBT') as IXMLSELLDEBTTypeList;
  FSELLMF := CreateCollection(TXMLSELLMFTypeList, IXMLSELLMFType, 'SELLMF') as IXMLSELLMFTypeList;
  FSELLOPT := CreateCollection(TXMLSELLOPTTypeList, IXMLSELLOPTType, 'SELLOPT') as IXMLSELLOPTTypeList;
  FSELLOTHER := CreateCollection(TXMLSELLOTHERTypeList, IXMLSELLOTHERType, 'SELLOTHER') as IXMLSELLOTHERTypeList;
  FSELLSTOCK := CreateCollection(TXMLSELLSTOCKTypeList, IXMLSELLSTOCKType, 'SELLSTOCK') as IXMLSELLSTOCKTypeList;
  FSPLIT := CreateCollection(TXMLSPLITTypeList, IXMLSPLITType, 'SPLIT') as IXMLSPLITTypeList;
  FTRANSFER := CreateCollection(TXMLTRANSFERTypeList, IXMLTRANSFERType, 'TRANSFER') as IXMLTRANSFERTypeList;
  FINVBANKTRAN := CreateCollection(TXMLINVBANKTRANTypeList, IXMLINVBANKTRANType, 'INVBANKTRAN') as IXMLINVBANKTRANTypeList;
  inherited;
end;

function TXMLINVTRANLISTType.GetDTSTART: UnicodeString;
begin
  Result := ChildNodes['DTSTART'].Text;
end;

procedure TXMLINVTRANLISTType.SetDTSTART(Value: UnicodeString);
begin
  ChildNodes['DTSTART'].NodeValue := Value;
end;

function TXMLINVTRANLISTType.GetDTEND: UnicodeString;
begin
  Result := ChildNodes['DTEND'].Text;
end;

procedure TXMLINVTRANLISTType.SetDTEND(Value: UnicodeString);
begin
  ChildNodes['DTEND'].NodeValue := Value;
end;

function TXMLINVTRANLISTType.GetBUYDEBT: IXMLBUYDEBTTypeList;
begin
  Result := FBUYDEBT;
end;

function TXMLINVTRANLISTType.GetBUYMF: IXMLBUYMFTypeList;
begin
  Result := FBUYMF;
end;

function TXMLINVTRANLISTType.GetBUYOPT: IXMLBUYOPTTypeList;
begin
  Result := FBUYOPT;
end;

function TXMLINVTRANLISTType.GetBUYOTHER: IXMLBUYOTHERTypeList;
begin
  Result := FBUYOTHER;
end;

function TXMLINVTRANLISTType.GetBUYSTOCK: IXMLBUYSTOCKTypeList;
begin
  Result := FBUYSTOCK;
end;

function TXMLINVTRANLISTType.GetCLOSUREOPT: IXMLCLOSUREOPTTypeList;
begin
  Result := FCLOSUREOPT;
end;

function TXMLINVTRANLISTType.GetINCOME: IXMLINCOMETypeList;
begin
  Result := FINCOME;
end;

function TXMLINVTRANLISTType.GetINVEXPENSE: IXMLINVEXPENSETypeList;
begin
  Result := FINVEXPENSE;
end;

function TXMLINVTRANLISTType.GetJRNLFUND: IXMLJRNLFUNDTypeList;
begin
  Result := FJRNLFUND;
end;

function TXMLINVTRANLISTType.GetJRNLSEC: IXMLJRNLSECTypeList;
begin
  Result := FJRNLSEC;
end;

function TXMLINVTRANLISTType.GetMARGININTEREST: IXMLMARGININTERESTTypeList;
begin
  Result := FMARGININTEREST;
end;

function TXMLINVTRANLISTType.GetREINVEST: IXMLREINVESTTypeList;
begin
  Result := FREINVEST;
end;

function TXMLINVTRANLISTType.GetRETOFCAP: IXMLRETOFCAPTypeList;
begin
  Result := FRETOFCAP;
end;

function TXMLINVTRANLISTType.GetSELLDEBT: IXMLSELLDEBTTypeList;
begin
  Result := FSELLDEBT;
end;

function TXMLINVTRANLISTType.GetSELLMF: IXMLSELLMFTypeList;
begin
  Result := FSELLMF;
end;

function TXMLINVTRANLISTType.GetSELLOPT: IXMLSELLOPTTypeList;
begin
  Result := FSELLOPT;
end;

function TXMLINVTRANLISTType.GetSELLOTHER: IXMLSELLOTHERTypeList;
begin
  Result := FSELLOTHER;
end;

function TXMLINVTRANLISTType.GetSELLSTOCK: IXMLSELLSTOCKTypeList;
begin
  Result := FSELLSTOCK;
end;

function TXMLINVTRANLISTType.GetSPLIT: IXMLSPLITTypeList;
begin
  Result := FSPLIT;
end;

function TXMLINVTRANLISTType.GetTRANSFER: IXMLTRANSFERTypeList;
begin
  Result := FTRANSFER;
end;

function TXMLINVTRANLISTType.GetINVBANKTRAN: IXMLINVBANKTRANTypeList;
begin
  Result := FINVBANKTRAN;
end;

{ TXMLBUYDEBTType }

procedure TXMLBUYDEBTType.AfterConstruction;
begin
  RegisterChildNode('INVBUY', TXMLINVBUYType);
  inherited;
end;

function TXMLBUYDEBTType.GetINVBUY: IXMLINVBUYType;
begin
  Result := ChildNodes['INVBUY'] as IXMLINVBUYType;
end;

function TXMLBUYDEBTType.GetACCRDINT: UnicodeString;
begin
  Result := ChildNodes['ACCRDINT'].Text;
end;

procedure TXMLBUYDEBTType.SetACCRDINT(Value: UnicodeString);
begin
  ChildNodes['ACCRDINT'].NodeValue := Value;
end;

{ TXMLBUYDEBTTypeList }

function TXMLBUYDEBTTypeList.Add: IXMLBUYDEBTType;
begin
  Result := AddItem(-1) as IXMLBUYDEBTType;
end;

function TXMLBUYDEBTTypeList.Insert(const Index: Integer): IXMLBUYDEBTType;
begin
  Result := AddItem(Index) as IXMLBUYDEBTType;
end;

function TXMLBUYDEBTTypeList.GetItem(Index: Integer): IXMLBUYDEBTType;
begin
  Result := List[Index] as IXMLBUYDEBTType;
end;

{ TXMLINVBUYType }

procedure TXMLINVBUYType.AfterConstruction;
begin
  RegisterChildNode('INVTRAN', TXMLINVTRANType);
  RegisterChildNode('SECID', TXMLSECIDType);
  RegisterChildNode('SUBACCTFUND', TXMLSUBACCTFUNDType);
  inherited;
end;

function TXMLINVBUYType.GetINVTRAN: IXMLINVTRANType;
begin
  Result := ChildNodes['INVTRAN'] as IXMLINVTRANType;
end;

function TXMLINVBUYType.GetSECID: IXMLSECIDType;
begin
  Result := ChildNodes['SECID'] as IXMLSECIDType;
end;

function TXMLINVBUYType.GetUNITS: UnicodeString;
begin
  Result := ChildNodes['UNITS'].Text;
end;

procedure TXMLINVBUYType.SetUNITS(Value: UnicodeString);
begin
  ChildNodes['UNITS'].NodeValue := Value;
end;

function TXMLINVBUYType.GetUNITPRICE: UnicodeString;
begin
  Result := ChildNodes['UNITPRICE'].Text;
end;

procedure TXMLINVBUYType.SetUNITPRICE(Value: UnicodeString);
begin
  ChildNodes['UNITPRICE'].NodeValue := Value;
end;

function TXMLINVBUYType.GetMARKUP: UnicodeString;
begin
  Result := ChildNodes['MARKUP'].Text;
end;

procedure TXMLINVBUYType.SetMARKUP(Value: UnicodeString);
begin
  ChildNodes['MARKUP'].NodeValue := Value;
end;

function TXMLINVBUYType.GetCOMMISSION: UnicodeString;
begin
  Result := ChildNodes['COMMISSION'].Text;
end;

procedure TXMLINVBUYType.SetCOMMISSION(Value: UnicodeString);
begin
  ChildNodes['COMMISSION'].NodeValue := Value;
end;

function TXMLINVBUYType.GetTAXES: UnicodeString;
begin
  Result := ChildNodes['TAXES'].Text;
end;

procedure TXMLINVBUYType.SetTAXES(Value: UnicodeString);
begin
  ChildNodes['TAXES'].NodeValue := Value;
end;

function TXMLINVBUYType.GetFEES: UnicodeString;
begin
  Result := ChildNodes['FEES'].Text;
end;

procedure TXMLINVBUYType.SetFEES(Value: UnicodeString);
begin
  ChildNodes['FEES'].NodeValue := Value;
end;

function TXMLINVBUYType.GetLOAD: UnicodeString;
begin
  Result := ChildNodes['LOAD'].Text;
end;

procedure TXMLINVBUYType.SetLOAD(Value: UnicodeString);
begin
  ChildNodes['LOAD'].NodeValue := Value;
end;

function TXMLINVBUYType.GetTOTAL: UnicodeString;
begin
  Result := ChildNodes['TOTAL'].Text;
end;

procedure TXMLINVBUYType.SetTOTAL(Value: UnicodeString);
begin
  ChildNodes['TOTAL'].NodeValue := Value;
end;

function TXMLINVBUYType.GetCURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLINVBUYType.SetCURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLINVBUYType.GetORIGCURRENCY: UnicodeString;
begin
  Result := ChildNodes['ORIGCURRENCY'].Text;
end;

procedure TXMLINVBUYType.SetORIGCURRENCY(Value: UnicodeString);
begin
  ChildNodes['ORIGCURRENCY'].NodeValue := Value;
end;

function TXMLINVBUYType.GetSUBACCTSEC: UnicodeString;
begin
  Result := ChildNodes['SUBACCTSEC'].Text;
end;

procedure TXMLINVBUYType.SetSUBACCTSEC(Value: UnicodeString);
begin
  ChildNodes['SUBACCTSEC'].NodeValue := Value;
end;

function TXMLINVBUYType.GetSUBACCTFUND: IXMLSUBACCTFUNDType;
begin
  Result := ChildNodes['SUBACCTFUND'] as IXMLSUBACCTFUNDType;
end;

{ TXMLINVTRANType }

function TXMLINVTRANType.GetFITID: UnicodeString;
begin
  Result := ChildNodes['FITID'].Text;
end;

procedure TXMLINVTRANType.SetFITID(Value: UnicodeString);
begin
  ChildNodes['FITID'].NodeValue := Value;
end;

function TXMLINVTRANType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLINVTRANType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

function TXMLINVTRANType.GetDTTRADE: UnicodeString;
begin
  Result := ChildNodes['DTTRADE'].Text;
end;

procedure TXMLINVTRANType.SetDTTRADE(Value: UnicodeString);
begin
  ChildNodes['DTTRADE'].NodeValue := Value;
end;

function TXMLINVTRANType.GetDTSETTLE: UnicodeString;
begin
  Result := ChildNodes['DTSETTLE'].Text;
end;

procedure TXMLINVTRANType.SetDTSETTLE(Value: UnicodeString);
begin
  ChildNodes['DTSETTLE'].NodeValue := Value;
end;

function TXMLINVTRANType.GetMEMO: UnicodeString;
begin
  Result := ChildNodes['MEMO'].Text;
end;

procedure TXMLINVTRANType.SetMEMO(Value: UnicodeString);
begin
  ChildNodes['MEMO'].NodeValue := Value;
end;

{ TXMLSECIDType }

function TXMLSECIDType.GetUNIQUEID: UnicodeString;
begin
  Result := ChildNodes['UNIQUEID'].Text;
end;

procedure TXMLSECIDType.SetUNIQUEID(Value: UnicodeString);
begin
  ChildNodes['UNIQUEID'].NodeValue := Value;
end;

function TXMLSECIDType.GetUNIQUEIDTYPE: UnicodeString;
begin
  Result := ChildNodes['UNIQUEIDTYPE'].Text;
end;

procedure TXMLSECIDType.SetUNIQUEIDTYPE(Value: UnicodeString);
begin
  ChildNodes['UNIQUEIDTYPE'].NodeValue := Value;
end;

{ TXMLSUBACCTFUNDType }

function TXMLSUBACCTFUNDType.GetSTRTYPE: UnicodeString;
begin
  Result := ChildNodes['%STRTYPE'].Text;
end;

procedure TXMLSUBACCTFUNDType.SetSTRTYPE(Value: UnicodeString);
begin
  ChildNodes['%STRTYPE'].NodeValue := Value;
end;

{ TXMLBUYMFType }

procedure TXMLBUYMFType.AfterConstruction;
begin
  RegisterChildNode('INVBUY', TXMLINVBUYType);
  inherited;
end;

function TXMLBUYMFType.GetINVBUY: IXMLINVBUYType;
begin
  Result := ChildNodes['INVBUY'] as IXMLINVBUYType;
end;

function TXMLBUYMFType.GetBUYTYPE: UnicodeString;
begin
  Result := ChildNodes['BUYTYPE'].Text;
end;

procedure TXMLBUYMFType.SetBUYTYPE(Value: UnicodeString);
begin
  ChildNodes['BUYTYPE'].NodeValue := Value;
end;

function TXMLBUYMFType.GetRELFITID: UnicodeString;
begin
  Result := ChildNodes['RELFITID'].Text;
end;

procedure TXMLBUYMFType.SetRELFITID(Value: UnicodeString);
begin
  ChildNodes['RELFITID'].NodeValue := Value;
end;

{ TXMLBUYMFTypeList }

function TXMLBUYMFTypeList.Add: IXMLBUYMFType;
begin
  Result := AddItem(-1) as IXMLBUYMFType;
end;

function TXMLBUYMFTypeList.Insert(const Index: Integer): IXMLBUYMFType;
begin
  Result := AddItem(Index) as IXMLBUYMFType;
end;

function TXMLBUYMFTypeList.GetItem(Index: Integer): IXMLBUYMFType;
begin
  Result := List[Index] as IXMLBUYMFType;
end;

{ TXMLBUYOPTType }

procedure TXMLBUYOPTType.AfterConstruction;
begin
  RegisterChildNode('INVBUY', TXMLINVBUYType);
  inherited;
end;

function TXMLBUYOPTType.GetINVBUY: IXMLINVBUYType;
begin
  Result := ChildNodes['INVBUY'] as IXMLINVBUYType;
end;

function TXMLBUYOPTType.GetOPTBUYTYPE: UnicodeString;
begin
  Result := ChildNodes['OPTBUYTYPE'].Text;
end;

procedure TXMLBUYOPTType.SetOPTBUYTYPE(Value: UnicodeString);
begin
  ChildNodes['OPTBUYTYPE'].NodeValue := Value;
end;

function TXMLBUYOPTType.GetSHPERCTRCT: UnicodeString;
begin
  Result := ChildNodes['SHPERCTRCT'].Text;
end;

procedure TXMLBUYOPTType.SetSHPERCTRCT(Value: UnicodeString);
begin
  ChildNodes['SHPERCTRCT'].NodeValue := Value;
end;

{ TXMLBUYOPTTypeList }

function TXMLBUYOPTTypeList.Add: IXMLBUYOPTType;
begin
  Result := AddItem(-1) as IXMLBUYOPTType;
end;

function TXMLBUYOPTTypeList.Insert(const Index: Integer): IXMLBUYOPTType;
begin
  Result := AddItem(Index) as IXMLBUYOPTType;
end;

function TXMLBUYOPTTypeList.GetItem(Index: Integer): IXMLBUYOPTType;
begin
  Result := List[Index] as IXMLBUYOPTType;
end;

{ TXMLBUYOTHERType }

procedure TXMLBUYOTHERType.AfterConstruction;
begin
  RegisterChildNode('INVBUY', TXMLINVBUYType);
  inherited;
end;

function TXMLBUYOTHERType.GetINVBUY: IXMLINVBUYType;
begin
  Result := ChildNodes['INVBUY'] as IXMLINVBUYType;
end;

{ TXMLBUYOTHERTypeList }

function TXMLBUYOTHERTypeList.Add: IXMLBUYOTHERType;
begin
  Result := AddItem(-1) as IXMLBUYOTHERType;
end;

function TXMLBUYOTHERTypeList.Insert(const Index: Integer): IXMLBUYOTHERType;
begin
  Result := AddItem(Index) as IXMLBUYOTHERType;
end;

function TXMLBUYOTHERTypeList.GetItem(Index: Integer): IXMLBUYOTHERType;
begin
  Result := List[Index] as IXMLBUYOTHERType;
end;

{ TXMLBUYSTOCKType }

procedure TXMLBUYSTOCKType.AfterConstruction;
begin
  RegisterChildNode('INVBUY', TXMLINVBUYType);
  inherited;
end;

function TXMLBUYSTOCKType.GetINVBUY: IXMLINVBUYType;
begin
  Result := ChildNodes['INVBUY'] as IXMLINVBUYType;
end;

function TXMLBUYSTOCKType.GetBUYTYPE: UnicodeString;
begin
  Result := ChildNodes['BUYTYPE'].Text;
end;

procedure TXMLBUYSTOCKType.SetBUYTYPE(Value: UnicodeString);
begin
  ChildNodes['BUYTYPE'].NodeValue := Value;
end;

{ TXMLBUYSTOCKTypeList }

function TXMLBUYSTOCKTypeList.Add: IXMLBUYSTOCKType;
begin
  Result := AddItem(-1) as IXMLBUYSTOCKType;
end;

function TXMLBUYSTOCKTypeList.Insert(const Index: Integer): IXMLBUYSTOCKType;
begin
  Result := AddItem(Index) as IXMLBUYSTOCKType;
end;

function TXMLBUYSTOCKTypeList.GetItem(Index: Integer): IXMLBUYSTOCKType;
begin
  Result := List[Index] as IXMLBUYSTOCKType;
end;

{ TXMLCLOSUREOPTType }

procedure TXMLCLOSUREOPTType.AfterConstruction;
begin
  RegisterChildNode('INVTRAN', TXMLINVTRANType);
  RegisterChildNode('SECID', TXMLSECIDType);
  inherited;
end;

function TXMLCLOSUREOPTType.GetINVTRAN: IXMLINVTRANType;
begin
  Result := ChildNodes['INVTRAN'] as IXMLINVTRANType;
end;

function TXMLCLOSUREOPTType.GetSECID: IXMLSECIDType;
begin
  Result := ChildNodes['SECID'] as IXMLSECIDType;
end;

function TXMLCLOSUREOPTType.GetOPTACTION: UnicodeString;
begin
  Result := ChildNodes['OPTACTION'].Text;
end;

procedure TXMLCLOSUREOPTType.SetOPTACTION(Value: UnicodeString);
begin
  ChildNodes['OPTACTION'].NodeValue := Value;
end;

function TXMLCLOSUREOPTType.GetUNITS: UnicodeString;
begin
  Result := ChildNodes['UNITS'].Text;
end;

procedure TXMLCLOSUREOPTType.SetUNITS(Value: UnicodeString);
begin
  ChildNodes['UNITS'].NodeValue := Value;
end;

function TXMLCLOSUREOPTType.GetSHPERCTRCT: UnicodeString;
begin
  Result := ChildNodes['SHPERCTRCT'].Text;
end;

procedure TXMLCLOSUREOPTType.SetSHPERCTRCT(Value: UnicodeString);
begin
  ChildNodes['SHPERCTRCT'].NodeValue := Value;
end;

function TXMLCLOSUREOPTType.GetSUBACCTSEC: UnicodeString;
begin
  Result := ChildNodes['SUBACCTSEC'].Text;
end;

procedure TXMLCLOSUREOPTType.SetSUBACCTSEC(Value: UnicodeString);
begin
  ChildNodes['SUBACCTSEC'].NodeValue := Value;
end;

function TXMLCLOSUREOPTType.GetRELFITID: UnicodeString;
begin
  Result := ChildNodes['RELFITID'].Text;
end;

procedure TXMLCLOSUREOPTType.SetRELFITID(Value: UnicodeString);
begin
  ChildNodes['RELFITID'].NodeValue := Value;
end;

function TXMLCLOSUREOPTType.GetGAIN: UnicodeString;
begin
  Result := ChildNodes['GAIN'].Text;
end;

procedure TXMLCLOSUREOPTType.SetGAIN(Value: UnicodeString);
begin
  ChildNodes['GAIN'].NodeValue := Value;
end;

{ TXMLCLOSUREOPTTypeList }

function TXMLCLOSUREOPTTypeList.Add: IXMLCLOSUREOPTType;
begin
  Result := AddItem(-1) as IXMLCLOSUREOPTType;
end;

function TXMLCLOSUREOPTTypeList.Insert(const Index: Integer): IXMLCLOSUREOPTType;
begin
  Result := AddItem(Index) as IXMLCLOSUREOPTType;
end;

function TXMLCLOSUREOPTTypeList.GetItem(Index: Integer): IXMLCLOSUREOPTType;
begin
  Result := List[Index] as IXMLCLOSUREOPTType;
end;

{ TXMLINCOMEType }

procedure TXMLINCOMEType.AfterConstruction;
begin
  RegisterChildNode('INVTRAN', TXMLINVTRANType);
  RegisterChildNode('SECID', TXMLSECIDType);
  RegisterChildNode('SUBACCTFUND', TXMLSUBACCTFUNDType);
  inherited;
end;

function TXMLINCOMEType.GetINVTRAN: IXMLINVTRANType;
begin
  Result := ChildNodes['INVTRAN'] as IXMLINVTRANType;
end;

function TXMLINCOMEType.GetSECID: IXMLSECIDType;
begin
  Result := ChildNodes['SECID'] as IXMLSECIDType;
end;

function TXMLINCOMEType.GetINCOMETYPE: UnicodeString;
begin
  Result := ChildNodes['INCOMETYPE'].Text;
end;

procedure TXMLINCOMEType.SetINCOMETYPE(Value: UnicodeString);
begin
  ChildNodes['INCOMETYPE'].NodeValue := Value;
end;

function TXMLINCOMEType.GetTOTAL: UnicodeString;
begin
  Result := ChildNodes['TOTAL'].Text;
end;

procedure TXMLINCOMEType.SetTOTAL(Value: UnicodeString);
begin
  ChildNodes['TOTAL'].NodeValue := Value;
end;

function TXMLINCOMEType.GetSUBACCTSEC: UnicodeString;
begin
  Result := ChildNodes['SUBACCTSEC'].Text;
end;

procedure TXMLINCOMEType.SetSUBACCTSEC(Value: UnicodeString);
begin
  ChildNodes['SUBACCTSEC'].NodeValue := Value;
end;

function TXMLINCOMEType.GetSUBACCTFUND: IXMLSUBACCTFUNDType;
begin
  Result := ChildNodes['SUBACCTFUND'] as IXMLSUBACCTFUNDType;
end;

function TXMLINCOMEType.GetTAXEXEMPT: UnicodeString;
begin
  Result := ChildNodes['TAXEXEMPT'].Text;
end;

procedure TXMLINCOMEType.SetTAXEXEMPT(Value: UnicodeString);
begin
  ChildNodes['TAXEXEMPT'].NodeValue := Value;
end;

function TXMLINCOMEType.GetWITHHOLDING: UnicodeString;
begin
  Result := ChildNodes['WITHHOLDING'].Text;
end;

procedure TXMLINCOMEType.SetWITHHOLDING(Value: UnicodeString);
begin
  ChildNodes['WITHHOLDING'].NodeValue := Value;
end;

function TXMLINCOMEType.GetCURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLINCOMEType.SetCURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLINCOMEType.GetORIGCURRENCY: UnicodeString;
begin
  Result := ChildNodes['ORIGCURRENCY'].Text;
end;

procedure TXMLINCOMEType.SetORIGCURRENCY(Value: UnicodeString);
begin
  ChildNodes['ORIGCURRENCY'].NodeValue := Value;
end;

{ TXMLINCOMETypeList }

function TXMLINCOMETypeList.Add: IXMLINCOMEType;
begin
  Result := AddItem(-1) as IXMLINCOMEType;
end;

function TXMLINCOMETypeList.Insert(const Index: Integer): IXMLINCOMEType;
begin
  Result := AddItem(Index) as IXMLINCOMEType;
end;

function TXMLINCOMETypeList.GetItem(Index: Integer): IXMLINCOMEType;
begin
  Result := List[Index] as IXMLINCOMEType;
end;

{ TXMLINVEXPENSEType }

procedure TXMLINVEXPENSEType.AfterConstruction;
begin
  RegisterChildNode('INVTRAN', TXMLINVTRANType);
  RegisterChildNode('SECID', TXMLSECIDType);
  RegisterChildNode('SUBACCTFUND', TXMLSUBACCTFUNDType);
  inherited;
end;

function TXMLINVEXPENSEType.GetINVTRAN: IXMLINVTRANType;
begin
  Result := ChildNodes['INVTRAN'] as IXMLINVTRANType;
end;

function TXMLINVEXPENSEType.GetSECID: IXMLSECIDType;
begin
  Result := ChildNodes['SECID'] as IXMLSECIDType;
end;

function TXMLINVEXPENSEType.GetTOTAL: UnicodeString;
begin
  Result := ChildNodes['TOTAL'].Text;
end;

procedure TXMLINVEXPENSEType.SetTOTAL(Value: UnicodeString);
begin
  ChildNodes['TOTAL'].NodeValue := Value;
end;

function TXMLINVEXPENSEType.GetSUBACCTSEC: UnicodeString;
begin
  Result := ChildNodes['SUBACCTSEC'].Text;
end;

procedure TXMLINVEXPENSEType.SetSUBACCTSEC(Value: UnicodeString);
begin
  ChildNodes['SUBACCTSEC'].NodeValue := Value;
end;

function TXMLINVEXPENSEType.GetSUBACCTFUND: IXMLSUBACCTFUNDType;
begin
  Result := ChildNodes['SUBACCTFUND'] as IXMLSUBACCTFUNDType;
end;

function TXMLINVEXPENSEType.GetCURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLINVEXPENSEType.SetCURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLINVEXPENSEType.GetORIGCURRENCY: UnicodeString;
begin
  Result := ChildNodes['ORIGCURRENCY'].Text;
end;

procedure TXMLINVEXPENSEType.SetORIGCURRENCY(Value: UnicodeString);
begin
  ChildNodes['ORIGCURRENCY'].NodeValue := Value;
end;

{ TXMLINVEXPENSETypeList }

function TXMLINVEXPENSETypeList.Add: IXMLINVEXPENSEType;
begin
  Result := AddItem(-1) as IXMLINVEXPENSEType;
end;

function TXMLINVEXPENSETypeList.Insert(const Index: Integer): IXMLINVEXPENSEType;
begin
  Result := AddItem(Index) as IXMLINVEXPENSEType;
end;

function TXMLINVEXPENSETypeList.GetItem(Index: Integer): IXMLINVEXPENSEType;
begin
  Result := List[Index] as IXMLINVEXPENSEType;
end;

{ TXMLJRNLFUNDType }

procedure TXMLJRNLFUNDType.AfterConstruction;
begin
  RegisterChildNode('INVTRAN', TXMLINVTRANType);
  inherited;
end;

function TXMLJRNLFUNDType.GetINVTRAN: IXMLINVTRANType;
begin
  Result := ChildNodes['INVTRAN'] as IXMLINVTRANType;
end;

function TXMLJRNLFUNDType.GetSUBACCTTO: UnicodeString;
begin
  Result := ChildNodes['SUBACCTTO'].Text;
end;

procedure TXMLJRNLFUNDType.SetSUBACCTTO(Value: UnicodeString);
begin
  ChildNodes['SUBACCTTO'].NodeValue := Value;
end;

function TXMLJRNLFUNDType.GetSUBACCTFROM: UnicodeString;
begin
  Result := ChildNodes['SUBACCTFROM'].Text;
end;

procedure TXMLJRNLFUNDType.SetSUBACCTFROM(Value: UnicodeString);
begin
  ChildNodes['SUBACCTFROM'].NodeValue := Value;
end;

function TXMLJRNLFUNDType.GetTOTAL: UnicodeString;
begin
  Result := ChildNodes['TOTAL'].Text;
end;

procedure TXMLJRNLFUNDType.SetTOTAL(Value: UnicodeString);
begin
  ChildNodes['TOTAL'].NodeValue := Value;
end;

{ TXMLJRNLFUNDTypeList }

function TXMLJRNLFUNDTypeList.Add: IXMLJRNLFUNDType;
begin
  Result := AddItem(-1) as IXMLJRNLFUNDType;
end;

function TXMLJRNLFUNDTypeList.Insert(const Index: Integer): IXMLJRNLFUNDType;
begin
  Result := AddItem(Index) as IXMLJRNLFUNDType;
end;

function TXMLJRNLFUNDTypeList.GetItem(Index: Integer): IXMLJRNLFUNDType;
begin
  Result := List[Index] as IXMLJRNLFUNDType;
end;

{ TXMLJRNLSECType }

procedure TXMLJRNLSECType.AfterConstruction;
begin
  RegisterChildNode('INVTRAN', TXMLINVTRANType);
  RegisterChildNode('SECID', TXMLSECIDType);
  inherited;
end;

function TXMLJRNLSECType.GetINVTRAN: IXMLINVTRANType;
begin
  Result := ChildNodes['INVTRAN'] as IXMLINVTRANType;
end;

function TXMLJRNLSECType.GetSECID: IXMLSECIDType;
begin
  Result := ChildNodes['SECID'] as IXMLSECIDType;
end;

function TXMLJRNLSECType.GetSUBACCTTO: UnicodeString;
begin
  Result := ChildNodes['SUBACCTTO'].Text;
end;

procedure TXMLJRNLSECType.SetSUBACCTTO(Value: UnicodeString);
begin
  ChildNodes['SUBACCTTO'].NodeValue := Value;
end;

function TXMLJRNLSECType.GetSUBACCTFROM: UnicodeString;
begin
  Result := ChildNodes['SUBACCTFROM'].Text;
end;

procedure TXMLJRNLSECType.SetSUBACCTFROM(Value: UnicodeString);
begin
  ChildNodes['SUBACCTFROM'].NodeValue := Value;
end;

function TXMLJRNLSECType.GetUNITS: UnicodeString;
begin
  Result := ChildNodes['UNITS'].Text;
end;

procedure TXMLJRNLSECType.SetUNITS(Value: UnicodeString);
begin
  ChildNodes['UNITS'].NodeValue := Value;
end;

{ TXMLJRNLSECTypeList }

function TXMLJRNLSECTypeList.Add: IXMLJRNLSECType;
begin
  Result := AddItem(-1) as IXMLJRNLSECType;
end;

function TXMLJRNLSECTypeList.Insert(const Index: Integer): IXMLJRNLSECType;
begin
  Result := AddItem(Index) as IXMLJRNLSECType;
end;

function TXMLJRNLSECTypeList.GetItem(Index: Integer): IXMLJRNLSECType;
begin
  Result := List[Index] as IXMLJRNLSECType;
end;

{ TXMLMARGININTERESTType }

procedure TXMLMARGININTERESTType.AfterConstruction;
begin
  RegisterChildNode('INVTRAN', TXMLINVTRANType);
  RegisterChildNode('SUBACCTFUND', TXMLSUBACCTFUNDType);
  inherited;
end;

function TXMLMARGININTERESTType.GetINVTRAN: IXMLINVTRANType;
begin
  Result := ChildNodes['INVTRAN'] as IXMLINVTRANType;
end;

function TXMLMARGININTERESTType.GetTOTAL: UnicodeString;
begin
  Result := ChildNodes['TOTAL'].Text;
end;

procedure TXMLMARGININTERESTType.SetTOTAL(Value: UnicodeString);
begin
  ChildNodes['TOTAL'].NodeValue := Value;
end;

function TXMLMARGININTERESTType.GetSUBACCTFUND: IXMLSUBACCTFUNDType;
begin
  Result := ChildNodes['SUBACCTFUND'] as IXMLSUBACCTFUNDType;
end;

function TXMLMARGININTERESTType.GetCURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLMARGININTERESTType.SetCURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLMARGININTERESTType.GetORIGCURRENCY: UnicodeString;
begin
  Result := ChildNodes['ORIGCURRENCY'].Text;
end;

procedure TXMLMARGININTERESTType.SetORIGCURRENCY(Value: UnicodeString);
begin
  ChildNodes['ORIGCURRENCY'].NodeValue := Value;
end;

{ TXMLMARGININTERESTTypeList }

function TXMLMARGININTERESTTypeList.Add: IXMLMARGININTERESTType;
begin
  Result := AddItem(-1) as IXMLMARGININTERESTType;
end;

function TXMLMARGININTERESTTypeList.Insert(const Index: Integer): IXMLMARGININTERESTType;
begin
  Result := AddItem(Index) as IXMLMARGININTERESTType;
end;

function TXMLMARGININTERESTTypeList.GetItem(Index: Integer): IXMLMARGININTERESTType;
begin
  Result := List[Index] as IXMLMARGININTERESTType;
end;

{ TXMLREINVESTType }

procedure TXMLREINVESTType.AfterConstruction;
begin
  RegisterChildNode('INVTRAN', TXMLINVTRANType);
  RegisterChildNode('SECID', TXMLSECIDType);
  inherited;
end;

function TXMLREINVESTType.GetINVTRAN: IXMLINVTRANType;
begin
  Result := ChildNodes['INVTRAN'] as IXMLINVTRANType;
end;

function TXMLREINVESTType.GetSECID: IXMLSECIDType;
begin
  Result := ChildNodes['SECID'] as IXMLSECIDType;
end;

function TXMLREINVESTType.GetINCOMETYPE: UnicodeString;
begin
  Result := ChildNodes['INCOMETYPE'].Text;
end;

procedure TXMLREINVESTType.SetINCOMETYPE(Value: UnicodeString);
begin
  ChildNodes['INCOMETYPE'].NodeValue := Value;
end;

function TXMLREINVESTType.GetTOTAL: UnicodeString;
begin
  Result := ChildNodes['TOTAL'].Text;
end;

procedure TXMLREINVESTType.SetTOTAL(Value: UnicodeString);
begin
  ChildNodes['TOTAL'].NodeValue := Value;
end;

function TXMLREINVESTType.GetSUBACCTSEC: UnicodeString;
begin
  Result := ChildNodes['SUBACCTSEC'].Text;
end;

procedure TXMLREINVESTType.SetSUBACCTSEC(Value: UnicodeString);
begin
  ChildNodes['SUBACCTSEC'].NodeValue := Value;
end;

function TXMLREINVESTType.GetUNITS: UnicodeString;
begin
  Result := ChildNodes['UNITS'].Text;
end;

procedure TXMLREINVESTType.SetUNITS(Value: UnicodeString);
begin
  ChildNodes['UNITS'].NodeValue := Value;
end;

function TXMLREINVESTType.GetUNITPRICE: UnicodeString;
begin
  Result := ChildNodes['UNITPRICE'].Text;
end;

procedure TXMLREINVESTType.SetUNITPRICE(Value: UnicodeString);
begin
  ChildNodes['UNITPRICE'].NodeValue := Value;
end;

function TXMLREINVESTType.GetCOMMISSION: UnicodeString;
begin
  Result := ChildNodes['COMMISSION'].Text;
end;

procedure TXMLREINVESTType.SetCOMMISSION(Value: UnicodeString);
begin
  ChildNodes['COMMISSION'].NodeValue := Value;
end;

function TXMLREINVESTType.GetTAXES: UnicodeString;
begin
  Result := ChildNodes['TAXES'].Text;
end;

procedure TXMLREINVESTType.SetTAXES(Value: UnicodeString);
begin
  ChildNodes['TAXES'].NodeValue := Value;
end;

function TXMLREINVESTType.GetFEES: UnicodeString;
begin
  Result := ChildNodes['FEES'].Text;
end;

procedure TXMLREINVESTType.SetFEES(Value: UnicodeString);
begin
  ChildNodes['FEES'].NodeValue := Value;
end;

function TXMLREINVESTType.GetLOAD: UnicodeString;
begin
  Result := ChildNodes['LOAD'].Text;
end;

procedure TXMLREINVESTType.SetLOAD(Value: UnicodeString);
begin
  ChildNodes['LOAD'].NodeValue := Value;
end;

function TXMLREINVESTType.GetTAXEXEMPT: UnicodeString;
begin
  Result := ChildNodes['TAXEXEMPT'].Text;
end;

procedure TXMLREINVESTType.SetTAXEXEMPT(Value: UnicodeString);
begin
  ChildNodes['TAXEXEMPT'].NodeValue := Value;
end;

function TXMLREINVESTType.GetCURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLREINVESTType.SetCURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLREINVESTType.GetORIGCURRENCY: UnicodeString;
begin
  Result := ChildNodes['ORIGCURRENCY'].Text;
end;

procedure TXMLREINVESTType.SetORIGCURRENCY(Value: UnicodeString);
begin
  ChildNodes['ORIGCURRENCY'].NodeValue := Value;
end;

{ TXMLREINVESTTypeList }

function TXMLREINVESTTypeList.Add: IXMLREINVESTType;
begin
  Result := AddItem(-1) as IXMLREINVESTType;
end;

function TXMLREINVESTTypeList.Insert(const Index: Integer): IXMLREINVESTType;
begin
  Result := AddItem(Index) as IXMLREINVESTType;
end;

function TXMLREINVESTTypeList.GetItem(Index: Integer): IXMLREINVESTType;
begin
  Result := List[Index] as IXMLREINVESTType;
end;

{ TXMLRETOFCAPType }

procedure TXMLRETOFCAPType.AfterConstruction;
begin
  RegisterChildNode('INVTRAN', TXMLINVTRANType);
  RegisterChildNode('SECID', TXMLSECIDType);
  RegisterChildNode('SUBACCTFUND', TXMLSUBACCTFUNDType);
  inherited;
end;

function TXMLRETOFCAPType.GetINVTRAN: IXMLINVTRANType;
begin
  Result := ChildNodes['INVTRAN'] as IXMLINVTRANType;
end;

function TXMLRETOFCAPType.GetSECID: IXMLSECIDType;
begin
  Result := ChildNodes['SECID'] as IXMLSECIDType;
end;

function TXMLRETOFCAPType.GetTOTAL: UnicodeString;
begin
  Result := ChildNodes['TOTAL'].Text;
end;

procedure TXMLRETOFCAPType.SetTOTAL(Value: UnicodeString);
begin
  ChildNodes['TOTAL'].NodeValue := Value;
end;

function TXMLRETOFCAPType.GetSUBACCTSEC: UnicodeString;
begin
  Result := ChildNodes['SUBACCTSEC'].Text;
end;

procedure TXMLRETOFCAPType.SetSUBACCTSEC(Value: UnicodeString);
begin
  ChildNodes['SUBACCTSEC'].NodeValue := Value;
end;

function TXMLRETOFCAPType.GetSUBACCTFUND: IXMLSUBACCTFUNDType;
begin
  Result := ChildNodes['SUBACCTFUND'] as IXMLSUBACCTFUNDType;
end;

function TXMLRETOFCAPType.GetCURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLRETOFCAPType.SetCURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLRETOFCAPType.GetORIGCURRENCY: UnicodeString;
begin
  Result := ChildNodes['ORIGCURRENCY'].Text;
end;

procedure TXMLRETOFCAPType.SetORIGCURRENCY(Value: UnicodeString);
begin
  ChildNodes['ORIGCURRENCY'].NodeValue := Value;
end;

{ TXMLRETOFCAPTypeList }

function TXMLRETOFCAPTypeList.Add: IXMLRETOFCAPType;
begin
  Result := AddItem(-1) as IXMLRETOFCAPType;
end;

function TXMLRETOFCAPTypeList.Insert(const Index: Integer): IXMLRETOFCAPType;
begin
  Result := AddItem(Index) as IXMLRETOFCAPType;
end;

function TXMLRETOFCAPTypeList.GetItem(Index: Integer): IXMLRETOFCAPType;
begin
  Result := List[Index] as IXMLRETOFCAPType;
end;

{ TXMLSELLDEBTType }

procedure TXMLSELLDEBTType.AfterConstruction;
begin
  RegisterChildNode('INVSELL', TXMLINVSELLType);
  inherited;
end;

function TXMLSELLDEBTType.GetINVSELL: IXMLINVSELLType;
begin
  Result := ChildNodes['INVSELL'] as IXMLINVSELLType;
end;

function TXMLSELLDEBTType.GetSELLREASON: UnicodeString;
begin
  Result := ChildNodes['SELLREASON'].Text;
end;

procedure TXMLSELLDEBTType.SetSELLREASON(Value: UnicodeString);
begin
  ChildNodes['SELLREASON'].NodeValue := Value;
end;

function TXMLSELLDEBTType.GetACCRDINT: UnicodeString;
begin
  Result := ChildNodes['ACCRDINT'].Text;
end;

procedure TXMLSELLDEBTType.SetACCRDINT(Value: UnicodeString);
begin
  ChildNodes['ACCRDINT'].NodeValue := Value;
end;

{ TXMLSELLDEBTTypeList }

function TXMLSELLDEBTTypeList.Add: IXMLSELLDEBTType;
begin
  Result := AddItem(-1) as IXMLSELLDEBTType;
end;

function TXMLSELLDEBTTypeList.Insert(const Index: Integer): IXMLSELLDEBTType;
begin
  Result := AddItem(Index) as IXMLSELLDEBTType;
end;

function TXMLSELLDEBTTypeList.GetItem(Index: Integer): IXMLSELLDEBTType;
begin
  Result := List[Index] as IXMLSELLDEBTType;
end;

{ TXMLINVSELLType }

procedure TXMLINVSELLType.AfterConstruction;
begin
  RegisterChildNode('INVTRAN', TXMLINVTRANType);
  RegisterChildNode('SECID', TXMLSECIDType);
  RegisterChildNode('SUBACCTFUND', TXMLSUBACCTFUNDType);
  inherited;
end;

function TXMLINVSELLType.GetINVTRAN: IXMLINVTRANType;
begin
  Result := ChildNodes['INVTRAN'] as IXMLINVTRANType;
end;

function TXMLINVSELLType.GetSECID: IXMLSECIDType;
begin
  Result := ChildNodes['SECID'] as IXMLSECIDType;
end;

function TXMLINVSELLType.GetUNITS: UnicodeString;
begin
  Result := ChildNodes['UNITS'].Text;
end;

procedure TXMLINVSELLType.SetUNITS(Value: UnicodeString);
begin
  ChildNodes['UNITS'].NodeValue := Value;
end;

function TXMLINVSELLType.GetUNITPRICE: UnicodeString;
begin
  Result := ChildNodes['UNITPRICE'].Text;
end;

procedure TXMLINVSELLType.SetUNITPRICE(Value: UnicodeString);
begin
  ChildNodes['UNITPRICE'].NodeValue := Value;
end;

function TXMLINVSELLType.GetMARKDOWN: UnicodeString;
begin
  Result := ChildNodes['MARKDOWN'].Text;
end;

procedure TXMLINVSELLType.SetMARKDOWN(Value: UnicodeString);
begin
  ChildNodes['MARKDOWN'].NodeValue := Value;
end;

function TXMLINVSELLType.GetCOMMISSION: UnicodeString;
begin
  Result := ChildNodes['COMMISSION'].Text;
end;

procedure TXMLINVSELLType.SetCOMMISSION(Value: UnicodeString);
begin
  ChildNodes['COMMISSION'].NodeValue := Value;
end;

function TXMLINVSELLType.GetTAXES: UnicodeString;
begin
  Result := ChildNodes['TAXES'].Text;
end;

procedure TXMLINVSELLType.SetTAXES(Value: UnicodeString);
begin
  ChildNodes['TAXES'].NodeValue := Value;
end;

function TXMLINVSELLType.GetFEES: UnicodeString;
begin
  Result := ChildNodes['FEES'].Text;
end;

procedure TXMLINVSELLType.SetFEES(Value: UnicodeString);
begin
  ChildNodes['FEES'].NodeValue := Value;
end;

function TXMLINVSELLType.GetLOAD: UnicodeString;
begin
  Result := ChildNodes['LOAD'].Text;
end;

procedure TXMLINVSELLType.SetLOAD(Value: UnicodeString);
begin
  ChildNodes['LOAD'].NodeValue := Value;
end;

function TXMLINVSELLType.GetWITHHOLDING: UnicodeString;
begin
  Result := ChildNodes['WITHHOLDING'].Text;
end;

procedure TXMLINVSELLType.SetWITHHOLDING(Value: UnicodeString);
begin
  ChildNodes['WITHHOLDING'].NodeValue := Value;
end;

function TXMLINVSELLType.GetTAXEXEMPT: UnicodeString;
begin
  Result := ChildNodes['TAXEXEMPT'].Text;
end;

procedure TXMLINVSELLType.SetTAXEXEMPT(Value: UnicodeString);
begin
  ChildNodes['TAXEXEMPT'].NodeValue := Value;
end;

function TXMLINVSELLType.GetTOTAL: UnicodeString;
begin
  Result := ChildNodes['TOTAL'].Text;
end;

procedure TXMLINVSELLType.SetTOTAL(Value: UnicodeString);
begin
  ChildNodes['TOTAL'].NodeValue := Value;
end;

function TXMLINVSELLType.GetGAIN: UnicodeString;
begin
  Result := ChildNodes['GAIN'].Text;
end;

procedure TXMLINVSELLType.SetGAIN(Value: UnicodeString);
begin
  ChildNodes['GAIN'].NodeValue := Value;
end;

function TXMLINVSELLType.GetCURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLINVSELLType.SetCURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLINVSELLType.GetORIGCURRENCY: UnicodeString;
begin
  Result := ChildNodes['ORIGCURRENCY'].Text;
end;

procedure TXMLINVSELLType.SetORIGCURRENCY(Value: UnicodeString);
begin
  ChildNodes['ORIGCURRENCY'].NodeValue := Value;
end;

function TXMLINVSELLType.GetSUBACCTSEC: UnicodeString;
begin
  Result := ChildNodes['SUBACCTSEC'].Text;
end;

procedure TXMLINVSELLType.SetSUBACCTSEC(Value: UnicodeString);
begin
  ChildNodes['SUBACCTSEC'].NodeValue := Value;
end;

function TXMLINVSELLType.GetSUBACCTFUND: IXMLSUBACCTFUNDType;
begin
  Result := ChildNodes['SUBACCTFUND'] as IXMLSUBACCTFUNDType;
end;

{ TXMLSELLMFType }

procedure TXMLSELLMFType.AfterConstruction;
begin
  RegisterChildNode('INVSELL', TXMLINVSELLType);
  inherited;
end;

function TXMLSELLMFType.GetINVSELL: IXMLINVSELLType;
begin
  Result := ChildNodes['INVSELL'] as IXMLINVSELLType;
end;

function TXMLSELLMFType.GetSELLTYPE: UnicodeString;
begin
  Result := ChildNodes['SELLTYPE'].Text;
end;

procedure TXMLSELLMFType.SetSELLTYPE(Value: UnicodeString);
begin
  ChildNodes['SELLTYPE'].NodeValue := Value;
end;

function TXMLSELLMFType.GetAVGCOSTBASIS: UnicodeString;
begin
  Result := ChildNodes['AVGCOSTBASIS'].Text;
end;

procedure TXMLSELLMFType.SetAVGCOSTBASIS(Value: UnicodeString);
begin
  ChildNodes['AVGCOSTBASIS'].NodeValue := Value;
end;

function TXMLSELLMFType.GetRELFITID: UnicodeString;
begin
  Result := ChildNodes['RELFITID'].Text;
end;

procedure TXMLSELLMFType.SetRELFITID(Value: UnicodeString);
begin
  ChildNodes['RELFITID'].NodeValue := Value;
end;

{ TXMLSELLMFTypeList }

function TXMLSELLMFTypeList.Add: IXMLSELLMFType;
begin
  Result := AddItem(-1) as IXMLSELLMFType;
end;

function TXMLSELLMFTypeList.Insert(const Index: Integer): IXMLSELLMFType;
begin
  Result := AddItem(Index) as IXMLSELLMFType;
end;

function TXMLSELLMFTypeList.GetItem(Index: Integer): IXMLSELLMFType;
begin
  Result := List[Index] as IXMLSELLMFType;
end;

{ TXMLSELLOPTType }

procedure TXMLSELLOPTType.AfterConstruction;
begin
  RegisterChildNode('INVSELL', TXMLINVSELLType);
  inherited;
end;

function TXMLSELLOPTType.GetINVSELL: IXMLINVSELLType;
begin
  Result := ChildNodes['INVSELL'] as IXMLINVSELLType;
end;

function TXMLSELLOPTType.GetOPTSELLTYPE: UnicodeString;
begin
  Result := ChildNodes['OPTSELLTYPE'].Text;
end;

procedure TXMLSELLOPTType.SetOPTSELLTYPE(Value: UnicodeString);
begin
  ChildNodes['OPTSELLTYPE'].NodeValue := Value;
end;

function TXMLSELLOPTType.GetSHPERCTRCT: UnicodeString;
begin
  Result := ChildNodes['SHPERCTRCT'].Text;
end;

procedure TXMLSELLOPTType.SetSHPERCTRCT(Value: UnicodeString);
begin
  ChildNodes['SHPERCTRCT'].NodeValue := Value;
end;

function TXMLSELLOPTType.GetRELFITID: UnicodeString;
begin
  Result := ChildNodes['RELFITID'].Text;
end;

procedure TXMLSELLOPTType.SetRELFITID(Value: UnicodeString);
begin
  ChildNodes['RELFITID'].NodeValue := Value;
end;

function TXMLSELLOPTType.GetRELTYPE: UnicodeString;
begin
  Result := ChildNodes['RELTYPE'].Text;
end;

procedure TXMLSELLOPTType.SetRELTYPE(Value: UnicodeString);
begin
  ChildNodes['RELTYPE'].NodeValue := Value;
end;

function TXMLSELLOPTType.GetSECURED: UnicodeString;
begin
  Result := ChildNodes['SECURED'].Text;
end;

procedure TXMLSELLOPTType.SetSECURED(Value: UnicodeString);
begin
  ChildNodes['SECURED'].NodeValue := Value;
end;

{ TXMLSELLOPTTypeList }

function TXMLSELLOPTTypeList.Add: IXMLSELLOPTType;
begin
  Result := AddItem(-1) as IXMLSELLOPTType;
end;

function TXMLSELLOPTTypeList.Insert(const Index: Integer): IXMLSELLOPTType;
begin
  Result := AddItem(Index) as IXMLSELLOPTType;
end;

function TXMLSELLOPTTypeList.GetItem(Index: Integer): IXMLSELLOPTType;
begin
  Result := List[Index] as IXMLSELLOPTType;
end;

{ TXMLSELLOTHERType }

procedure TXMLSELLOTHERType.AfterConstruction;
begin
  RegisterChildNode('INVSELL', TXMLINVSELLType);
  inherited;
end;

function TXMLSELLOTHERType.GetINVSELL: IXMLINVSELLType;
begin
  Result := ChildNodes['INVSELL'] as IXMLINVSELLType;
end;

{ TXMLSELLOTHERTypeList }

function TXMLSELLOTHERTypeList.Add: IXMLSELLOTHERType;
begin
  Result := AddItem(-1) as IXMLSELLOTHERType;
end;

function TXMLSELLOTHERTypeList.Insert(const Index: Integer): IXMLSELLOTHERType;
begin
  Result := AddItem(Index) as IXMLSELLOTHERType;
end;

function TXMLSELLOTHERTypeList.GetItem(Index: Integer): IXMLSELLOTHERType;
begin
  Result := List[Index] as IXMLSELLOTHERType;
end;

{ TXMLSELLSTOCKType }

procedure TXMLSELLSTOCKType.AfterConstruction;
begin
  RegisterChildNode('INVSELL', TXMLINVSELLType);
  inherited;
end;

function TXMLSELLSTOCKType.GetINVSELL: IXMLINVSELLType;
begin
  Result := ChildNodes['INVSELL'] as IXMLINVSELLType;
end;

function TXMLSELLSTOCKType.GetSELLTYPE: UnicodeString;
begin
  Result := ChildNodes['SELLTYPE'].Text;
end;

procedure TXMLSELLSTOCKType.SetSELLTYPE(Value: UnicodeString);
begin
  ChildNodes['SELLTYPE'].NodeValue := Value;
end;

{ TXMLSELLSTOCKTypeList }

function TXMLSELLSTOCKTypeList.Add: IXMLSELLSTOCKType;
begin
  Result := AddItem(-1) as IXMLSELLSTOCKType;
end;

function TXMLSELLSTOCKTypeList.Insert(const Index: Integer): IXMLSELLSTOCKType;
begin
  Result := AddItem(Index) as IXMLSELLSTOCKType;
end;

function TXMLSELLSTOCKTypeList.GetItem(Index: Integer): IXMLSELLSTOCKType;
begin
  Result := List[Index] as IXMLSELLSTOCKType;
end;

{ TXMLSPLITType }

procedure TXMLSPLITType.AfterConstruction;
begin
  RegisterChildNode('INVTRAN', TXMLINVTRANType);
  RegisterChildNode('SECID', TXMLSECIDType);
  RegisterChildNode('SUBACCTFUND', TXMLSUBACCTFUNDType);
  inherited;
end;

function TXMLSPLITType.GetINVTRAN: IXMLINVTRANType;
begin
  Result := ChildNodes['INVTRAN'] as IXMLINVTRANType;
end;

function TXMLSPLITType.GetSECID: IXMLSECIDType;
begin
  Result := ChildNodes['SECID'] as IXMLSECIDType;
end;

function TXMLSPLITType.GetSUBACCTSEC: UnicodeString;
begin
  Result := ChildNodes['SUBACCTSEC'].Text;
end;

procedure TXMLSPLITType.SetSUBACCTSEC(Value: UnicodeString);
begin
  ChildNodes['SUBACCTSEC'].NodeValue := Value;
end;

function TXMLSPLITType.GetOLDUNITS: UnicodeString;
begin
  Result := ChildNodes['OLDUNITS'].Text;
end;

procedure TXMLSPLITType.SetOLDUNITS(Value: UnicodeString);
begin
  ChildNodes['OLDUNITS'].NodeValue := Value;
end;

function TXMLSPLITType.GetNEWUNITS: UnicodeString;
begin
  Result := ChildNodes['NEWUNITS'].Text;
end;

procedure TXMLSPLITType.SetNEWUNITS(Value: UnicodeString);
begin
  ChildNodes['NEWUNITS'].NodeValue := Value;
end;

function TXMLSPLITType.GetNUMERATOR: UnicodeString;
begin
  Result := ChildNodes['NUMERATOR'].Text;
end;

procedure TXMLSPLITType.SetNUMERATOR(Value: UnicodeString);
begin
  ChildNodes['NUMERATOR'].NodeValue := Value;
end;

function TXMLSPLITType.GetDENOMINATOR: UnicodeString;
begin
  Result := ChildNodes['DENOMINATOR'].Text;
end;

procedure TXMLSPLITType.SetDENOMINATOR(Value: UnicodeString);
begin
  ChildNodes['DENOMINATOR'].NodeValue := Value;
end;

function TXMLSPLITType.GetCURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLSPLITType.SetCURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLSPLITType.GetORIGCURRENCY: UnicodeString;
begin
  Result := ChildNodes['ORIGCURRENCY'].Text;
end;

procedure TXMLSPLITType.SetORIGCURRENCY(Value: UnicodeString);
begin
  ChildNodes['ORIGCURRENCY'].NodeValue := Value;
end;

function TXMLSPLITType.GetFRACCASH: UnicodeString;
begin
  Result := ChildNodes['FRACCASH'].Text;
end;

procedure TXMLSPLITType.SetFRACCASH(Value: UnicodeString);
begin
  ChildNodes['FRACCASH'].NodeValue := Value;
end;

function TXMLSPLITType.GetSUBACCTFUND: IXMLSUBACCTFUNDType;
begin
  Result := ChildNodes['SUBACCTFUND'] as IXMLSUBACCTFUNDType;
end;

{ TXMLSPLITTypeList }

function TXMLSPLITTypeList.Add: IXMLSPLITType;
begin
  Result := AddItem(-1) as IXMLSPLITType;
end;

function TXMLSPLITTypeList.Insert(const Index: Integer): IXMLSPLITType;
begin
  Result := AddItem(Index) as IXMLSPLITType;
end;

function TXMLSPLITTypeList.GetItem(Index: Integer): IXMLSPLITType;
begin
  Result := List[Index] as IXMLSPLITType;
end;

{ TXMLTRANSFERType }

procedure TXMLTRANSFERType.AfterConstruction;
begin
  RegisterChildNode('INVTRAN', TXMLINVTRANType);
  RegisterChildNode('SECID', TXMLSECIDType);
  RegisterChildNode('INVACCTFROM', TXMLINVACCTFROMType);
  inherited;
end;

function TXMLTRANSFERType.GetINVTRAN: IXMLINVTRANType;
begin
  Result := ChildNodes['INVTRAN'] as IXMLINVTRANType;
end;

function TXMLTRANSFERType.GetSECID: IXMLSECIDType;
begin
  Result := ChildNodes['SECID'] as IXMLSECIDType;
end;

function TXMLTRANSFERType.GetSUBACCTSEC: UnicodeString;
begin
  Result := ChildNodes['SUBACCTSEC'].Text;
end;

procedure TXMLTRANSFERType.SetSUBACCTSEC(Value: UnicodeString);
begin
  ChildNodes['SUBACCTSEC'].NodeValue := Value;
end;

function TXMLTRANSFERType.GetUNITS: UnicodeString;
begin
  Result := ChildNodes['UNITS'].Text;
end;

procedure TXMLTRANSFERType.SetUNITS(Value: UnicodeString);
begin
  ChildNodes['UNITS'].NodeValue := Value;
end;

function TXMLTRANSFERType.GetTFERACTION: UnicodeString;
begin
  Result := ChildNodes['TFERACTION'].Text;
end;

procedure TXMLTRANSFERType.SetTFERACTION(Value: UnicodeString);
begin
  ChildNodes['TFERACTION'].NodeValue := Value;
end;

function TXMLTRANSFERType.GetPOSTYPE: UnicodeString;
begin
  Result := ChildNodes['POSTYPE'].Text;
end;

procedure TXMLTRANSFERType.SetPOSTYPE(Value: UnicodeString);
begin
  ChildNodes['POSTYPE'].NodeValue := Value;
end;

function TXMLTRANSFERType.GetINVACCTFROM: IXMLINVACCTFROMType;
begin
  Result := ChildNodes['INVACCTFROM'] as IXMLINVACCTFROMType;
end;

function TXMLTRANSFERType.GetAVGCOSTBASIS: UnicodeString;
begin
  Result := ChildNodes['AVGCOSTBASIS'].Text;
end;

procedure TXMLTRANSFERType.SetAVGCOSTBASIS(Value: UnicodeString);
begin
  ChildNodes['AVGCOSTBASIS'].NodeValue := Value;
end;

function TXMLTRANSFERType.GetUNITPRICE: UnicodeString;
begin
  Result := ChildNodes['UNITPRICE'].Text;
end;

procedure TXMLTRANSFERType.SetUNITPRICE(Value: UnicodeString);
begin
  ChildNodes['UNITPRICE'].NodeValue := Value;
end;

function TXMLTRANSFERType.GetDTPURCHASE: UnicodeString;
begin
  Result := ChildNodes['DTPURCHASE'].Text;
end;

procedure TXMLTRANSFERType.SetDTPURCHASE(Value: UnicodeString);
begin
  ChildNodes['DTPURCHASE'].NodeValue := Value;
end;

{ TXMLTRANSFERTypeList }

function TXMLTRANSFERTypeList.Add: IXMLTRANSFERType;
begin
  Result := AddItem(-1) as IXMLTRANSFERType;
end;

function TXMLTRANSFERTypeList.Insert(const Index: Integer): IXMLTRANSFERType;
begin
  Result := AddItem(Index) as IXMLTRANSFERType;
end;

function TXMLTRANSFERTypeList.GetItem(Index: Integer): IXMLTRANSFERType;
begin
  Result := List[Index] as IXMLTRANSFERType;
end;

{ TXMLINVBANKTRANType }

procedure TXMLINVBANKTRANType.AfterConstruction;
begin
  RegisterChildNode('STMTTRN', TXMLSTMTTRNType);
  RegisterChildNode('SUBACCTFUND', TXMLSUBACCTFUNDType);
  inherited;
end;

function TXMLINVBANKTRANType.GetSTMTTRN: IXMLSTMTTRNType;
begin
  Result := ChildNodes['STMTTRN'] as IXMLSTMTTRNType;
end;

function TXMLINVBANKTRANType.GetSUBACCTFUND: IXMLSUBACCTFUNDType;
begin
  Result := ChildNodes['SUBACCTFUND'] as IXMLSUBACCTFUNDType;
end;

{ TXMLINVBANKTRANTypeList }

function TXMLINVBANKTRANTypeList.Add: IXMLINVBANKTRANType;
begin
  Result := AddItem(-1) as IXMLINVBANKTRANType;
end;

function TXMLINVBANKTRANTypeList.Insert(const Index: Integer): IXMLINVBANKTRANType;
begin
  Result := AddItem(Index) as IXMLINVBANKTRANType;
end;

function TXMLINVBANKTRANTypeList.GetItem(Index: Integer): IXMLINVBANKTRANType;
begin
  Result := List[Index] as IXMLINVBANKTRANType;
end;

{ TXMLINVPOSLISTType }

procedure TXMLINVPOSLISTType.AfterConstruction;
begin
  RegisterChildNode('POSMF', TXMLPOSMFType);
  RegisterChildNode('POSSTOCK', TXMLPOSSTOCKType);
  RegisterChildNode('POSDEBT', TXMLPOSDEBTType);
  RegisterChildNode('POSOPT', TXMLPOSOPTType);
  RegisterChildNode('POSOTHER', TXMLPOSOTHERType);
  FPOSMF := CreateCollection(TXMLPOSMFTypeList, IXMLPOSMFType, 'POSMF') as IXMLPOSMFTypeList;
  FPOSSTOCK := CreateCollection(TXMLPOSSTOCKTypeList, IXMLPOSSTOCKType, 'POSSTOCK') as IXMLPOSSTOCKTypeList;
  FPOSDEBT := CreateCollection(TXMLPOSDEBTTypeList, IXMLPOSDEBTType, 'POSDEBT') as IXMLPOSDEBTTypeList;
  FPOSOPT := CreateCollection(TXMLPOSOPTTypeList, IXMLPOSOPTType, 'POSOPT') as IXMLPOSOPTTypeList;
  FPOSOTHER := CreateCollection(TXMLPOSOTHERTypeList, IXMLPOSOTHERType, 'POSOTHER') as IXMLPOSOTHERTypeList;
  inherited;
end;

function TXMLINVPOSLISTType.GetPOSMF: IXMLPOSMFTypeList;
begin
  Result := FPOSMF;
end;

function TXMLINVPOSLISTType.GetPOSSTOCK: IXMLPOSSTOCKTypeList;
begin
  Result := FPOSSTOCK;
end;

function TXMLINVPOSLISTType.GetPOSDEBT: IXMLPOSDEBTTypeList;
begin
  Result := FPOSDEBT;
end;

function TXMLINVPOSLISTType.GetPOSOPT: IXMLPOSOPTTypeList;
begin
  Result := FPOSOPT;
end;

function TXMLINVPOSLISTType.GetPOSOTHER: IXMLPOSOTHERTypeList;
begin
  Result := FPOSOTHER;
end;

{ TXMLPOSMFType }

procedure TXMLPOSMFType.AfterConstruction;
begin
  RegisterChildNode('INVPOS', TXMLINVPOSType);
  inherited;
end;

function TXMLPOSMFType.GetINVPOS: IXMLINVPOSType;
begin
  Result := ChildNodes['INVPOS'] as IXMLINVPOSType;
end;

function TXMLPOSMFType.GetUNITSSTREET: UnicodeString;
begin
  Result := ChildNodes['UNITSSTREET'].Text;
end;

procedure TXMLPOSMFType.SetUNITSSTREET(Value: UnicodeString);
begin
  ChildNodes['UNITSSTREET'].NodeValue := Value;
end;

function TXMLPOSMFType.GetUNITSUSER: UnicodeString;
begin
  Result := ChildNodes['UNITSUSER'].Text;
end;

procedure TXMLPOSMFType.SetUNITSUSER(Value: UnicodeString);
begin
  ChildNodes['UNITSUSER'].NodeValue := Value;
end;

function TXMLPOSMFType.GetREINVDIV: UnicodeString;
begin
  Result := ChildNodes['REINVDIV'].Text;
end;

procedure TXMLPOSMFType.SetREINVDIV(Value: UnicodeString);
begin
  ChildNodes['REINVDIV'].NodeValue := Value;
end;

function TXMLPOSMFType.GetREINVCG: UnicodeString;
begin
  Result := ChildNodes['REINVCG'].Text;
end;

procedure TXMLPOSMFType.SetREINVCG(Value: UnicodeString);
begin
  ChildNodes['REINVCG'].NodeValue := Value;
end;

{ TXMLPOSMFTypeList }

function TXMLPOSMFTypeList.Add: IXMLPOSMFType;
begin
  Result := AddItem(-1) as IXMLPOSMFType;
end;

function TXMLPOSMFTypeList.Insert(const Index: Integer): IXMLPOSMFType;
begin
  Result := AddItem(Index) as IXMLPOSMFType;
end;

function TXMLPOSMFTypeList.GetItem(Index: Integer): IXMLPOSMFType;
begin
  Result := List[Index] as IXMLPOSMFType;
end;

{ TXMLINVPOSType }

procedure TXMLINVPOSType.AfterConstruction;
begin
  RegisterChildNode('SECID', TXMLSECIDType);
  inherited;
end;

function TXMLINVPOSType.GetSECID: IXMLSECIDType;
begin
  Result := ChildNodes['SECID'] as IXMLSECIDType;
end;

function TXMLINVPOSType.GetHELDINACCT: UnicodeString;
begin
  Result := ChildNodes['HELDINACCT'].Text;
end;

procedure TXMLINVPOSType.SetHELDINACCT(Value: UnicodeString);
begin
  ChildNodes['HELDINACCT'].NodeValue := Value;
end;

function TXMLINVPOSType.GetPOSTYPE: UnicodeString;
begin
  Result := ChildNodes['POSTYPE'].Text;
end;

procedure TXMLINVPOSType.SetPOSTYPE(Value: UnicodeString);
begin
  ChildNodes['POSTYPE'].NodeValue := Value;
end;

function TXMLINVPOSType.GetUNITS: UnicodeString;
begin
  Result := ChildNodes['UNITS'].Text;
end;

procedure TXMLINVPOSType.SetUNITS(Value: UnicodeString);
begin
  ChildNodes['UNITS'].NodeValue := Value;
end;

function TXMLINVPOSType.GetUNITPRICE: UnicodeString;
begin
  Result := ChildNodes['UNITPRICE'].Text;
end;

procedure TXMLINVPOSType.SetUNITPRICE(Value: UnicodeString);
begin
  ChildNodes['UNITPRICE'].NodeValue := Value;
end;

function TXMLINVPOSType.GetMKTVAL: UnicodeString;
begin
  Result := ChildNodes['MKTVAL'].Text;
end;

procedure TXMLINVPOSType.SetMKTVAL(Value: UnicodeString);
begin
  ChildNodes['MKTVAL'].NodeValue := Value;
end;

function TXMLINVPOSType.GetDTPRICEASOF: UnicodeString;
begin
  Result := ChildNodes['DTPRICEASOF'].Text;
end;

procedure TXMLINVPOSType.SetDTPRICEASOF(Value: UnicodeString);
begin
  ChildNodes['DTPRICEASOF'].NodeValue := Value;
end;

function TXMLINVPOSType.GetCURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLINVPOSType.SetCURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLINVPOSType.GetMEMO: UnicodeString;
begin
  Result := ChildNodes['MEMO'].Text;
end;

procedure TXMLINVPOSType.SetMEMO(Value: UnicodeString);
begin
  ChildNodes['MEMO'].NodeValue := Value;
end;

{ TXMLPOSSTOCKType }

procedure TXMLPOSSTOCKType.AfterConstruction;
begin
  RegisterChildNode('INVPOS', TXMLINVPOSType);
  inherited;
end;

function TXMLPOSSTOCKType.GetINVPOS: IXMLINVPOSType;
begin
  Result := ChildNodes['INVPOS'] as IXMLINVPOSType;
end;

function TXMLPOSSTOCKType.GetUNITSSTREET: UnicodeString;
begin
  Result := ChildNodes['UNITSSTREET'].Text;
end;

procedure TXMLPOSSTOCKType.SetUNITSSTREET(Value: UnicodeString);
begin
  ChildNodes['UNITSSTREET'].NodeValue := Value;
end;

function TXMLPOSSTOCKType.GetUNITSUSER: UnicodeString;
begin
  Result := ChildNodes['UNITSUSER'].Text;
end;

procedure TXMLPOSSTOCKType.SetUNITSUSER(Value: UnicodeString);
begin
  ChildNodes['UNITSUSER'].NodeValue := Value;
end;

function TXMLPOSSTOCKType.GetREINVDIV: UnicodeString;
begin
  Result := ChildNodes['REINVDIV'].Text;
end;

procedure TXMLPOSSTOCKType.SetREINVDIV(Value: UnicodeString);
begin
  ChildNodes['REINVDIV'].NodeValue := Value;
end;

{ TXMLPOSSTOCKTypeList }

function TXMLPOSSTOCKTypeList.Add: IXMLPOSSTOCKType;
begin
  Result := AddItem(-1) as IXMLPOSSTOCKType;
end;

function TXMLPOSSTOCKTypeList.Insert(const Index: Integer): IXMLPOSSTOCKType;
begin
  Result := AddItem(Index) as IXMLPOSSTOCKType;
end;

function TXMLPOSSTOCKTypeList.GetItem(Index: Integer): IXMLPOSSTOCKType;
begin
  Result := List[Index] as IXMLPOSSTOCKType;
end;

{ TXMLPOSDEBTType }

procedure TXMLPOSDEBTType.AfterConstruction;
begin
  RegisterChildNode('INVPOS', TXMLINVPOSType);
  inherited;
end;

function TXMLPOSDEBTType.GetINVPOS: IXMLINVPOSType;
begin
  Result := ChildNodes['INVPOS'] as IXMLINVPOSType;
end;

{ TXMLPOSDEBTTypeList }

function TXMLPOSDEBTTypeList.Add: IXMLPOSDEBTType;
begin
  Result := AddItem(-1) as IXMLPOSDEBTType;
end;

function TXMLPOSDEBTTypeList.Insert(const Index: Integer): IXMLPOSDEBTType;
begin
  Result := AddItem(Index) as IXMLPOSDEBTType;
end;

function TXMLPOSDEBTTypeList.GetItem(Index: Integer): IXMLPOSDEBTType;
begin
  Result := List[Index] as IXMLPOSDEBTType;
end;

{ TXMLPOSOPTType }

procedure TXMLPOSOPTType.AfterConstruction;
begin
  RegisterChildNode('INVPOS', TXMLINVPOSType);
  inherited;
end;

function TXMLPOSOPTType.GetINVPOS: IXMLINVPOSType;
begin
  Result := ChildNodes['INVPOS'] as IXMLINVPOSType;
end;

function TXMLPOSOPTType.GetSECURED: UnicodeString;
begin
  Result := ChildNodes['SECURED'].Text;
end;

procedure TXMLPOSOPTType.SetSECURED(Value: UnicodeString);
begin
  ChildNodes['SECURED'].NodeValue := Value;
end;

{ TXMLPOSOPTTypeList }

function TXMLPOSOPTTypeList.Add: IXMLPOSOPTType;
begin
  Result := AddItem(-1) as IXMLPOSOPTType;
end;

function TXMLPOSOPTTypeList.Insert(const Index: Integer): IXMLPOSOPTType;
begin
  Result := AddItem(Index) as IXMLPOSOPTType;
end;

function TXMLPOSOPTTypeList.GetItem(Index: Integer): IXMLPOSOPTType;
begin
  Result := List[Index] as IXMLPOSOPTType;
end;

{ TXMLPOSOTHERType }

procedure TXMLPOSOTHERType.AfterConstruction;
begin
  RegisterChildNode('INVPOS', TXMLINVPOSType);
  inherited;
end;

function TXMLPOSOTHERType.GetINVPOS: IXMLINVPOSType;
begin
  Result := ChildNodes['INVPOS'] as IXMLINVPOSType;
end;

{ TXMLPOSOTHERTypeList }

function TXMLPOSOTHERTypeList.Add: IXMLPOSOTHERType;
begin
  Result := AddItem(-1) as IXMLPOSOTHERType;
end;

function TXMLPOSOTHERTypeList.Insert(const Index: Integer): IXMLPOSOTHERType;
begin
  Result := AddItem(Index) as IXMLPOSOTHERType;
end;

function TXMLPOSOTHERTypeList.GetItem(Index: Integer): IXMLPOSOTHERType;
begin
  Result := List[Index] as IXMLPOSOTHERType;
end;

{ TXMLINVBALType }

procedure TXMLINVBALType.AfterConstruction;
begin
  RegisterChildNode('BALLIST', TXMLBALLISTType);
  inherited;
end;

function TXMLINVBALType.GetAVAILCASH: UnicodeString;
begin
  Result := ChildNodes['AVAILCASH'].Text;
end;

procedure TXMLINVBALType.SetAVAILCASH(Value: UnicodeString);
begin
  ChildNodes['AVAILCASH'].NodeValue := Value;
end;

function TXMLINVBALType.GetMARGINBALANCE: UnicodeString;
begin
  Result := ChildNodes['MARGINBALANCE'].Text;
end;

procedure TXMLINVBALType.SetMARGINBALANCE(Value: UnicodeString);
begin
  ChildNodes['MARGINBALANCE'].NodeValue := Value;
end;

function TXMLINVBALType.GetSHORTBALANCE: UnicodeString;
begin
  Result := ChildNodes['SHORTBALANCE'].Text;
end;

procedure TXMLINVBALType.SetSHORTBALANCE(Value: UnicodeString);
begin
  ChildNodes['SHORTBALANCE'].NodeValue := Value;
end;

function TXMLINVBALType.GetBUYPOWER: UnicodeString;
begin
  Result := ChildNodes['BUYPOWER'].Text;
end;

procedure TXMLINVBALType.SetBUYPOWER(Value: UnicodeString);
begin
  ChildNodes['BUYPOWER'].NodeValue := Value;
end;

function TXMLINVBALType.GetBALLIST: IXMLBALLISTType;
begin
  Result := ChildNodes['BALLIST'] as IXMLBALLISTType;
end;

{ TXMLBALLISTType }

procedure TXMLBALLISTType.AfterConstruction;
begin
  RegisterChildNode('BAL', TXMLBALType);
  ItemTag := 'BAL';
  ItemInterface := IXMLBALType;
  inherited;
end;

function TXMLBALLISTType.GetBAL(Index: Integer): IXMLBALType;
begin
  Result := List[Index] as IXMLBALType;
end;

function TXMLBALLISTType.Add: IXMLBALType;
begin
  Result := AddItem(-1) as IXMLBALType;
end;

function TXMLBALLISTType.Insert(const Index: Integer): IXMLBALType;
begin
  Result := AddItem(Index) as IXMLBALType;
end;

{ TXMLBALType }

function TXMLBALType.GetNAME: UnicodeString;
begin
  Result := ChildNodes['NAME'].Text;
end;

procedure TXMLBALType.SetNAME(Value: UnicodeString);
begin
  ChildNodes['NAME'].NodeValue := Value;
end;

function TXMLBALType.GetDESC: UnicodeString;
begin
  Result := ChildNodes['DESC'].Text;
end;

procedure TXMLBALType.SetDESC(Value: UnicodeString);
begin
  ChildNodes['DESC'].NodeValue := Value;
end;

function TXMLBALType.GetBALTYPE: UnicodeString;
begin
  Result := ChildNodes['BALTYPE'].Text;
end;

procedure TXMLBALType.SetBALTYPE(Value: UnicodeString);
begin
  ChildNodes['BALTYPE'].NodeValue := Value;
end;

function TXMLBALType.GetVALUE: UnicodeString;
begin
  Result := ChildNodes['VALUE'].Text;
end;

procedure TXMLBALType.SetVALUE(Value: UnicodeString);
begin
  ChildNodes['VALUE'].NodeValue := Value;
end;

function TXMLBALType.GetDTASOF: UnicodeString;
begin
  Result := ChildNodes['DTASOF'].Text;
end;

procedure TXMLBALType.SetDTASOF(Value: UnicodeString);
begin
  ChildNodes['DTASOF'].NodeValue := Value;
end;

function TXMLBALType.GetCURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLBALType.SetCURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

{ TXMLINVOOLISTType }

procedure TXMLINVOOLISTType.AfterConstruction;
begin
  RegisterChildNode('OOBUYDEBT', TXMLOOBUYDEBTType);
  RegisterChildNode('OOBUYMF', TXMLOOBUYMFType);
  RegisterChildNode('OOBUYOPT', TXMLOOBUYOPTType);
  RegisterChildNode('OOBUYOTHER', TXMLOOBUYOTHERType);
  RegisterChildNode('OOBUYSTOCK', TXMLOOBUYSTOCKType);
  RegisterChildNode('OOSELLDEBT', TXMLOOSELLDEBTType);
  RegisterChildNode('OOSELLMF', TXMLOOSELLMFType);
  RegisterChildNode('OOSELLOPT', TXMLOOSELLOPTType);
  RegisterChildNode('OOSELLOTHER', TXMLOOSELLOTHERType);
  RegisterChildNode('OOSELLSTOCK', TXMLOOSELLSTOCKType);
  RegisterChildNode('OOSWITCHMF', TXMLOOSWITCHMFType);
  FOOBUYDEBT := CreateCollection(TXMLOOBUYDEBTTypeList, IXMLOOBUYDEBTType, 'OOBUYDEBT') as IXMLOOBUYDEBTTypeList;
  FOOBUYMF := CreateCollection(TXMLOOBUYMFTypeList, IXMLOOBUYMFType, 'OOBUYMF') as IXMLOOBUYMFTypeList;
  FOOBUYOPT := CreateCollection(TXMLOOBUYOPTTypeList, IXMLOOBUYOPTType, 'OOBUYOPT') as IXMLOOBUYOPTTypeList;
  FOOBUYOTHER := CreateCollection(TXMLOOBUYOTHERTypeList, IXMLOOBUYOTHERType, 'OOBUYOTHER') as IXMLOOBUYOTHERTypeList;
  FOOBUYSTOCK := CreateCollection(TXMLOOBUYSTOCKTypeList, IXMLOOBUYSTOCKType, 'OOBUYSTOCK') as IXMLOOBUYSTOCKTypeList;
  FOOSELLDEBT := CreateCollection(TXMLOOSELLDEBTTypeList, IXMLOOSELLDEBTType, 'OOSELLDEBT') as IXMLOOSELLDEBTTypeList;
  FOOSELLMF := CreateCollection(TXMLOOSELLMFTypeList, IXMLOOSELLMFType, 'OOSELLMF') as IXMLOOSELLMFTypeList;
  FOOSELLOPT := CreateCollection(TXMLOOSELLOPTTypeList, IXMLOOSELLOPTType, 'OOSELLOPT') as IXMLOOSELLOPTTypeList;
  FOOSELLOTHER := CreateCollection(TXMLOOSELLOTHERTypeList, IXMLOOSELLOTHERType, 'OOSELLOTHER') as IXMLOOSELLOTHERTypeList;
  FOOSELLSTOCK := CreateCollection(TXMLOOSELLSTOCKTypeList, IXMLOOSELLSTOCKType, 'OOSELLSTOCK') as IXMLOOSELLSTOCKTypeList;
  FOOSWITCHMF := CreateCollection(TXMLOOSWITCHMFTypeList, IXMLOOSWITCHMFType, 'OOSWITCHMF') as IXMLOOSWITCHMFTypeList;
  inherited;
end;

function TXMLINVOOLISTType.GetOOBUYDEBT: IXMLOOBUYDEBTTypeList;
begin
  Result := FOOBUYDEBT;
end;

function TXMLINVOOLISTType.GetOOBUYMF: IXMLOOBUYMFTypeList;
begin
  Result := FOOBUYMF;
end;

function TXMLINVOOLISTType.GetOOBUYOPT: IXMLOOBUYOPTTypeList;
begin
  Result := FOOBUYOPT;
end;

function TXMLINVOOLISTType.GetOOBUYOTHER: IXMLOOBUYOTHERTypeList;
begin
  Result := FOOBUYOTHER;
end;

function TXMLINVOOLISTType.GetOOBUYSTOCK: IXMLOOBUYSTOCKTypeList;
begin
  Result := FOOBUYSTOCK;
end;

function TXMLINVOOLISTType.GetOOSELLDEBT: IXMLOOSELLDEBTTypeList;
begin
  Result := FOOSELLDEBT;
end;

function TXMLINVOOLISTType.GetOOSELLMF: IXMLOOSELLMFTypeList;
begin
  Result := FOOSELLMF;
end;

function TXMLINVOOLISTType.GetOOSELLOPT: IXMLOOSELLOPTTypeList;
begin
  Result := FOOSELLOPT;
end;

function TXMLINVOOLISTType.GetOOSELLOTHER: IXMLOOSELLOTHERTypeList;
begin
  Result := FOOSELLOTHER;
end;

function TXMLINVOOLISTType.GetOOSELLSTOCK: IXMLOOSELLSTOCKTypeList;
begin
  Result := FOOSELLSTOCK;
end;

function TXMLINVOOLISTType.GetOOSWITCHMF: IXMLOOSWITCHMFTypeList;
begin
  Result := FOOSWITCHMF;
end;

{ TXMLOOBUYDEBTType }

procedure TXMLOOBUYDEBTType.AfterConstruction;
begin
  RegisterChildNode('OO', TXMLOOType);
  inherited;
end;

function TXMLOOBUYDEBTType.GetOO: IXMLOOType;
begin
  Result := ChildNodes['OO'] as IXMLOOType;
end;

function TXMLOOBUYDEBTType.GetAUCTION: UnicodeString;
begin
  Result := ChildNodes['AUCTION'].Text;
end;

procedure TXMLOOBUYDEBTType.SetAUCTION(Value: UnicodeString);
begin
  ChildNodes['AUCTION'].NodeValue := Value;
end;

function TXMLOOBUYDEBTType.GetDTAUCTION: UnicodeString;
begin
  Result := ChildNodes['DTAUCTION'].Text;
end;

procedure TXMLOOBUYDEBTType.SetDTAUCTION(Value: UnicodeString);
begin
  ChildNodes['DTAUCTION'].NodeValue := Value;
end;

{ TXMLOOBUYDEBTTypeList }

function TXMLOOBUYDEBTTypeList.Add: IXMLOOBUYDEBTType;
begin
  Result := AddItem(-1) as IXMLOOBUYDEBTType;
end;

function TXMLOOBUYDEBTTypeList.Insert(const Index: Integer): IXMLOOBUYDEBTType;
begin
  Result := AddItem(Index) as IXMLOOBUYDEBTType;
end;

function TXMLOOBUYDEBTTypeList.GetItem(Index: Integer): IXMLOOBUYDEBTType;
begin
  Result := List[Index] as IXMLOOBUYDEBTType;
end;

{ TXMLOOType }

procedure TXMLOOType.AfterConstruction;
begin
  RegisterChildNode('SECID', TXMLSECIDType);
  inherited;
end;

function TXMLOOType.GetFITID: UnicodeString;
begin
  Result := ChildNodes['FITID'].Text;
end;

procedure TXMLOOType.SetFITID(Value: UnicodeString);
begin
  ChildNodes['FITID'].NodeValue := Value;
end;

function TXMLOOType.GetSRVRTID: UnicodeString;
begin
  Result := ChildNodes['SRVRTID'].Text;
end;

procedure TXMLOOType.SetSRVRTID(Value: UnicodeString);
begin
  ChildNodes['SRVRTID'].NodeValue := Value;
end;

function TXMLOOType.GetSECID: IXMLSECIDType;
begin
  Result := ChildNodes['SECID'] as IXMLSECIDType;
end;

function TXMLOOType.GetDTPLACED: UnicodeString;
begin
  Result := ChildNodes['DTPLACED'].Text;
end;

procedure TXMLOOType.SetDTPLACED(Value: UnicodeString);
begin
  ChildNodes['DTPLACED'].NodeValue := Value;
end;

function TXMLOOType.GetUNITS: UnicodeString;
begin
  Result := ChildNodes['UNITS'].Text;
end;

procedure TXMLOOType.SetUNITS(Value: UnicodeString);
begin
  ChildNodes['UNITS'].NodeValue := Value;
end;

function TXMLOOType.GetSUBACCT: UnicodeString;
begin
  Result := ChildNodes['SUBACCT'].Text;
end;

procedure TXMLOOType.SetSUBACCT(Value: UnicodeString);
begin
  ChildNodes['SUBACCT'].NodeValue := Value;
end;

function TXMLOOType.GetDURATION: UnicodeString;
begin
  Result := ChildNodes['DURATION'].Text;
end;

procedure TXMLOOType.SetDURATION(Value: UnicodeString);
begin
  ChildNodes['DURATION'].NodeValue := Value;
end;

function TXMLOOType.GetRESTRICTION: UnicodeString;
begin
  Result := ChildNodes['RESTRICTION'].Text;
end;

procedure TXMLOOType.SetRESTRICTION(Value: UnicodeString);
begin
  ChildNodes['RESTRICTION'].NodeValue := Value;
end;

function TXMLOOType.GetMINUNITS: UnicodeString;
begin
  Result := ChildNodes['MINUNITS'].Text;
end;

procedure TXMLOOType.SetMINUNITS(Value: UnicodeString);
begin
  ChildNodes['MINUNITS'].NodeValue := Value;
end;

function TXMLOOType.GetLIMITPRICE: UnicodeString;
begin
  Result := ChildNodes['LIMITPRICE'].Text;
end;

procedure TXMLOOType.SetLIMITPRICE(Value: UnicodeString);
begin
  ChildNodes['LIMITPRICE'].NodeValue := Value;
end;

function TXMLOOType.GetSTOPPRICE: UnicodeString;
begin
  Result := ChildNodes['STOPPRICE'].Text;
end;

procedure TXMLOOType.SetSTOPPRICE(Value: UnicodeString);
begin
  ChildNodes['STOPPRICE'].NodeValue := Value;
end;

function TXMLOOType.GetMEMO: UnicodeString;
begin
  Result := ChildNodes['MEMO'].Text;
end;

procedure TXMLOOType.SetMEMO(Value: UnicodeString);
begin
  ChildNodes['MEMO'].NodeValue := Value;
end;

function TXMLOOType.GetCURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLOOType.SetCURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

{ TXMLOOBUYMFType }

procedure TXMLOOBUYMFType.AfterConstruction;
begin
  RegisterChildNode('OO', TXMLOOType);
  inherited;
end;

function TXMLOOBUYMFType.GetOO: IXMLOOType;
begin
  Result := ChildNodes['OO'] as IXMLOOType;
end;

function TXMLOOBUYMFType.GetBUYTYPE: UnicodeString;
begin
  Result := ChildNodes['BUYTYPE'].Text;
end;

procedure TXMLOOBUYMFType.SetBUYTYPE(Value: UnicodeString);
begin
  ChildNodes['BUYTYPE'].NodeValue := Value;
end;

function TXMLOOBUYMFType.GetUNITTYPE: UnicodeString;
begin
  Result := ChildNodes['UNITTYPE'].Text;
end;

procedure TXMLOOBUYMFType.SetUNITTYPE(Value: UnicodeString);
begin
  ChildNodes['UNITTYPE'].NodeValue := Value;
end;

{ TXMLOOBUYMFTypeList }

function TXMLOOBUYMFTypeList.Add: IXMLOOBUYMFType;
begin
  Result := AddItem(-1) as IXMLOOBUYMFType;
end;

function TXMLOOBUYMFTypeList.Insert(const Index: Integer): IXMLOOBUYMFType;
begin
  Result := AddItem(Index) as IXMLOOBUYMFType;
end;

function TXMLOOBUYMFTypeList.GetItem(Index: Integer): IXMLOOBUYMFType;
begin
  Result := List[Index] as IXMLOOBUYMFType;
end;

{ TXMLOOBUYOPTType }

procedure TXMLOOBUYOPTType.AfterConstruction;
begin
  RegisterChildNode('OO', TXMLOOType);
  inherited;
end;

function TXMLOOBUYOPTType.GetOO: IXMLOOType;
begin
  Result := ChildNodes['OO'] as IXMLOOType;
end;

function TXMLOOBUYOPTType.GetOPTBUYTYPE: UnicodeString;
begin
  Result := ChildNodes['OPTBUYTYPE'].Text;
end;

procedure TXMLOOBUYOPTType.SetOPTBUYTYPE(Value: UnicodeString);
begin
  ChildNodes['OPTBUYTYPE'].NodeValue := Value;
end;

{ TXMLOOBUYOPTTypeList }

function TXMLOOBUYOPTTypeList.Add: IXMLOOBUYOPTType;
begin
  Result := AddItem(-1) as IXMLOOBUYOPTType;
end;

function TXMLOOBUYOPTTypeList.Insert(const Index: Integer): IXMLOOBUYOPTType;
begin
  Result := AddItem(Index) as IXMLOOBUYOPTType;
end;

function TXMLOOBUYOPTTypeList.GetItem(Index: Integer): IXMLOOBUYOPTType;
begin
  Result := List[Index] as IXMLOOBUYOPTType;
end;

{ TXMLOOBUYOTHERType }

procedure TXMLOOBUYOTHERType.AfterConstruction;
begin
  RegisterChildNode('OO', TXMLOOType);
  inherited;
end;

function TXMLOOBUYOTHERType.GetOO: IXMLOOType;
begin
  Result := ChildNodes['OO'] as IXMLOOType;
end;

function TXMLOOBUYOTHERType.GetUNITTYPE: UnicodeString;
begin
  Result := ChildNodes['UNITTYPE'].Text;
end;

procedure TXMLOOBUYOTHERType.SetUNITTYPE(Value: UnicodeString);
begin
  ChildNodes['UNITTYPE'].NodeValue := Value;
end;

{ TXMLOOBUYOTHERTypeList }

function TXMLOOBUYOTHERTypeList.Add: IXMLOOBUYOTHERType;
begin
  Result := AddItem(-1) as IXMLOOBUYOTHERType;
end;

function TXMLOOBUYOTHERTypeList.Insert(const Index: Integer): IXMLOOBUYOTHERType;
begin
  Result := AddItem(Index) as IXMLOOBUYOTHERType;
end;

function TXMLOOBUYOTHERTypeList.GetItem(Index: Integer): IXMLOOBUYOTHERType;
begin
  Result := List[Index] as IXMLOOBUYOTHERType;
end;

{ TXMLOOBUYSTOCKType }

procedure TXMLOOBUYSTOCKType.AfterConstruction;
begin
  RegisterChildNode('OO', TXMLOOType);
  inherited;
end;

function TXMLOOBUYSTOCKType.GetOO: IXMLOOType;
begin
  Result := ChildNodes['OO'] as IXMLOOType;
end;

function TXMLOOBUYSTOCKType.GetBUYTYPE: UnicodeString;
begin
  Result := ChildNodes['BUYTYPE'].Text;
end;

procedure TXMLOOBUYSTOCKType.SetBUYTYPE(Value: UnicodeString);
begin
  ChildNodes['BUYTYPE'].NodeValue := Value;
end;

{ TXMLOOBUYSTOCKTypeList }

function TXMLOOBUYSTOCKTypeList.Add: IXMLOOBUYSTOCKType;
begin
  Result := AddItem(-1) as IXMLOOBUYSTOCKType;
end;

function TXMLOOBUYSTOCKTypeList.Insert(const Index: Integer): IXMLOOBUYSTOCKType;
begin
  Result := AddItem(Index) as IXMLOOBUYSTOCKType;
end;

function TXMLOOBUYSTOCKTypeList.GetItem(Index: Integer): IXMLOOBUYSTOCKType;
begin
  Result := List[Index] as IXMLOOBUYSTOCKType;
end;

{ TXMLOOSELLDEBTType }

procedure TXMLOOSELLDEBTType.AfterConstruction;
begin
  RegisterChildNode('OO', TXMLOOType);
  inherited;
end;

function TXMLOOSELLDEBTType.GetOO: IXMLOOType;
begin
  Result := ChildNodes['OO'] as IXMLOOType;
end;

{ TXMLOOSELLDEBTTypeList }

function TXMLOOSELLDEBTTypeList.Add: IXMLOOSELLDEBTType;
begin
  Result := AddItem(-1) as IXMLOOSELLDEBTType;
end;

function TXMLOOSELLDEBTTypeList.Insert(const Index: Integer): IXMLOOSELLDEBTType;
begin
  Result := AddItem(Index) as IXMLOOSELLDEBTType;
end;

function TXMLOOSELLDEBTTypeList.GetItem(Index: Integer): IXMLOOSELLDEBTType;
begin
  Result := List[Index] as IXMLOOSELLDEBTType;
end;

{ TXMLOOSELLMFType }

procedure TXMLOOSELLMFType.AfterConstruction;
begin
  RegisterChildNode('OO', TXMLOOType);
  inherited;
end;

function TXMLOOSELLMFType.GetOO: IXMLOOType;
begin
  Result := ChildNodes['OO'] as IXMLOOType;
end;

function TXMLOOSELLMFType.GetSELLTYPE: UnicodeString;
begin
  Result := ChildNodes['SELLTYPE'].Text;
end;

procedure TXMLOOSELLMFType.SetSELLTYPE(Value: UnicodeString);
begin
  ChildNodes['SELLTYPE'].NodeValue := Value;
end;

function TXMLOOSELLMFType.GetUNITTYPE: UnicodeString;
begin
  Result := ChildNodes['UNITTYPE'].Text;
end;

procedure TXMLOOSELLMFType.SetUNITTYPE(Value: UnicodeString);
begin
  ChildNodes['UNITTYPE'].NodeValue := Value;
end;

function TXMLOOSELLMFType.GetSELLALL: UnicodeString;
begin
  Result := ChildNodes['SELLALL'].Text;
end;

procedure TXMLOOSELLMFType.SetSELLALL(Value: UnicodeString);
begin
  ChildNodes['SELLALL'].NodeValue := Value;
end;

{ TXMLOOSELLMFTypeList }

function TXMLOOSELLMFTypeList.Add: IXMLOOSELLMFType;
begin
  Result := AddItem(-1) as IXMLOOSELLMFType;
end;

function TXMLOOSELLMFTypeList.Insert(const Index: Integer): IXMLOOSELLMFType;
begin
  Result := AddItem(Index) as IXMLOOSELLMFType;
end;

function TXMLOOSELLMFTypeList.GetItem(Index: Integer): IXMLOOSELLMFType;
begin
  Result := List[Index] as IXMLOOSELLMFType;
end;

{ TXMLOOSELLOPTType }

procedure TXMLOOSELLOPTType.AfterConstruction;
begin
  RegisterChildNode('OO', TXMLOOType);
  inherited;
end;

function TXMLOOSELLOPTType.GetOO: IXMLOOType;
begin
  Result := ChildNodes['OO'] as IXMLOOType;
end;

function TXMLOOSELLOPTType.GetOPTSELLTYPE: UnicodeString;
begin
  Result := ChildNodes['OPTSELLTYPE'].Text;
end;

procedure TXMLOOSELLOPTType.SetOPTSELLTYPE(Value: UnicodeString);
begin
  ChildNodes['OPTSELLTYPE'].NodeValue := Value;
end;

{ TXMLOOSELLOPTTypeList }

function TXMLOOSELLOPTTypeList.Add: IXMLOOSELLOPTType;
begin
  Result := AddItem(-1) as IXMLOOSELLOPTType;
end;

function TXMLOOSELLOPTTypeList.Insert(const Index: Integer): IXMLOOSELLOPTType;
begin
  Result := AddItem(Index) as IXMLOOSELLOPTType;
end;

function TXMLOOSELLOPTTypeList.GetItem(Index: Integer): IXMLOOSELLOPTType;
begin
  Result := List[Index] as IXMLOOSELLOPTType;
end;

{ TXMLOOSELLOTHERType }

procedure TXMLOOSELLOTHERType.AfterConstruction;
begin
  RegisterChildNode('OO', TXMLOOType);
  inherited;
end;

function TXMLOOSELLOTHERType.GetOO: IXMLOOType;
begin
  Result := ChildNodes['OO'] as IXMLOOType;
end;

function TXMLOOSELLOTHERType.GetUNITTYPE: UnicodeString;
begin
  Result := ChildNodes['UNITTYPE'].Text;
end;

procedure TXMLOOSELLOTHERType.SetUNITTYPE(Value: UnicodeString);
begin
  ChildNodes['UNITTYPE'].NodeValue := Value;
end;

{ TXMLOOSELLOTHERTypeList }

function TXMLOOSELLOTHERTypeList.Add: IXMLOOSELLOTHERType;
begin
  Result := AddItem(-1) as IXMLOOSELLOTHERType;
end;

function TXMLOOSELLOTHERTypeList.Insert(const Index: Integer): IXMLOOSELLOTHERType;
begin
  Result := AddItem(Index) as IXMLOOSELLOTHERType;
end;

function TXMLOOSELLOTHERTypeList.GetItem(Index: Integer): IXMLOOSELLOTHERType;
begin
  Result := List[Index] as IXMLOOSELLOTHERType;
end;

{ TXMLOOSELLSTOCKType }

procedure TXMLOOSELLSTOCKType.AfterConstruction;
begin
  RegisterChildNode('OO', TXMLOOType);
  inherited;
end;

function TXMLOOSELLSTOCKType.GetOO: IXMLOOType;
begin
  Result := ChildNodes['OO'] as IXMLOOType;
end;

function TXMLOOSELLSTOCKType.GetSELLTYPE: UnicodeString;
begin
  Result := ChildNodes['SELLTYPE'].Text;
end;

procedure TXMLOOSELLSTOCKType.SetSELLTYPE(Value: UnicodeString);
begin
  ChildNodes['SELLTYPE'].NodeValue := Value;
end;

{ TXMLOOSELLSTOCKTypeList }

function TXMLOOSELLSTOCKTypeList.Add: IXMLOOSELLSTOCKType;
begin
  Result := AddItem(-1) as IXMLOOSELLSTOCKType;
end;

function TXMLOOSELLSTOCKTypeList.Insert(const Index: Integer): IXMLOOSELLSTOCKType;
begin
  Result := AddItem(Index) as IXMLOOSELLSTOCKType;
end;

function TXMLOOSELLSTOCKTypeList.GetItem(Index: Integer): IXMLOOSELLSTOCKType;
begin
  Result := List[Index] as IXMLOOSELLSTOCKType;
end;

{ TXMLOOSWITCHMFType }

procedure TXMLOOSWITCHMFType.AfterConstruction;
begin
  RegisterChildNode('OO', TXMLOOType);
  RegisterChildNode('SECID', TXMLSECIDType);
  inherited;
end;

function TXMLOOSWITCHMFType.GetOO: IXMLOOType;
begin
  Result := ChildNodes['OO'] as IXMLOOType;
end;

function TXMLOOSWITCHMFType.GetSECID: IXMLSECIDType;
begin
  Result := ChildNodes['SECID'] as IXMLSECIDType;
end;

function TXMLOOSWITCHMFType.GetUNITTYPE: UnicodeString;
begin
  Result := ChildNodes['UNITTYPE'].Text;
end;

procedure TXMLOOSWITCHMFType.SetUNITTYPE(Value: UnicodeString);
begin
  ChildNodes['UNITTYPE'].NodeValue := Value;
end;

function TXMLOOSWITCHMFType.GetSWITCHALL: UnicodeString;
begin
  Result := ChildNodes['SWITCHALL'].Text;
end;

procedure TXMLOOSWITCHMFType.SetSWITCHALL(Value: UnicodeString);
begin
  ChildNodes['SWITCHALL'].NodeValue := Value;
end;

{ TXMLOOSWITCHMFTypeList }

function TXMLOOSWITCHMFTypeList.Add: IXMLOOSWITCHMFType;
begin
  Result := AddItem(-1) as IXMLOOSWITCHMFType;
end;

function TXMLOOSWITCHMFTypeList.Insert(const Index: Integer): IXMLOOSWITCHMFType;
begin
  Result := AddItem(Index) as IXMLOOSWITCHMFType;
end;

function TXMLOOSWITCHMFTypeList.GetItem(Index: Integer): IXMLOOSWITCHMFType;
begin
  Result := List[Index] as IXMLOOSWITCHMFType;
end;

{ TXMLINVMAILTRNRSType }

procedure TXMLINVMAILTRNRSType.AfterConstruction;
begin
  RegisterChildNode('INVMAILRS', TXMLINVMAILRSType);
  inherited;
end;

function TXMLINVMAILTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLINVMAILTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLINVMAILTRNRSType.GetINVMAILRS: IXMLINVMAILRSType;
begin
  Result := ChildNodes['INVMAILRS'] as IXMLINVMAILRSType;
end;

{ TXMLINVMAILTRNRSTypeList }

function TXMLINVMAILTRNRSTypeList.Add: IXMLINVMAILTRNRSType;
begin
  Result := AddItem(-1) as IXMLINVMAILTRNRSType;
end;

function TXMLINVMAILTRNRSTypeList.Insert(const Index: Integer): IXMLINVMAILTRNRSType;
begin
  Result := AddItem(Index) as IXMLINVMAILTRNRSType;
end;

function TXMLINVMAILTRNRSTypeList.GetItem(Index: Integer): IXMLINVMAILTRNRSType;
begin
  Result := List[Index] as IXMLINVMAILTRNRSType;
end;

{ TXMLINVMAILRSType }

procedure TXMLINVMAILRSType.AfterConstruction;
begin
  RegisterChildNode('INVACCTFROM', TXMLINVACCTFROMType);
  RegisterChildNode('MAIL', TXMLMAILType);
  inherited;
end;

function TXMLINVMAILRSType.GetINVACCTFROM: IXMLINVACCTFROMType;
begin
  Result := ChildNodes['INVACCTFROM'] as IXMLINVACCTFROMType;
end;

function TXMLINVMAILRSType.GetMAIL: IXMLMAILType;
begin
  Result := ChildNodes['MAIL'] as IXMLMAILType;
end;

{ TXMLINVMAILSYNCRSType }

procedure TXMLINVMAILSYNCRSType.AfterConstruction;
begin
  RegisterChildNode('INVACCTFROM', TXMLINVACCTFROMType);
  RegisterChildNode('INVMAILTRNRS', TXMLINVMAILTRNRSType);
  FINVMAILTRNRS := CreateCollection(TXMLINVMAILTRNRSTypeList, IXMLINVMAILTRNRSType, 'INVMAILTRNRS') as IXMLINVMAILTRNRSTypeList;
  inherited;
end;

function TXMLINVMAILSYNCRSType.GetSYNCRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRSMACRO'].Text;
end;

procedure TXMLINVMAILSYNCRSType.SetSYNCRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRSMACRO'].NodeValue := Value;
end;

function TXMLINVMAILSYNCRSType.GetINVACCTFROM: IXMLINVACCTFROMType;
begin
  Result := ChildNodes['INVACCTFROM'] as IXMLINVACCTFROMType;
end;

function TXMLINVMAILSYNCRSType.GetINVMAILTRNRS: IXMLINVMAILTRNRSTypeList;
begin
  Result := FINVMAILTRNRS;
end;

{ TXMLINVMAILSYNCRSTypeList }

function TXMLINVMAILSYNCRSTypeList.Add: IXMLINVMAILSYNCRSType;
begin
  Result := AddItem(-1) as IXMLINVMAILSYNCRSType;
end;

function TXMLINVMAILSYNCRSTypeList.Insert(const Index: Integer): IXMLINVMAILSYNCRSType;
begin
  Result := AddItem(Index) as IXMLINVMAILSYNCRSType;
end;

function TXMLINVMAILSYNCRSTypeList.GetItem(Index: Integer): IXMLINVMAILSYNCRSType;
begin
  Result := List[Index] as IXMLINVMAILSYNCRSType;
end;

{ TXMLSECLISTMSGSRQV1Type }

procedure TXMLSECLISTMSGSRQV1Type.AfterConstruction;
begin
  RegisterChildNode('SECLISTTRNRQ', TXMLSECLISTTRNRQType);
  ItemTag := 'SECLISTTRNRQ';
  ItemInterface := IXMLSECLISTTRNRQType;
  inherited;
end;

function TXMLSECLISTMSGSRQV1Type.GetSECLISTTRNRQ(Index: Integer): IXMLSECLISTTRNRQType;
begin
  Result := List[Index] as IXMLSECLISTTRNRQType;
end;

function TXMLSECLISTMSGSRQV1Type.Add: IXMLSECLISTTRNRQType;
begin
  Result := AddItem(-1) as IXMLSECLISTTRNRQType;
end;

function TXMLSECLISTMSGSRQV1Type.Insert(const Index: Integer): IXMLSECLISTTRNRQType;
begin
  Result := AddItem(Index) as IXMLSECLISTTRNRQType;
end;

{ TXMLSECLISTTRNRQType }

procedure TXMLSECLISTTRNRQType.AfterConstruction;
begin
  RegisterChildNode('SECLISTRQ', TXMLSECLISTRQType);
  inherited;
end;

function TXMLSECLISTTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLSECLISTTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLSECLISTTRNRQType.GetSECLISTRQ: IXMLSECLISTRQType;
begin
  Result := ChildNodes['SECLISTRQ'] as IXMLSECLISTRQType;
end;

{ TXMLSECLISTRQType }

procedure TXMLSECLISTRQType.AfterConstruction;
begin
  RegisterChildNode('SECRQ', TXMLSECRQType);
  ItemTag := 'SECRQ';
  ItemInterface := IXMLSECRQType;
  inherited;
end;

function TXMLSECLISTRQType.GetSECRQ(Index: Integer): IXMLSECRQType;
begin
  Result := List[Index] as IXMLSECRQType;
end;

function TXMLSECLISTRQType.Add: IXMLSECRQType;
begin
  Result := AddItem(-1) as IXMLSECRQType;
end;

function TXMLSECLISTRQType.Insert(const Index: Integer): IXMLSECRQType;
begin
  Result := AddItem(Index) as IXMLSECRQType;
end;

{ TXMLSECRQType }

procedure TXMLSECRQType.AfterConstruction;
begin
  RegisterChildNode('SECID', TXMLSECIDType);
  inherited;
end;

function TXMLSECRQType.GetSECID: IXMLSECIDType;
begin
  Result := ChildNodes['SECID'] as IXMLSECIDType;
end;

function TXMLSECRQType.GetTICKER: UnicodeString;
begin
  Result := ChildNodes['TICKER'].Text;
end;

procedure TXMLSECRQType.SetTICKER(Value: UnicodeString);
begin
  ChildNodes['TICKER'].NodeValue := Value;
end;

function TXMLSECRQType.GetFIID: UnicodeString;
begin
  Result := ChildNodes['FIID'].Text;
end;

procedure TXMLSECRQType.SetFIID(Value: UnicodeString);
begin
  ChildNodes['FIID'].NodeValue := Value;
end;

{ TXMLSECLISTMSGSRSV1Type }

procedure TXMLSECLISTMSGSRSV1Type.AfterConstruction;
begin
  RegisterChildNode('SECLISTTRNRS', TXMLSECLISTTRNRSType);
  RegisterChildNode('SECLIST', TXMLSECLISTType);
  FSECLISTTRNRS := CreateCollection(TXMLSECLISTTRNRSTypeList, IXMLSECLISTTRNRSType, 'SECLISTTRNRS') as IXMLSECLISTTRNRSTypeList;
  inherited;
end;

function TXMLSECLISTMSGSRSV1Type.GetSECLISTTRNRS: IXMLSECLISTTRNRSTypeList;
begin
  Result := FSECLISTTRNRS;
end;

function TXMLSECLISTMSGSRSV1Type.GetSECLIST: IXMLSECLISTType;
begin
  Result := ChildNodes['SECLIST'] as IXMLSECLISTType;
end;

{ TXMLSECLISTTRNRSType }

function TXMLSECLISTTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLSECLISTTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLSECLISTTRNRSType.GetSECLISTRS: UnicodeString;
begin
  Result := ChildNodes['SECLISTRS'].Text;
end;

procedure TXMLSECLISTTRNRSType.SetSECLISTRS(Value: UnicodeString);
begin
  ChildNodes['SECLISTRS'].NodeValue := Value;
end;

{ TXMLSECLISTTRNRSTypeList }

function TXMLSECLISTTRNRSTypeList.Add: IXMLSECLISTTRNRSType;
begin
  Result := AddItem(-1) as IXMLSECLISTTRNRSType;
end;

function TXMLSECLISTTRNRSTypeList.Insert(const Index: Integer): IXMLSECLISTTRNRSType;
begin
  Result := AddItem(Index) as IXMLSECLISTTRNRSType;
end;

function TXMLSECLISTTRNRSTypeList.GetItem(Index: Integer): IXMLSECLISTTRNRSType;
begin
  Result := List[Index] as IXMLSECLISTTRNRSType;
end;

{ TXMLSECLISTType }

procedure TXMLSECLISTType.AfterConstruction;
begin
  RegisterChildNode('MFINFO', TXMLMFINFOType);
  RegisterChildNode('STOCKINFO', TXMLSTOCKINFOType);
  RegisterChildNode('OPTINFO', TXMLOPTINFOType);
  RegisterChildNode('DEBTINFO', TXMLDEBTINFOType);
  RegisterChildNode('OTHERINFO', TXMLOTHERINFOType);
  FMFINFO := CreateCollection(TXMLMFINFOTypeList, IXMLMFINFOType, 'MFINFO') as IXMLMFINFOTypeList;
  FSTOCKINFO := CreateCollection(TXMLSTOCKINFOTypeList, IXMLSTOCKINFOType, 'STOCKINFO') as IXMLSTOCKINFOTypeList;
  FOPTINFO := CreateCollection(TXMLOPTINFOTypeList, IXMLOPTINFOType, 'OPTINFO') as IXMLOPTINFOTypeList;
  FDEBTINFO := CreateCollection(TXMLDEBTINFOTypeList, IXMLDEBTINFOType, 'DEBTINFO') as IXMLDEBTINFOTypeList;
  FOTHERINFO := CreateCollection(TXMLOTHERINFOTypeList, IXMLOTHERINFOType, 'OTHERINFO') as IXMLOTHERINFOTypeList;
  inherited;
end;

function TXMLSECLISTType.GetMFINFO: IXMLMFINFOTypeList;
begin
  Result := FMFINFO;
end;

function TXMLSECLISTType.GetSTOCKINFO: IXMLSTOCKINFOTypeList;
begin
  Result := FSTOCKINFO;
end;

function TXMLSECLISTType.GetOPTINFO: IXMLOPTINFOTypeList;
begin
  Result := FOPTINFO;
end;

function TXMLSECLISTType.GetDEBTINFO: IXMLDEBTINFOTypeList;
begin
  Result := FDEBTINFO;
end;

function TXMLSECLISTType.GetOTHERINFO: IXMLOTHERINFOTypeList;
begin
  Result := FOTHERINFO;
end;

{ TXMLMFINFOType }

procedure TXMLMFINFOType.AfterConstruction;
begin
  RegisterChildNode('SECINFO', TXMLSECINFOType);
  RegisterChildNode('MFASSETCLASS', TXMLMFASSETCLASSType);
  RegisterChildNode('FIMFASSETCLASS', TXMLFIMFASSETCLASSType);
  inherited;
end;

function TXMLMFINFOType.GetSECINFO: IXMLSECINFOType;
begin
  Result := ChildNodes['SECINFO'] as IXMLSECINFOType;
end;

function TXMLMFINFOType.GetMFTYPE: UnicodeString;
begin
  Result := ChildNodes['MFTYPE'].Text;
end;

procedure TXMLMFINFOType.SetMFTYPE(Value: UnicodeString);
begin
  ChildNodes['MFTYPE'].NodeValue := Value;
end;

function TXMLMFINFOType.GetYIELD: UnicodeString;
begin
  Result := ChildNodes['YIELD'].Text;
end;

procedure TXMLMFINFOType.SetYIELD(Value: UnicodeString);
begin
  ChildNodes['YIELD'].NodeValue := Value;
end;

function TXMLMFINFOType.GetDTYIELDASOF: UnicodeString;
begin
  Result := ChildNodes['DTYIELDASOF'].Text;
end;

procedure TXMLMFINFOType.SetDTYIELDASOF(Value: UnicodeString);
begin
  ChildNodes['DTYIELDASOF'].NodeValue := Value;
end;

function TXMLMFINFOType.GetMFASSETCLASS: IXMLMFASSETCLASSType;
begin
  Result := ChildNodes['MFASSETCLASS'] as IXMLMFASSETCLASSType;
end;

function TXMLMFINFOType.GetFIMFASSETCLASS: IXMLFIMFASSETCLASSType;
begin
  Result := ChildNodes['FIMFASSETCLASS'] as IXMLFIMFASSETCLASSType;
end;

{ TXMLMFINFOTypeList }

function TXMLMFINFOTypeList.Add: IXMLMFINFOType;
begin
  Result := AddItem(-1) as IXMLMFINFOType;
end;

function TXMLMFINFOTypeList.Insert(const Index: Integer): IXMLMFINFOType;
begin
  Result := AddItem(Index) as IXMLMFINFOType;
end;

function TXMLMFINFOTypeList.GetItem(Index: Integer): IXMLMFINFOType;
begin
  Result := List[Index] as IXMLMFINFOType;
end;

{ TXMLSECINFOType }

procedure TXMLSECINFOType.AfterConstruction;
begin
  RegisterChildNode('SECID', TXMLSECIDType);
  inherited;
end;

function TXMLSECINFOType.GetSECID: IXMLSECIDType;
begin
  Result := ChildNodes['SECID'] as IXMLSECIDType;
end;

function TXMLSECINFOType.GetSECNAME: UnicodeString;
begin
  Result := ChildNodes['SECNAME'].Text;
end;

procedure TXMLSECINFOType.SetSECNAME(Value: UnicodeString);
begin
  ChildNodes['SECNAME'].NodeValue := Value;
end;

function TXMLSECINFOType.GetTICKER: UnicodeString;
begin
  Result := ChildNodes['TICKER'].Text;
end;

procedure TXMLSECINFOType.SetTICKER(Value: UnicodeString);
begin
  ChildNodes['TICKER'].NodeValue := Value;
end;

function TXMLSECINFOType.GetFIID: UnicodeString;
begin
  Result := ChildNodes['FIID'].Text;
end;

procedure TXMLSECINFOType.SetFIID(Value: UnicodeString);
begin
  ChildNodes['FIID'].NodeValue := Value;
end;

function TXMLSECINFOType.GetRATING: UnicodeString;
begin
  Result := ChildNodes['RATING'].Text;
end;

procedure TXMLSECINFOType.SetRATING(Value: UnicodeString);
begin
  ChildNodes['RATING'].NodeValue := Value;
end;

function TXMLSECINFOType.GetUNITPRICE: UnicodeString;
begin
  Result := ChildNodes['UNITPRICE'].Text;
end;

procedure TXMLSECINFOType.SetUNITPRICE(Value: UnicodeString);
begin
  ChildNodes['UNITPRICE'].NodeValue := Value;
end;

function TXMLSECINFOType.GetDTASOF: UnicodeString;
begin
  Result := ChildNodes['DTASOF'].Text;
end;

procedure TXMLSECINFOType.SetDTASOF(Value: UnicodeString);
begin
  ChildNodes['DTASOF'].NodeValue := Value;
end;

function TXMLSECINFOType.GetCURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLSECINFOType.SetCURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLSECINFOType.GetMEMO: UnicodeString;
begin
  Result := ChildNodes['MEMO'].Text;
end;

procedure TXMLSECINFOType.SetMEMO(Value: UnicodeString);
begin
  ChildNodes['MEMO'].NodeValue := Value;
end;

{ TXMLMFASSETCLASSType }

procedure TXMLMFASSETCLASSType.AfterConstruction;
begin
  RegisterChildNode('PORTION', TXMLPORTIONType);
  ItemTag := 'PORTION';
  ItemInterface := IXMLPORTIONType;
  inherited;
end;

function TXMLMFASSETCLASSType.GetPORTION(Index: Integer): IXMLPORTIONType;
begin
  Result := List[Index] as IXMLPORTIONType;
end;

function TXMLMFASSETCLASSType.Add: IXMLPORTIONType;
begin
  Result := AddItem(-1) as IXMLPORTIONType;
end;

function TXMLMFASSETCLASSType.Insert(const Index: Integer): IXMLPORTIONType;
begin
  Result := AddItem(Index) as IXMLPORTIONType;
end;

{ TXMLPORTIONType }

function TXMLPORTIONType.GetASSETCLASS: UnicodeString;
begin
  Result := ChildNodes['ASSETCLASS'].Text;
end;

procedure TXMLPORTIONType.SetASSETCLASS(Value: UnicodeString);
begin
  ChildNodes['ASSETCLASS'].NodeValue := Value;
end;

function TXMLPORTIONType.GetPERCENT: UnicodeString;
begin
  Result := ChildNodes['PERCENT'].Text;
end;

procedure TXMLPORTIONType.SetPERCENT(Value: UnicodeString);
begin
  ChildNodes['PERCENT'].NodeValue := Value;
end;

{ TXMLFIMFASSETCLASSType }

procedure TXMLFIMFASSETCLASSType.AfterConstruction;
begin
  RegisterChildNode('FIPORTION', TXMLFIPORTIONType);
  ItemTag := 'FIPORTION';
  ItemInterface := IXMLFIPORTIONType;
  inherited;
end;

function TXMLFIMFASSETCLASSType.GetFIPORTION(Index: Integer): IXMLFIPORTIONType;
begin
  Result := List[Index] as IXMLFIPORTIONType;
end;

function TXMLFIMFASSETCLASSType.Add: IXMLFIPORTIONType;
begin
  Result := AddItem(-1) as IXMLFIPORTIONType;
end;

function TXMLFIMFASSETCLASSType.Insert(const Index: Integer): IXMLFIPORTIONType;
begin
  Result := AddItem(Index) as IXMLFIPORTIONType;
end;

{ TXMLFIPORTIONType }

function TXMLFIPORTIONType.GetFIASSETCLASS: UnicodeString;
begin
  Result := ChildNodes['FIASSETCLASS'].Text;
end;

procedure TXMLFIPORTIONType.SetFIASSETCLASS(Value: UnicodeString);
begin
  ChildNodes['FIASSETCLASS'].NodeValue := Value;
end;

function TXMLFIPORTIONType.GetPERCENT: UnicodeString;
begin
  Result := ChildNodes['PERCENT'].Text;
end;

procedure TXMLFIPORTIONType.SetPERCENT(Value: UnicodeString);
begin
  ChildNodes['PERCENT'].NodeValue := Value;
end;

{ TXMLSTOCKINFOType }

procedure TXMLSTOCKINFOType.AfterConstruction;
begin
  RegisterChildNode('SECINFO', TXMLSECINFOType);
  inherited;
end;

function TXMLSTOCKINFOType.GetSECINFO: IXMLSECINFOType;
begin
  Result := ChildNodes['SECINFO'] as IXMLSECINFOType;
end;

function TXMLSTOCKINFOType.GetSTOCKTYPE: UnicodeString;
begin
  Result := ChildNodes['STOCKTYPE'].Text;
end;

procedure TXMLSTOCKINFOType.SetSTOCKTYPE(Value: UnicodeString);
begin
  ChildNodes['STOCKTYPE'].NodeValue := Value;
end;

function TXMLSTOCKINFOType.GetYIELD: UnicodeString;
begin
  Result := ChildNodes['YIELD'].Text;
end;

procedure TXMLSTOCKINFOType.SetYIELD(Value: UnicodeString);
begin
  ChildNodes['YIELD'].NodeValue := Value;
end;

function TXMLSTOCKINFOType.GetDTYIELDASOF: UnicodeString;
begin
  Result := ChildNodes['DTYIELDASOF'].Text;
end;

procedure TXMLSTOCKINFOType.SetDTYIELDASOF(Value: UnicodeString);
begin
  ChildNodes['DTYIELDASOF'].NodeValue := Value;
end;

function TXMLSTOCKINFOType.GetASSETCLASS: UnicodeString;
begin
  Result := ChildNodes['ASSETCLASS'].Text;
end;

procedure TXMLSTOCKINFOType.SetASSETCLASS(Value: UnicodeString);
begin
  ChildNodes['ASSETCLASS'].NodeValue := Value;
end;

function TXMLSTOCKINFOType.GetFIASSETCLASS: UnicodeString;
begin
  Result := ChildNodes['FIASSETCLASS'].Text;
end;

procedure TXMLSTOCKINFOType.SetFIASSETCLASS(Value: UnicodeString);
begin
  ChildNodes['FIASSETCLASS'].NodeValue := Value;
end;

{ TXMLSTOCKINFOTypeList }

function TXMLSTOCKINFOTypeList.Add: IXMLSTOCKINFOType;
begin
  Result := AddItem(-1) as IXMLSTOCKINFOType;
end;

function TXMLSTOCKINFOTypeList.Insert(const Index: Integer): IXMLSTOCKINFOType;
begin
  Result := AddItem(Index) as IXMLSTOCKINFOType;
end;

function TXMLSTOCKINFOTypeList.GetItem(Index: Integer): IXMLSTOCKINFOType;
begin
  Result := List[Index] as IXMLSTOCKINFOType;
end;

{ TXMLOPTINFOType }

procedure TXMLOPTINFOType.AfterConstruction;
begin
  RegisterChildNode('SECINFO', TXMLSECINFOType);
  RegisterChildNode('SECID', TXMLSECIDType);
  inherited;
end;

function TXMLOPTINFOType.GetSECINFO: IXMLSECINFOType;
begin
  Result := ChildNodes['SECINFO'] as IXMLSECINFOType;
end;

function TXMLOPTINFOType.GetOPTTYPE: UnicodeString;
begin
  Result := ChildNodes['OPTTYPE'].Text;
end;

procedure TXMLOPTINFOType.SetOPTTYPE(Value: UnicodeString);
begin
  ChildNodes['OPTTYPE'].NodeValue := Value;
end;

function TXMLOPTINFOType.GetSTRIKEPRICE: UnicodeString;
begin
  Result := ChildNodes['STRIKEPRICE'].Text;
end;

procedure TXMLOPTINFOType.SetSTRIKEPRICE(Value: UnicodeString);
begin
  ChildNodes['STRIKEPRICE'].NodeValue := Value;
end;

function TXMLOPTINFOType.GetDTEXPIRE: UnicodeString;
begin
  Result := ChildNodes['DTEXPIRE'].Text;
end;

procedure TXMLOPTINFOType.SetDTEXPIRE(Value: UnicodeString);
begin
  ChildNodes['DTEXPIRE'].NodeValue := Value;
end;

function TXMLOPTINFOType.GetSHPERCTRCT: UnicodeString;
begin
  Result := ChildNodes['SHPERCTRCT'].Text;
end;

procedure TXMLOPTINFOType.SetSHPERCTRCT(Value: UnicodeString);
begin
  ChildNodes['SHPERCTRCT'].NodeValue := Value;
end;

function TXMLOPTINFOType.GetSECID: IXMLSECIDType;
begin
  Result := ChildNodes['SECID'] as IXMLSECIDType;
end;

function TXMLOPTINFOType.GetASSETCLASS: UnicodeString;
begin
  Result := ChildNodes['ASSETCLASS'].Text;
end;

procedure TXMLOPTINFOType.SetASSETCLASS(Value: UnicodeString);
begin
  ChildNodes['ASSETCLASS'].NodeValue := Value;
end;

function TXMLOPTINFOType.GetFIASSETCLASS: UnicodeString;
begin
  Result := ChildNodes['FIASSETCLASS'].Text;
end;

procedure TXMLOPTINFOType.SetFIASSETCLASS(Value: UnicodeString);
begin
  ChildNodes['FIASSETCLASS'].NodeValue := Value;
end;

{ TXMLOPTINFOTypeList }

function TXMLOPTINFOTypeList.Add: IXMLOPTINFOType;
begin
  Result := AddItem(-1) as IXMLOPTINFOType;
end;

function TXMLOPTINFOTypeList.Insert(const Index: Integer): IXMLOPTINFOType;
begin
  Result := AddItem(Index) as IXMLOPTINFOType;
end;

function TXMLOPTINFOTypeList.GetItem(Index: Integer): IXMLOPTINFOType;
begin
  Result := List[Index] as IXMLOPTINFOType;
end;

{ TXMLDEBTINFOType }

procedure TXMLDEBTINFOType.AfterConstruction;
begin
  RegisterChildNode('SECINFO', TXMLSECINFOType);
  inherited;
end;

function TXMLDEBTINFOType.GetSECINFO: IXMLSECINFOType;
begin
  Result := ChildNodes['SECINFO'] as IXMLSECINFOType;
end;

function TXMLDEBTINFOType.GetPARVALUE: UnicodeString;
begin
  Result := ChildNodes['PARVALUE'].Text;
end;

procedure TXMLDEBTINFOType.SetPARVALUE(Value: UnicodeString);
begin
  ChildNodes['PARVALUE'].NodeValue := Value;
end;

function TXMLDEBTINFOType.GetDEBTTYPE: UnicodeString;
begin
  Result := ChildNodes['DEBTTYPE'].Text;
end;

procedure TXMLDEBTINFOType.SetDEBTTYPE(Value: UnicodeString);
begin
  ChildNodes['DEBTTYPE'].NodeValue := Value;
end;

function TXMLDEBTINFOType.GetDEBTCLASS: UnicodeString;
begin
  Result := ChildNodes['DEBTCLASS'].Text;
end;

procedure TXMLDEBTINFOType.SetDEBTCLASS(Value: UnicodeString);
begin
  ChildNodes['DEBTCLASS'].NodeValue := Value;
end;

function TXMLDEBTINFOType.GetCOUPONRT: UnicodeString;
begin
  Result := ChildNodes['COUPONRT'].Text;
end;

procedure TXMLDEBTINFOType.SetCOUPONRT(Value: UnicodeString);
begin
  ChildNodes['COUPONRT'].NodeValue := Value;
end;

function TXMLDEBTINFOType.GetDTCOUPON: UnicodeString;
begin
  Result := ChildNodes['DTCOUPON'].Text;
end;

procedure TXMLDEBTINFOType.SetDTCOUPON(Value: UnicodeString);
begin
  ChildNodes['DTCOUPON'].NodeValue := Value;
end;

function TXMLDEBTINFOType.GetCOUPONFREQ: UnicodeString;
begin
  Result := ChildNodes['COUPONFREQ'].Text;
end;

procedure TXMLDEBTINFOType.SetCOUPONFREQ(Value: UnicodeString);
begin
  ChildNodes['COUPONFREQ'].NodeValue := Value;
end;

function TXMLDEBTINFOType.GetCALLPRICE: UnicodeString;
begin
  Result := ChildNodes['CALLPRICE'].Text;
end;

procedure TXMLDEBTINFOType.SetCALLPRICE(Value: UnicodeString);
begin
  ChildNodes['CALLPRICE'].NodeValue := Value;
end;

function TXMLDEBTINFOType.GetYIELDTOCALL: UnicodeString;
begin
  Result := ChildNodes['YIELDTOCALL'].Text;
end;

procedure TXMLDEBTINFOType.SetYIELDTOCALL(Value: UnicodeString);
begin
  ChildNodes['YIELDTOCALL'].NodeValue := Value;
end;

function TXMLDEBTINFOType.GetDTCALL: UnicodeString;
begin
  Result := ChildNodes['DTCALL'].Text;
end;

procedure TXMLDEBTINFOType.SetDTCALL(Value: UnicodeString);
begin
  ChildNodes['DTCALL'].NodeValue := Value;
end;

function TXMLDEBTINFOType.GetCALLTYPE: UnicodeString;
begin
  Result := ChildNodes['CALLTYPE'].Text;
end;

procedure TXMLDEBTINFOType.SetCALLTYPE(Value: UnicodeString);
begin
  ChildNodes['CALLTYPE'].NodeValue := Value;
end;

function TXMLDEBTINFOType.GetYIELDTOMAT: UnicodeString;
begin
  Result := ChildNodes['YIELDTOMAT'].Text;
end;

procedure TXMLDEBTINFOType.SetYIELDTOMAT(Value: UnicodeString);
begin
  ChildNodes['YIELDTOMAT'].NodeValue := Value;
end;

function TXMLDEBTINFOType.GetDTMAT: UnicodeString;
begin
  Result := ChildNodes['DTMAT'].Text;
end;

procedure TXMLDEBTINFOType.SetDTMAT(Value: UnicodeString);
begin
  ChildNodes['DTMAT'].NodeValue := Value;
end;

function TXMLDEBTINFOType.GetASSETCLASS: UnicodeString;
begin
  Result := ChildNodes['ASSETCLASS'].Text;
end;

procedure TXMLDEBTINFOType.SetASSETCLASS(Value: UnicodeString);
begin
  ChildNodes['ASSETCLASS'].NodeValue := Value;
end;

function TXMLDEBTINFOType.GetFIASSETCLASS: UnicodeString;
begin
  Result := ChildNodes['FIASSETCLASS'].Text;
end;

procedure TXMLDEBTINFOType.SetFIASSETCLASS(Value: UnicodeString);
begin
  ChildNodes['FIASSETCLASS'].NodeValue := Value;
end;

{ TXMLDEBTINFOTypeList }

function TXMLDEBTINFOTypeList.Add: IXMLDEBTINFOType;
begin
  Result := AddItem(-1) as IXMLDEBTINFOType;
end;

function TXMLDEBTINFOTypeList.Insert(const Index: Integer): IXMLDEBTINFOType;
begin
  Result := AddItem(Index) as IXMLDEBTINFOType;
end;

function TXMLDEBTINFOTypeList.GetItem(Index: Integer): IXMLDEBTINFOType;
begin
  Result := List[Index] as IXMLDEBTINFOType;
end;

{ TXMLOTHERINFOType }

procedure TXMLOTHERINFOType.AfterConstruction;
begin
  RegisterChildNode('SECINFO', TXMLSECINFOType);
  inherited;
end;

function TXMLOTHERINFOType.GetSECINFO: IXMLSECINFOType;
begin
  Result := ChildNodes['SECINFO'] as IXMLSECINFOType;
end;

function TXMLOTHERINFOType.GetTYPEDESC: UnicodeString;
begin
  Result := ChildNodes['TYPEDESC'].Text;
end;

procedure TXMLOTHERINFOType.SetTYPEDESC(Value: UnicodeString);
begin
  ChildNodes['TYPEDESC'].NodeValue := Value;
end;

function TXMLOTHERINFOType.GetASSETCLASS: UnicodeString;
begin
  Result := ChildNodes['ASSETCLASS'].Text;
end;

procedure TXMLOTHERINFOType.SetASSETCLASS(Value: UnicodeString);
begin
  ChildNodes['ASSETCLASS'].NodeValue := Value;
end;

function TXMLOTHERINFOType.GetFIASSETCLASS: UnicodeString;
begin
  Result := ChildNodes['FIASSETCLASS'].Text;
end;

procedure TXMLOTHERINFOType.SetFIASSETCLASS(Value: UnicodeString);
begin
  ChildNodes['FIASSETCLASS'].NodeValue := Value;
end;

{ TXMLOTHERINFOTypeList }

function TXMLOTHERINFOTypeList.Add: IXMLOTHERINFOType;
begin
  Result := AddItem(-1) as IXMLOTHERINFOType;
end;

function TXMLOTHERINFOTypeList.Insert(const Index: Integer): IXMLOTHERINFOType;
begin
  Result := AddItem(Index) as IXMLOTHERINFOType;
end;

function TXMLOTHERINFOTypeList.GetItem(Index: Integer): IXMLOTHERINFOType;
begin
  Result := List[Index] as IXMLOTHERINFOType;
end;

{ TXMLINVACCTTOType }

function TXMLINVACCTTOType.GetBROKERID: UnicodeString;
begin
  Result := ChildNodes['BROKERID'].Text;
end;

procedure TXMLINVACCTTOType.SetBROKERID(Value: UnicodeString);
begin
  ChildNodes['BROKERID'].NodeValue := Value;
end;

function TXMLINVACCTTOType.GetACCTID: UnicodeString;
begin
  Result := ChildNodes['ACCTID'].Text;
end;

procedure TXMLINVACCTTOType.SetACCTID(Value: UnicodeString);
begin
  ChildNodes['ACCTID'].NodeValue := Value;
end;

{ TXMLINVACCTINFOType }

procedure TXMLINVACCTINFOType.AfterConstruction;
begin
  RegisterChildNode('INVACCTFROM', TXMLINVACCTFROMType);
  inherited;
end;

function TXMLINVACCTINFOType.GetINVACCTFROM: IXMLINVACCTFROMType;
begin
  Result := ChildNodes['INVACCTFROM'] as IXMLINVACCTFROMType;
end;

function TXMLINVACCTINFOType.GetUSPRODUCTTYPE: UnicodeString;
begin
  Result := ChildNodes['USPRODUCTTYPE'].Text;
end;

procedure TXMLINVACCTINFOType.SetUSPRODUCTTYPE(Value: UnicodeString);
begin
  ChildNodes['USPRODUCTTYPE'].NodeValue := Value;
end;

function TXMLINVACCTINFOType.GetCHECKING: UnicodeString;
begin
  Result := ChildNodes['CHECKING'].Text;
end;

procedure TXMLINVACCTINFOType.SetCHECKING(Value: UnicodeString);
begin
  ChildNodes['CHECKING'].NodeValue := Value;
end;

function TXMLINVACCTINFOType.GetSVCSTATUS: UnicodeString;
begin
  Result := ChildNodes['SVCSTATUS'].Text;
end;

procedure TXMLINVACCTINFOType.SetSVCSTATUS(Value: UnicodeString);
begin
  ChildNodes['SVCSTATUS'].NodeValue := Value;
end;

function TXMLINVACCTINFOType.GetINVACCTTYPE: UnicodeString;
begin
  Result := ChildNodes['INVACCTTYPE'].Text;
end;

procedure TXMLINVACCTINFOType.SetINVACCTTYPE(Value: UnicodeString);
begin
  ChildNodes['INVACCTTYPE'].NodeValue := Value;
end;

function TXMLINVACCTINFOType.GetOPTIONLEVEL: UnicodeString;
begin
  Result := ChildNodes['OPTIONLEVEL'].Text;
end;

procedure TXMLINVACCTINFOType.SetOPTIONLEVEL(Value: UnicodeString);
begin
  ChildNodes['OPTIONLEVEL'].NodeValue := Value;
end;

{ TXMLINVSTMTMSGSETType }

procedure TXMLINVSTMTMSGSETType.AfterConstruction;
begin
  RegisterChildNode('INVSTMTMSGSETV1', TXMLINVSTMTMSGSETV1Type);
  inherited;
end;

function TXMLINVSTMTMSGSETType.GetINVSTMTMSGSETV1: IXMLINVSTMTMSGSETV1Type;
begin
  Result := ChildNodes['INVSTMTMSGSETV1'] as IXMLINVSTMTMSGSETV1Type;
end;

{ TXMLINVSTMTMSGSETV1Type }

procedure TXMLINVSTMTMSGSETV1Type.AfterConstruction;
begin
  RegisterChildNode('MSGSETCORE', TXMLMSGSETCOREType);
  inherited;
end;

function TXMLINVSTMTMSGSETV1Type.GetMSGSETCORE: IXMLMSGSETCOREType;
begin
  Result := ChildNodes['MSGSETCORE'] as IXMLMSGSETCOREType;
end;

function TXMLINVSTMTMSGSETV1Type.GetTRANDNLD: UnicodeString;
begin
  Result := ChildNodes['TRANDNLD'].Text;
end;

procedure TXMLINVSTMTMSGSETV1Type.SetTRANDNLD(Value: UnicodeString);
begin
  ChildNodes['TRANDNLD'].NodeValue := Value;
end;

function TXMLINVSTMTMSGSETV1Type.GetOODNLD: UnicodeString;
begin
  Result := ChildNodes['OODNLD'].Text;
end;

procedure TXMLINVSTMTMSGSETV1Type.SetOODNLD(Value: UnicodeString);
begin
  ChildNodes['OODNLD'].NodeValue := Value;
end;

function TXMLINVSTMTMSGSETV1Type.GetPOSDNLD: UnicodeString;
begin
  Result := ChildNodes['POSDNLD'].Text;
end;

procedure TXMLINVSTMTMSGSETV1Type.SetPOSDNLD(Value: UnicodeString);
begin
  ChildNodes['POSDNLD'].NodeValue := Value;
end;

function TXMLINVSTMTMSGSETV1Type.GetBALDNLD: UnicodeString;
begin
  Result := ChildNodes['BALDNLD'].Text;
end;

procedure TXMLINVSTMTMSGSETV1Type.SetBALDNLD(Value: UnicodeString);
begin
  ChildNodes['BALDNLD'].NodeValue := Value;
end;

function TXMLINVSTMTMSGSETV1Type.GetCANEMAIL: UnicodeString;
begin
  Result := ChildNodes['CANEMAIL'].Text;
end;

procedure TXMLINVSTMTMSGSETV1Type.SetCANEMAIL(Value: UnicodeString);
begin
  ChildNodes['CANEMAIL'].NodeValue := Value;
end;

{ TXMLSECLISTMSGSETType }

procedure TXMLSECLISTMSGSETType.AfterConstruction;
begin
  RegisterChildNode('SECLISTMSGSETV1', TXMLSECLISTMSGSETV1Type);
  inherited;
end;

function TXMLSECLISTMSGSETType.GetSECLISTMSGSETV1: IXMLSECLISTMSGSETV1Type;
begin
  Result := ChildNodes['SECLISTMSGSETV1'] as IXMLSECLISTMSGSETV1Type;
end;

{ TXMLSECLISTMSGSETV1Type }

procedure TXMLSECLISTMSGSETV1Type.AfterConstruction;
begin
  RegisterChildNode('MSGSETCORE', TXMLMSGSETCOREType);
  inherited;
end;

function TXMLSECLISTMSGSETV1Type.GetMSGSETCORE: IXMLMSGSETCOREType;
begin
  Result := ChildNodes['MSGSETCORE'] as IXMLMSGSETCOREType;
end;

function TXMLSECLISTMSGSETV1Type.GetSECLISTRQDNLD: UnicodeString;
begin
  Result := ChildNodes['SECLISTRQDNLD'].Text;
end;

procedure TXMLSECLISTMSGSETV1Type.SetSECLISTRQDNLD(Value: UnicodeString);
begin
  ChildNodes['SECLISTRQDNLD'].NodeValue := Value;
end;

{ TXMLEMAILMSGSRQV1Type }

procedure TXMLEMAILMSGSRQV1Type.AfterConstruction;
begin
  RegisterChildNode('MAILTRNRQ', TXMLMAILTRNRQType);
  RegisterChildNode('MAILSYNCRQ', TXMLMAILSYNCRQType);
  RegisterChildNode('GETMIMETRNRQ', TXMLGETMIMETRNRQType);
  FMAILTRNRQ := CreateCollection(TXMLMAILTRNRQTypeList, IXMLMAILTRNRQType, 'MAILTRNRQ') as IXMLMAILTRNRQTypeList;
  FMAILSYNCRQ := CreateCollection(TXMLMAILSYNCRQTypeList, IXMLMAILSYNCRQType, 'MAILSYNCRQ') as IXMLMAILSYNCRQTypeList;
  FGETMIMETRNRQ := CreateCollection(TXMLGETMIMETRNRQTypeList, IXMLGETMIMETRNRQType, 'GETMIMETRNRQ') as IXMLGETMIMETRNRQTypeList;
  inherited;
end;

function TXMLEMAILMSGSRQV1Type.GetMAILTRNRQ: IXMLMAILTRNRQTypeList;
begin
  Result := FMAILTRNRQ;
end;

function TXMLEMAILMSGSRQV1Type.GetMAILSYNCRQ: IXMLMAILSYNCRQTypeList;
begin
  Result := FMAILSYNCRQ;
end;

function TXMLEMAILMSGSRQV1Type.GetGETMIMETRNRQ: IXMLGETMIMETRNRQTypeList;
begin
  Result := FGETMIMETRNRQ;
end;

{ TXMLMAILTRNRQType }

procedure TXMLMAILTRNRQType.AfterConstruction;
begin
  RegisterChildNode('MAILRQ', TXMLMAILRQType);
  inherited;
end;

function TXMLMAILTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLMAILTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLMAILTRNRQType.GetMAILRQ: IXMLMAILRQType;
begin
  Result := ChildNodes['MAILRQ'] as IXMLMAILRQType;
end;

{ TXMLMAILTRNRQTypeList }

function TXMLMAILTRNRQTypeList.Add: IXMLMAILTRNRQType;
begin
  Result := AddItem(-1) as IXMLMAILTRNRQType;
end;

function TXMLMAILTRNRQTypeList.Insert(const Index: Integer): IXMLMAILTRNRQType;
begin
  Result := AddItem(Index) as IXMLMAILTRNRQType;
end;

function TXMLMAILTRNRQTypeList.GetItem(Index: Integer): IXMLMAILTRNRQType;
begin
  Result := List[Index] as IXMLMAILTRNRQType;
end;

{ TXMLMAILRQType }

procedure TXMLMAILRQType.AfterConstruction;
begin
  RegisterChildNode('MAIL', TXMLMAILType);
  inherited;
end;

function TXMLMAILRQType.GetMAIL: IXMLMAILType;
begin
  Result := ChildNodes['MAIL'] as IXMLMAILType;
end;

{ TXMLMAILSYNCRQType }

procedure TXMLMAILSYNCRQType.AfterConstruction;
begin
  RegisterChildNode('MAILTRNRQ', TXMLMAILTRNRQType);
  FMAILTRNRQ := CreateCollection(TXMLMAILTRNRQTypeList, IXMLMAILTRNRQType, 'MAILTRNRQ') as IXMLMAILTRNRQTypeList;
  inherited;
end;

function TXMLMAILSYNCRQType.GetSYNCRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRQMACRO'].Text;
end;

procedure TXMLMAILSYNCRQType.SetSYNCRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRQMACRO'].NodeValue := Value;
end;

function TXMLMAILSYNCRQType.GetINCIMAGES: UnicodeString;
begin
  Result := ChildNodes['INCIMAGES'].Text;
end;

procedure TXMLMAILSYNCRQType.SetINCIMAGES(Value: UnicodeString);
begin
  ChildNodes['INCIMAGES'].NodeValue := Value;
end;

function TXMLMAILSYNCRQType.GetUSEHTML: UnicodeString;
begin
  Result := ChildNodes['USEHTML'].Text;
end;

procedure TXMLMAILSYNCRQType.SetUSEHTML(Value: UnicodeString);
begin
  ChildNodes['USEHTML'].NodeValue := Value;
end;

function TXMLMAILSYNCRQType.GetMAILTRNRQ: IXMLMAILTRNRQTypeList;
begin
  Result := FMAILTRNRQ;
end;

{ TXMLMAILSYNCRQTypeList }

function TXMLMAILSYNCRQTypeList.Add: IXMLMAILSYNCRQType;
begin
  Result := AddItem(-1) as IXMLMAILSYNCRQType;
end;

function TXMLMAILSYNCRQTypeList.Insert(const Index: Integer): IXMLMAILSYNCRQType;
begin
  Result := AddItem(Index) as IXMLMAILSYNCRQType;
end;

function TXMLMAILSYNCRQTypeList.GetItem(Index: Integer): IXMLMAILSYNCRQType;
begin
  Result := List[Index] as IXMLMAILSYNCRQType;
end;

{ TXMLGETMIMETRNRQType }

procedure TXMLGETMIMETRNRQType.AfterConstruction;
begin
  RegisterChildNode('GETMIMERQ', TXMLGETMIMERQType);
  inherited;
end;

function TXMLGETMIMETRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLGETMIMETRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLGETMIMETRNRQType.GetGETMIMERQ: IXMLGETMIMERQType;
begin
  Result := ChildNodes['GETMIMERQ'] as IXMLGETMIMERQType;
end;

{ TXMLGETMIMETRNRQTypeList }

function TXMLGETMIMETRNRQTypeList.Add: IXMLGETMIMETRNRQType;
begin
  Result := AddItem(-1) as IXMLGETMIMETRNRQType;
end;

function TXMLGETMIMETRNRQTypeList.Insert(const Index: Integer): IXMLGETMIMETRNRQType;
begin
  Result := AddItem(Index) as IXMLGETMIMETRNRQType;
end;

function TXMLGETMIMETRNRQTypeList.GetItem(Index: Integer): IXMLGETMIMETRNRQType;
begin
  Result := List[Index] as IXMLGETMIMETRNRQType;
end;

{ TXMLGETMIMERQType }

function TXMLGETMIMERQType.GetURL: UnicodeString;
begin
  Result := ChildNodes['URL'].Text;
end;

procedure TXMLGETMIMERQType.SetURL(Value: UnicodeString);
begin
  ChildNodes['URL'].NodeValue := Value;
end;

{ TXMLEMAILMSGSRSV1Type }

procedure TXMLEMAILMSGSRSV1Type.AfterConstruction;
begin
  RegisterChildNode('MAILTRNRS', TXMLMAILTRNRSType);
  RegisterChildNode('MAILSYNCRS', TXMLMAILSYNCRSType);
  RegisterChildNode('GETMIMETRNRS', TXMLGETMIMETRNRSType);
  FMAILTRNRS := CreateCollection(TXMLMAILTRNRSTypeList, IXMLMAILTRNRSType, 'MAILTRNRS') as IXMLMAILTRNRSTypeList;
  FMAILSYNCRS := CreateCollection(TXMLMAILSYNCRSTypeList, IXMLMAILSYNCRSType, 'MAILSYNCRS') as IXMLMAILSYNCRSTypeList;
  FGETMIMETRNRS := CreateCollection(TXMLGETMIMETRNRSTypeList, IXMLGETMIMETRNRSType, 'GETMIMETRNRS') as IXMLGETMIMETRNRSTypeList;
  inherited;
end;

function TXMLEMAILMSGSRSV1Type.GetMAILTRNRS: IXMLMAILTRNRSTypeList;
begin
  Result := FMAILTRNRS;
end;

function TXMLEMAILMSGSRSV1Type.GetMAILSYNCRS: IXMLMAILSYNCRSTypeList;
begin
  Result := FMAILSYNCRS;
end;

function TXMLEMAILMSGSRSV1Type.GetGETMIMETRNRS: IXMLGETMIMETRNRSTypeList;
begin
  Result := FGETMIMETRNRS;
end;

{ TXMLMAILTRNRSType }

procedure TXMLMAILTRNRSType.AfterConstruction;
begin
  RegisterChildNode('MAILRS', TXMLMAILRSType);
  inherited;
end;

function TXMLMAILTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLMAILTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLMAILTRNRSType.GetMAILRS: IXMLMAILRSType;
begin
  Result := ChildNodes['MAILRS'] as IXMLMAILRSType;
end;

{ TXMLMAILTRNRSTypeList }

function TXMLMAILTRNRSTypeList.Add: IXMLMAILTRNRSType;
begin
  Result := AddItem(-1) as IXMLMAILTRNRSType;
end;

function TXMLMAILTRNRSTypeList.Insert(const Index: Integer): IXMLMAILTRNRSType;
begin
  Result := AddItem(Index) as IXMLMAILTRNRSType;
end;

function TXMLMAILTRNRSTypeList.GetItem(Index: Integer): IXMLMAILTRNRSType;
begin
  Result := List[Index] as IXMLMAILTRNRSType;
end;

{ TXMLMAILRSType }

procedure TXMLMAILRSType.AfterConstruction;
begin
  RegisterChildNode('MAIL', TXMLMAILType);
  inherited;
end;

function TXMLMAILRSType.GetMAIL: IXMLMAILType;
begin
  Result := ChildNodes['MAIL'] as IXMLMAILType;
end;

{ TXMLMAILSYNCRSType }

procedure TXMLMAILSYNCRSType.AfterConstruction;
begin
  RegisterChildNode('MAILTRNRS', TXMLMAILTRNRSType);
  FMAILTRNRS := CreateCollection(TXMLMAILTRNRSTypeList, IXMLMAILTRNRSType, 'MAILTRNRS') as IXMLMAILTRNRSTypeList;
  inherited;
end;

function TXMLMAILSYNCRSType.GetSYNCRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%SYNCRSMACRO'].Text;
end;

procedure TXMLMAILSYNCRSType.SetSYNCRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%SYNCRSMACRO'].NodeValue := Value;
end;

function TXMLMAILSYNCRSType.GetMAILTRNRS: IXMLMAILTRNRSTypeList;
begin
  Result := FMAILTRNRS;
end;

{ TXMLMAILSYNCRSTypeList }

function TXMLMAILSYNCRSTypeList.Add: IXMLMAILSYNCRSType;
begin
  Result := AddItem(-1) as IXMLMAILSYNCRSType;
end;

function TXMLMAILSYNCRSTypeList.Insert(const Index: Integer): IXMLMAILSYNCRSType;
begin
  Result := AddItem(Index) as IXMLMAILSYNCRSType;
end;

function TXMLMAILSYNCRSTypeList.GetItem(Index: Integer): IXMLMAILSYNCRSType;
begin
  Result := List[Index] as IXMLMAILSYNCRSType;
end;

{ TXMLGETMIMETRNRSType }

procedure TXMLGETMIMETRNRSType.AfterConstruction;
begin
  RegisterChildNode('GETMIMERS', TXMLGETMIMERSType);
  inherited;
end;

function TXMLGETMIMETRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLGETMIMETRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLGETMIMETRNRSType.GetGETMIMERS: IXMLGETMIMERSType;
begin
  Result := ChildNodes['GETMIMERS'] as IXMLGETMIMERSType;
end;

{ TXMLGETMIMETRNRSTypeList }

function TXMLGETMIMETRNRSTypeList.Add: IXMLGETMIMETRNRSType;
begin
  Result := AddItem(-1) as IXMLGETMIMETRNRSType;
end;

function TXMLGETMIMETRNRSTypeList.Insert(const Index: Integer): IXMLGETMIMETRNRSType;
begin
  Result := AddItem(Index) as IXMLGETMIMETRNRSType;
end;

function TXMLGETMIMETRNRSTypeList.GetItem(Index: Integer): IXMLGETMIMETRNRSType;
begin
  Result := List[Index] as IXMLGETMIMETRNRSType;
end;

{ TXMLGETMIMERSType }

function TXMLGETMIMERSType.GetURL: UnicodeString;
begin
  Result := ChildNodes['URL'].Text;
end;

procedure TXMLGETMIMERSType.SetURL(Value: UnicodeString);
begin
  ChildNodes['URL'].NodeValue := Value;
end;

{ TXMLEMAILMSGSETType }

procedure TXMLEMAILMSGSETType.AfterConstruction;
begin
  RegisterChildNode('EMAILMSGSETV1', TXMLEMAILMSGSETV1Type);
  inherited;
end;

function TXMLEMAILMSGSETType.GetEMAILMSGSETV1: IXMLEMAILMSGSETV1Type;
begin
  Result := ChildNodes['EMAILMSGSETV1'] as IXMLEMAILMSGSETV1Type;
end;

{ TXMLEMAILMSGSETV1Type }

procedure TXMLEMAILMSGSETV1Type.AfterConstruction;
begin
  RegisterChildNode('MSGSETCORE', TXMLMSGSETCOREType);
  inherited;
end;

function TXMLEMAILMSGSETV1Type.GetMSGSETCORE: IXMLMSGSETCOREType;
begin
  Result := ChildNodes['MSGSETCORE'] as IXMLMSGSETCOREType;
end;

function TXMLEMAILMSGSETV1Type.GetMAILSUP: UnicodeString;
begin
  Result := ChildNodes['MAILSUP'].Text;
end;

procedure TXMLEMAILMSGSETV1Type.SetMAILSUP(Value: UnicodeString);
begin
  ChildNodes['MAILSUP'].NodeValue := Value;
end;

function TXMLEMAILMSGSETV1Type.GetGETMIMESUP: UnicodeString;
begin
  Result := ChildNodes['GETMIMESUP'].Text;
end;

procedure TXMLEMAILMSGSETV1Type.SetGETMIMESUP(Value: UnicodeString);
begin
  ChildNodes['GETMIMESUP'].NodeValue := Value;
end;

{ TXMLPROFMSGSRQV1Type }

procedure TXMLPROFMSGSRQV1Type.AfterConstruction;
begin
  RegisterChildNode('PROFTRNRQ', TXMLPROFTRNRQType);
  ItemTag := 'PROFTRNRQ';
  ItemInterface := IXMLPROFTRNRQType;
  inherited;
end;

function TXMLPROFMSGSRQV1Type.GetPROFTRNRQ(Index: Integer): IXMLPROFTRNRQType;
begin
  Result := List[Index] as IXMLPROFTRNRQType;
end;

function TXMLPROFMSGSRQV1Type.Add: IXMLPROFTRNRQType;
begin
  Result := AddItem(-1) as IXMLPROFTRNRQType;
end;

function TXMLPROFMSGSRQV1Type.Insert(const Index: Integer): IXMLPROFTRNRQType;
begin
  Result := AddItem(Index) as IXMLPROFTRNRQType;
end;

{ TXMLPROFTRNRQType }

procedure TXMLPROFTRNRQType.AfterConstruction;
begin
  RegisterChildNode('PROFRQ', TXMLPROFRQType);
  inherited;
end;

function TXMLPROFTRNRQType.GetTRNRQMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRQMACRO'].Text;
end;

procedure TXMLPROFTRNRQType.SetTRNRQMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRQMACRO'].NodeValue := Value;
end;

function TXMLPROFTRNRQType.GetPROFRQ: IXMLPROFRQType;
begin
  Result := ChildNodes['PROFRQ'] as IXMLPROFRQType;
end;

{ TXMLPROFRQType }

function TXMLPROFRQType.GetCLIENTROUTING: UnicodeString;
begin
  Result := ChildNodes['CLIENTROUTING'].Text;
end;

procedure TXMLPROFRQType.SetCLIENTROUTING(Value: UnicodeString);
begin
  ChildNodes['CLIENTROUTING'].NodeValue := Value;
end;

function TXMLPROFRQType.GetDTPROFUP: UnicodeString;
begin
  Result := ChildNodes['DTPROFUP'].Text;
end;

procedure TXMLPROFRQType.SetDTPROFUP(Value: UnicodeString);
begin
  ChildNodes['DTPROFUP'].NodeValue := Value;
end;

{ TXMLPROFMSGSRSV1Type }

procedure TXMLPROFMSGSRSV1Type.AfterConstruction;
begin
  RegisterChildNode('PROFTRNRS', TXMLPROFTRNRSType);
  ItemTag := 'PROFTRNRS';
  ItemInterface := IXMLPROFTRNRSType;
  inherited;
end;

function TXMLPROFMSGSRSV1Type.GetPROFTRNRS(Index: Integer): IXMLPROFTRNRSType;
begin
  Result := List[Index] as IXMLPROFTRNRSType;
end;

function TXMLPROFMSGSRSV1Type.Add: IXMLPROFTRNRSType;
begin
  Result := AddItem(-1) as IXMLPROFTRNRSType;
end;

function TXMLPROFMSGSRSV1Type.Insert(const Index: Integer): IXMLPROFTRNRSType;
begin
  Result := AddItem(Index) as IXMLPROFTRNRSType;
end;

{ TXMLPROFTRNRSType }

procedure TXMLPROFTRNRSType.AfterConstruction;
begin
  RegisterChildNode('PROFRS', TXMLPROFRSType);
  inherited;
end;

function TXMLPROFTRNRSType.GetTRNRSMACRO: UnicodeString;
begin
  Result := ChildNodes['%TRNRSMACRO'].Text;
end;

procedure TXMLPROFTRNRSType.SetTRNRSMACRO(Value: UnicodeString);
begin
  ChildNodes['%TRNRSMACRO'].NodeValue := Value;
end;

function TXMLPROFTRNRSType.GetPROFRS: IXMLPROFRSType;
begin
  Result := ChildNodes['PROFRS'] as IXMLPROFRSType;
end;

{ TXMLPROFRSType }

procedure TXMLPROFRSType.AfterConstruction;
begin
  RegisterChildNode('MSGSETLIST', TXMLMSGSETLISTType);
  RegisterChildNode('SIGNONINFOLIST', TXMLSIGNONINFOLISTType);
  inherited;
end;

function TXMLPROFRSType.GetMSGSETLIST: IXMLMSGSETLISTType;
begin
  Result := ChildNodes['MSGSETLIST'] as IXMLMSGSETLISTType;
end;

function TXMLPROFRSType.GetSIGNONINFOLIST: IXMLSIGNONINFOLISTType;
begin
  Result := ChildNodes['SIGNONINFOLIST'] as IXMLSIGNONINFOLISTType;
end;

function TXMLPROFRSType.GetDTPROFUP: UnicodeString;
begin
  Result := ChildNodes['DTPROFUP'].Text;
end;

procedure TXMLPROFRSType.SetDTPROFUP(Value: UnicodeString);
begin
  ChildNodes['DTPROFUP'].NodeValue := Value;
end;

function TXMLPROFRSType.GetFINAME: UnicodeString;
begin
  Result := ChildNodes['FINAME'].Text;
end;

procedure TXMLPROFRSType.SetFINAME(Value: UnicodeString);
begin
  ChildNodes['FINAME'].NodeValue := Value;
end;

function TXMLPROFRSType.GetADDR1: UnicodeString;
begin
  Result := ChildNodes['ADDR1'].Text;
end;

procedure TXMLPROFRSType.SetADDR1(Value: UnicodeString);
begin
  ChildNodes['ADDR1'].NodeValue := Value;
end;

function TXMLPROFRSType.GetADDR2: UnicodeString;
begin
  Result := ChildNodes['ADDR2'].Text;
end;

procedure TXMLPROFRSType.SetADDR2(Value: UnicodeString);
begin
  ChildNodes['ADDR2'].NodeValue := Value;
end;

function TXMLPROFRSType.GetADDR3: UnicodeString;
begin
  Result := ChildNodes['ADDR3'].Text;
end;

procedure TXMLPROFRSType.SetADDR3(Value: UnicodeString);
begin
  ChildNodes['ADDR3'].NodeValue := Value;
end;

function TXMLPROFRSType.GetCITY: UnicodeString;
begin
  Result := ChildNodes['CITY'].Text;
end;

procedure TXMLPROFRSType.SetCITY(Value: UnicodeString);
begin
  ChildNodes['CITY'].NodeValue := Value;
end;

function TXMLPROFRSType.GetSTATE: UnicodeString;
begin
  Result := ChildNodes['STATE'].Text;
end;

procedure TXMLPROFRSType.SetSTATE(Value: UnicodeString);
begin
  ChildNodes['STATE'].NodeValue := Value;
end;

function TXMLPROFRSType.GetPOSTALCODE: UnicodeString;
begin
  Result := ChildNodes['POSTALCODE'].Text;
end;

procedure TXMLPROFRSType.SetPOSTALCODE(Value: UnicodeString);
begin
  ChildNodes['POSTALCODE'].NodeValue := Value;
end;

function TXMLPROFRSType.GetCOUNTRY: UnicodeString;
begin
  Result := ChildNodes['COUNTRY'].Text;
end;

procedure TXMLPROFRSType.SetCOUNTRY(Value: UnicodeString);
begin
  ChildNodes['COUNTRY'].NodeValue := Value;
end;

function TXMLPROFRSType.GetCSPHONE: UnicodeString;
begin
  Result := ChildNodes['CSPHONE'].Text;
end;

procedure TXMLPROFRSType.SetCSPHONE(Value: UnicodeString);
begin
  ChildNodes['CSPHONE'].NodeValue := Value;
end;

function TXMLPROFRSType.GetTSPHONE: UnicodeString;
begin
  Result := ChildNodes['TSPHONE'].Text;
end;

procedure TXMLPROFRSType.SetTSPHONE(Value: UnicodeString);
begin
  ChildNodes['TSPHONE'].NodeValue := Value;
end;

function TXMLPROFRSType.GetFAXPHONE: UnicodeString;
begin
  Result := ChildNodes['FAXPHONE'].Text;
end;

procedure TXMLPROFRSType.SetFAXPHONE(Value: UnicodeString);
begin
  ChildNodes['FAXPHONE'].NodeValue := Value;
end;

function TXMLPROFRSType.GetURL: UnicodeString;
begin
  Result := ChildNodes['URL'].Text;
end;

procedure TXMLPROFRSType.SetURL(Value: UnicodeString);
begin
  ChildNodes['URL'].NodeValue := Value;
end;

function TXMLPROFRSType.GetEMAIL: UnicodeString;
begin
  Result := ChildNodes['EMAIL'].Text;
end;

procedure TXMLPROFRSType.SetEMAIL(Value: UnicodeString);
begin
  ChildNodes['EMAIL'].NodeValue := Value;
end;

{ TXMLMSGSETLISTType }

procedure TXMLMSGSETLISTType.AfterConstruction;
begin
  ItemTag := '%MSGSETMACRO';
  ItemInterface := IXMLNode;
  inherited;
end;

function TXMLMSGSETLISTType.GetMSGSETMACRO(Index: Integer): UnicodeString;
begin
  Result := List[Index].Text;
end;

function TXMLMSGSETLISTType.Add(const MSGSETMACRO: UnicodeString): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := MSGSETMACRO;
end;

function TXMLMSGSETLISTType.Insert(const Index: Integer; const MSGSETMACRO: UnicodeString): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := MSGSETMACRO;
end;

{ TXMLSIGNONINFOLISTType }

procedure TXMLSIGNONINFOLISTType.AfterConstruction;
begin
  RegisterChildNode('SIGNONINFO', TXMLSIGNONINFOType);
  ItemTag := 'SIGNONINFO';
  ItemInterface := IXMLSIGNONINFOType;
  inherited;
end;

function TXMLSIGNONINFOLISTType.GetSIGNONINFO(Index: Integer): IXMLSIGNONINFOType;
begin
  Result := List[Index] as IXMLSIGNONINFOType;
end;

function TXMLSIGNONINFOLISTType.Add: IXMLSIGNONINFOType;
begin
  Result := AddItem(-1) as IXMLSIGNONINFOType;
end;

function TXMLSIGNONINFOLISTType.Insert(const Index: Integer): IXMLSIGNONINFOType;
begin
  Result := AddItem(Index) as IXMLSIGNONINFOType;
end;

{ TXMLSIGNONINFOType }

function TXMLSIGNONINFOType.GetSIGNONREALM: UnicodeString;
begin
  Result := ChildNodes['SIGNONREALM'].Text;
end;

procedure TXMLSIGNONINFOType.SetSIGNONREALM(Value: UnicodeString);
begin
  ChildNodes['SIGNONREALM'].NodeValue := Value;
end;

function TXMLSIGNONINFOType.GetMIN: UnicodeString;
begin
  Result := ChildNodes['MIN'].Text;
end;

procedure TXMLSIGNONINFOType.SetMIN(Value: UnicodeString);
begin
  ChildNodes['MIN'].NodeValue := Value;
end;

function TXMLSIGNONINFOType.GetMAX: UnicodeString;
begin
  Result := ChildNodes['MAX'].Text;
end;

procedure TXMLSIGNONINFOType.SetMAX(Value: UnicodeString);
begin
  ChildNodes['MAX'].NodeValue := Value;
end;

function TXMLSIGNONINFOType.GetCHARTYPE: UnicodeString;
begin
  Result := ChildNodes['CHARTYPE'].Text;
end;

procedure TXMLSIGNONINFOType.SetCHARTYPE(Value: UnicodeString);
begin
  ChildNodes['CHARTYPE'].NodeValue := Value;
end;

function TXMLSIGNONINFOType.GetCASESEN: UnicodeString;
begin
  Result := ChildNodes['CASESEN'].Text;
end;

procedure TXMLSIGNONINFOType.SetCASESEN(Value: UnicodeString);
begin
  ChildNodes['CASESEN'].NodeValue := Value;
end;

function TXMLSIGNONINFOType.GetSPECIAL: UnicodeString;
begin
  Result := ChildNodes['SPECIAL'].Text;
end;

procedure TXMLSIGNONINFOType.SetSPECIAL(Value: UnicodeString);
begin
  ChildNodes['SPECIAL'].NodeValue := Value;
end;

function TXMLSIGNONINFOType.GetSPACES: UnicodeString;
begin
  Result := ChildNodes['SPACES'].Text;
end;

procedure TXMLSIGNONINFOType.SetSPACES(Value: UnicodeString);
begin
  ChildNodes['SPACES'].NodeValue := Value;
end;

function TXMLSIGNONINFOType.GetPINCH: UnicodeString;
begin
  Result := ChildNodes['PINCH'].Text;
end;

procedure TXMLSIGNONINFOType.SetPINCH(Value: UnicodeString);
begin
  ChildNodes['PINCH'].NodeValue := Value;
end;

function TXMLSIGNONINFOType.GetCHGPINFIRST: UnicodeString;
begin
  Result := ChildNodes['CHGPINFIRST'].Text;
end;

procedure TXMLSIGNONINFOType.SetCHGPINFIRST(Value: UnicodeString);
begin
  ChildNodes['CHGPINFIRST'].NodeValue := Value;
end;

{ TXMLPROFMSGSETType }

procedure TXMLPROFMSGSETType.AfterConstruction;
begin
  RegisterChildNode('PROFMSGSETV1', TXMLPROFMSGSETV1Type);
  inherited;
end;

function TXMLPROFMSGSETType.GetPROFMSGSETV1: IXMLPROFMSGSETV1Type;
begin
  Result := ChildNodes['PROFMSGSETV1'] as IXMLPROFMSGSETV1Type;
end;

{ TXMLPROFMSGSETV1Type }

procedure TXMLPROFMSGSETV1Type.AfterConstruction;
begin
  RegisterChildNode('MSGSETCORE', TXMLMSGSETCOREType);
  inherited;
end;

function TXMLPROFMSGSETV1Type.GetMSGSETCORE: IXMLMSGSETCOREType;
begin
  Result := ChildNodes['MSGSETCORE'] as IXMLMSGSETCOREType;
end;

{ TXMLOFXType }

{ TXMLString_List }

function TXMLString_List.Add(const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := Value;
end;

function TXMLString_List.Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := Value;
end;

function TXMLString_List.GetItem(Index: Integer): UnicodeString;
begin
  Result := List[Index].NodeValue;
end;

end.