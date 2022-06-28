CREATE TEMP FUNCTION NormalizeCaseV1(content STRING)
  RETURNS STRING
  AS (UPPER(IFNULL(TRIM(content), "-")));

CREATE TEMP FUNCTION NormalizeNamaFungsi(content STRING)
  RETURNS STRING
  LANGUAGE js AS r"""
    if (!content || content.length < 5) {
        return "LAINNYA";
    }

    content = content.replace(" LAINNYA", "").toUpperCase().trim();
    if (content.includes("DAN PENCATATAN SIPIL")) {
      return "ADMINISTRASI KEPENDUDUKAN DAN PENCATATAN SIPIL";
    } else if (content.includes("INFORMATIKA")) {
      return "KOMUNIKASI DAN INFORMATIKA";
    } else if (content.includes("KETENTERAMAN")) {
      return "KETENTERAMAN, KETERTIBAN UMUM DAN PERLINDUNGAN MASYARAKAT";
    } else if (content.includes("PEMBERDAYAAN PEREMPUAN")) {
      return "PEMBERDAYAAN PEREMPUAN DAN PERLINDUNGAN ANAK";
    } else if (content.includes("KEPEMUDAAN DAN OLAHRAGA")) {
      return "KEPEMUDAAN DAN OLAHRAGA";
    } else if (content.includes("PERUMAHAN DAN FASILITAS")) {
      return "PERUMAHAN DAN FASILITAS UMUM";
    } else if (content.includes("PERTAHANAN")) {
      return "PERTAHANAN";
    } else if (content.includes("PENDIDIKAN DAN PELATIHAN")) {
      return "PENDIDIKAN";
    } else if (content.includes("|")) {
      return content.split("|")[0].trim();
    } else if (content.includes("{\"")) {
      return "LAINNYA";
    }

    return content;
  """;

CREATE TEMP FUNCTION NormalizeNamaSubFungsi(content STRING)
  RETURNS STRING
  LANGUAGE js AS r"""
    if (!content || content.length < 5) {
        return "LAINNYA";
    }

    content = content.replace(/\s+/g, ' ');
    content = content.replace(" LAINNYA", "");
    content = content.replace("URUSAN PEMERINTAHAN BIDANG", "").toUpperCase().trim();
    if (content.includes("ADMINISTRASI KEPENDUDUKAN DAN PE")) {
      return "ADMINISTRASI KEPENDUDUKAN DAN PENCATATAN SIPIL";
    } else if (content.includes("KETENTERAMAN, KETERTIBAN") || content.includes("KETENTRAMAN, KETERTIBAN")) {
      return "KETENTERAMAN, KETERTIBAN UMUM DAN PERLINDUNGAN MASYARAKAT";
    } else if (content.includes("SERTA URUSAN LUAR NEGERI") || content.includes("LEMBAGA   EKSEKUTIF   DAN   L")) {
      return "LEMBAGA EKSEKUTIF DAN LEGISLATIF, KEUANGAN DAN FISKAL, SERTA URUSAN LUAR NEGERI";
    } else if (content.includes("ILMU PENGETAHUAN DAN TEKNOLOGI")) {
      return "PENELITIAN DASAR DAN PENGEMBANGAN ILMU PENGETAHUAN DAN TEKNOLOGI (IPTEK)";
    } else if (content.includes("PENGENDALIAN PENDUDUK")) {
      return "PENGENDALIAN PENDUDUK DAN KELUARGA BERENCANA";
    } else if (content.includes("INFORMATIKA")) {
      return "KOMUNIKASI DAN INFORMATIKA";
    } else if (content.includes("MANULA")) {
      return "PERLINDUNGAN DAN PELAYANAN MANUSIA USIA LANJUT (MANULA)";
    } else if (content.includes("ANAK-ANAK") && content.includes("DAN KELUARGA")) {
      return "PERLINDUNGAN DAN PELAYANAN SOSIAL ANAK-ANAK DAN KELUARGA";
    } else if (content.includes("PERTANIAN KEHUTANAN")) {
      return "PERTANIAN, KEHUTANAN, PERIKANAN, DAN KELAUTAN";
    } else if (content.includes("KOPERASI") && content.includes("USAHA KECIL") && content.includes("MENENGAH")) {
      return "KOPERASI, USAHA KECIL, DAN MENENGAH";
    } else if (content.includes("PERTANIAN KEHUTANAN")) {
      return "PERTANIAN, KEHUTANAN, PERIKANAN, DAN KELAUTAN";
    } else if (content.includes("|")) {
      const stage1 = content.split("|")[0].trim();
      if (stage1.length < 5) {
        return "LAINNYA";
      }

      return stage1;
    }

    return content;
  """;

