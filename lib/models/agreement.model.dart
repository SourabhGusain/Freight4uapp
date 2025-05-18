import 'dart:io';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class AgreementModel {
  int? policyId;
  int? driverId;
  File? signatureFile;
  String? date;
  String status;
  String? remark;
  bool isActive;
  String? createdOn;
  int? createdBy;

  AgreementModel({
    this.policyId,
    this.driverId,
    this.signatureFile,
    this.date,
    this.status = 'pending',
    this.remark,
    this.isActive = true,
    this.createdOn,
    this.createdBy,
  });

  Map<String, dynamic> toMultipartMap() {
    final Map<String, dynamic> map = {};

    if (policyId != null) map['policy_id'] = policyId.toString();
    if (driverId != null) map['driver'] = driverId.toString();
    if (date != null) map['date'] = date!;
    if (status.isNotEmpty) map['status'] = status;
    if (remark != null && remark!.isNotEmpty) map['remark'] = remark!;
    if (signatureFile != null) map['signature'] = signatureFile!;
    map['is_active'] = isActive.toString();
    if (createdOn != null) map['created_on'] = createdOn!;
    if (createdBy != null) map['created_by'] = createdBy.toString();

    return map;
  }
}

class AgreementService {
  final Api api = Api();

  Future<Map<String, dynamic>> createAgreement(AgreementModel agreement) async {
    String endpoint = "$api_url/policies/agreements/";
    print(endpoint);

    Map<String, dynamic> requestBody = agreement.toMultipartMap();

    return await api.multipartOrJsonPostCall(
      endpoint,
      requestBody,
      isMultipart: true,
    );
  }
}
