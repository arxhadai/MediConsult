/// Verification status for user accounts
enum VerificationStatus {
  pending('pending', 'Pending Verification'),
  inReview('in_review', 'Under Review'),
  verified('verified', 'Verified'),
  rejected('rejected', 'Verification Rejected');

  final String value;
  final String displayName;

  const VerificationStatus(this.value, this.displayName);

  static VerificationStatus fromString(String value) {
    return VerificationStatus.values.firstWhere(
      (status) => status.value == value.toLowerCase(),
      orElse: () => VerificationStatus.pending,
    );
  }

  bool get isVerified => this == VerificationStatus.verified;
  bool get isPending => this == VerificationStatus.pending;
  bool get isRejected => this == VerificationStatus.rejected;
}