CREATE TEMP FUNCTION RemovePrefixFromPemda(content STRING)
  RETURNS STRING
  LANGUAGE js AS r"""
    return content.replace("Kab.", "").replace("Provinsi", "").replace("Kota", "").trim().toUpperCase()
  """;

CREATE TEMP FUNCTION GetPrefixFromPemda(content STRING)
  RETURNS STRING
  LANGUAGE js AS r"""
    if (content.includes("Provinsi")) {
      return "PROVINSI";
    } else if (content.includes("Kota")) {
      return "KOTA";
    } else {
      return "KABUPATEN";
    }
  """;

CREATE TEMP FUNCTION NormalizeNamaAkunKelompok(content STRING)
  RETURNS STRING
  LANGUAGE js AS r"""
    if (!content || content.length < 5) {
        return "LAINNYA";
    }

    content = content.toUpperCase();
    if (content.includes("PENGELUARAN")) {
      return "PENGELUARAN PEMBIAYAAN";
    } else if (content.includes("MODAL")) {
      return "BELANJA MODAL";
    } else if (content.includes("OPERASI")) {
      return "BELANJA OPERASI";
    } else if (content.includes("TIDAK")) {
      return "BELANJA TIDAK TERDUGA";
    } else if (content.includes("BELANJA TRANSFER")) {
      return "BELANJA TRANSFER";
    } else if (content.includes("ASLI DAERAH")) {
      return "PENDAPATAN ASLI DAERAH";
    } else if (content.includes("PENDAPATAN TRANSFER")) {
      return "PENDAPATAN TRANSFER";
    } else if (content.includes("PENERIMAAN")) {
      return "PENERIMAAN PEMBIAYAAN";
    }

    return "LAINNYA";
  """;

CREATE TEMP FUNCTION NormalizeNamaAkunUtama(content STRING)
  RETURNS STRING
  LANGUAGE js AS r"""
    if (!content || content.length < 5) {
        return "LAINNYA";
    }

    content = content.toUpperCase();
    if (content.includes("BELANJA")) {
      return "BELANJA DAERAH";
    } else if (content.includes("PEMBIAYAAN")) {
      return "PEMBIAYAAN DAERAH";
    } else if (content.includes("PENDAPATAN")) {
      return "PENDAPATAN DAERAH";
    }

    return "LAINNYA";
  """;

