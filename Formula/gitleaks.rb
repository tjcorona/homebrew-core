class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v5.0.0.tar.gz"
  sha256 "1bb629e7837724c23f1f285f12391d123806365a534cb8eeb2cefe5d3c25fcb2"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f500917e62e60b2ec001467daacff9232e23241ac9335b3f556ec66fd90ab9f" => :catalina
    sha256 "dad6fc77febe76a109f5b33c5a9a43674f541d86596ea1664f0683bbb0f362d4" => :mojave
    sha256 "cc865ad2c38c9cea880c3c43c4ca21400b8904b25da2b5efa8a5e8fa4bf0d64d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X github.com/zricethezav/gitleaks/version.Version=#{version}",
                 *std_go_args
  end

  test do
    assert_match "remote repository is empty",
      shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git", 2)
  end
end