CREATE TEMP FUNCTION NormalizeNamaSubKegiatan(content STRING)
  RETURNS STRING
  LANGUAGE js AS r"""
    if (!content || content.length < 5) {
        return "LAINNYA";
    }

    content = content.toUpperCase();
    if (
        content.includes("OPERASIONAL PELAYANAN PUSKESMAS") ||
        content.includes("PELAYANAN KESEHATAN PENYAKIT") ||
        content.includes("PENGELOLAAN PELAYANAN KESEHATAN") ||
        content.includes("OPERASIONAL PELAYANAN FASILITAS KESEHATAN") ||
        content.includes("PENGEMBANGAN PUSKESMAS") ||
        content.includes("PENGADAAN ALAT KESEHATAN") ||
        content.includes("OPERASIONAL PELAYANAN RUMAH SAKIT") ||
        content.includes("PENGADAAN BAHAN HABIS PAKAI") ||
        content.includes("PENGADAAN PRASARANA") ||
        content.includes("PENGADAAN SARANA") ||
        content.includes("PEMBANGUNAN PUSKESMAS") ||
        content.includes("PEMBANGUNAN RUMAH SAKIT") ||
        content.includes("REHABILITASI DAN PEMELIHARAAN PUSKESMAS")
        ) {
        return "PENINGKATAN LAYANAN KESEHATAN DASAR DAN RUJUKAN";
    } else if (
        content.includes("PEMENUHAN KEBUTUHAN SUMBER DAYA MANUSIA KESEHATAN") ||
        content.includes("BIMBINGAN TEKNIS") ||
        content.includes("PENGEMBANGAN MUTU DAN PENINGKATAN KOMPETENSI")
        ) {
        return "PENINGKATAN KOMPETENSI NAKES";
    } else if (content.includes("PENGADAAN OBAT")) {
        return "DAYA SAING FARMASI DAN ALAT KESEHATAN";
    } else if (content.includes("PENGELOLAAN SURVEILANS KESEHATAN")) {
        return "PENGAWASAN OBAT DAN MAKANAN";
    } else if (
        content.includes("PENGELOLAAN JAMINAN KESEHATAN MASYARAKAT") ||
        content.includes("PENGELOLAAN DATA DAN INFORMASI KESEHATAN") ||
        content.includes("PENGELOLAAN SISTEM INFORMASI KESEHATAN")
        ) {
        return "PENGUATAN TATA KELOLA KESEHATAN";
    } else if (content.includes("GAJI DAN TUNJANGAN")) {
        return "GAJI DAN TUNJANGAN";
    } else if (
        content.includes("PENGELOLAAN DANA BOS SEKOLAH DASAR") ||
        content.includes("PENYELENGGARAAN PROSES BELAJAR DAN UJIAN") ||
        content.includes("PEMBINAAN MINAT, BAKAT DAN KREATIVITAS SISWA") ||
        content.includes("PENGELOLAAN DANA BOS SEKOLAH MENENGAH PERTAMA") ||
        content.includes("PEMBANGUNAN SARANA, PRASARANA DAN UTILITAS SEKOLAH") ||
        content.includes("PENGELOLAAN DANA BOP PAUD") ||
        content.includes("PENGADAAN ALAT PRAKTIK DAN PERAGA SISWA") ||
        content.includes("PENYELENGGARAAN PROSES BELAJAR PAUD") ||
        content.includes("PENGADAAN MEBEL SEKOLAH") ||
        content.includes("REHABILITASI") ||
        content.includes("PENGADAAN SARANA DAN PRASARANA GEDUNG")
        ) {
        return "PENINGKATAN KUALITAS PENGAJARAN DAN PEMBELAJARAN";
    } else if (
        content.includes("PENAMBAHAN RUANG KELAS BARU") ||
        content.includes("PEMBANGUNAN UNIT SEKOLAH BARU")
        ) {
        return "PEMERATAAN AKSES LAYANAN PENDIDIKAN";
    } else if (
        content.includes("PENYEDIAAN BIAYA PERSONIL PESERTA DIDIK SEKOLAH DASAR") ||
        content.includes("PENGEMBANGAN KARIR PENDIDIK DAN TENAGA PENDIDIK")
        ) {
        return "PROFESIONALISME DAN KUALITAS NADIK";
    //} else if (content.includes("GAJI DAN TUNJANGAN")) {
    //    return "JAMINAN MUTU KUALITAS PENDIDIKAN";
    } else if (content.includes("PEMBINAAN KELEMBAGAAN DAN MANAJEMEN")) {
        return "TATA KELOLA PENDIDIKAN";
    } 

    return "LAINNYA";
  """;

CREATE OR REPLACE TABLE dataset_L2.L2_apbd_full AS 
SELECT
  NormalizeCaseV1(kodepemda) AS kode_pemda,
  NormalizeCaseV1(namapemda) AS nama_pemda,
  RemovePrefixFromPemda(namapemda) AS pemda,
  GetPrefixFromPemda(namapemda) AS jenis_pemda,
  CAST(tahun AS NUMERIC) AS tahun_num,
  kodefungsi AS kode_fungsi,
  NormalizeNamaFungsi(namafungsi) AS nama_fungsi,
  kodesubfungsi AS kode_sub_fungsi,
  NormalizeNamaSubFungsi(namasubfungsi) AS nama_sub_fungsi,
  kodeskpd,
  namaskpd,
  kodeprogram,
  namaprogram,
  namaoutcome,
  targetoutcome,
  satuanoutcome
  kodekegiatan,
  namakegiatan,
  kodesubkegiatan,
  namasubkegiatan,
  NormalizeNamaSubKegiatan(namasubkegiatan) AS kategori_sub_kegiatan,
  namaoutput,
  targetoutput,
  satuanoutput,
  kodeakunutama,
  NormalizeNamaAkunUtama(namaakunutama) AS nama_akun_utama,
  kodeakunkelompok,
  NormalizeNamaAkunKelompok(namaakunkelompok) AS nama_akun_kelompok,
  CAST(nilaianggaran AS NUMERIC) AS nilai_anggaran
FROM `lomba-bedah-data-apbd-2022.dataset_mentah.L1_apbd_full`

