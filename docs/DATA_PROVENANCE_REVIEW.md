# Data Provenance Review

Repository: `InclusiveCreditRiskAnalytics-Bolivia`

Scope: conservative public-data review of `data/raw/*.xlsx` files. No raw files were deleted, moved, transformed or recalculated; they were removed only from Git tracking so local copies remain on the machine.

## Summary

The raw Excel files appear to be project input workbooks and rebuilt preliminary-report workbooks used by the credit-risk analytics pipeline. The public README states that the raw files include officer-level names and that public outputs exclude personal names. Because officer-level names can be personally identifying in a branch-level operational dataset, these files have been removed from public Git tracking and must remain local unless explicit authorization for redistribution is documented.

## File-level review

| file | size | SHA256 | inferred origin | public data? | sensitive data? | can remain on GitHub? | move to sample? | .gitignore recommendation | manual review |
|---|---:|---|---|---|---|---|---|---|---|
| `data/raw/datos micro 2.crec-1.xlsx` | 340,475 bytes | `25C240FF8C6EA8C338C38BF0E7E0BF734A6C545DE4C13A78B497A459633233E3` | Original operational Excel workbook used as a raw input for the pipeline. | Not confirmed as public. Treat as non-public until provenance is documented. | Yes, potentially. README indicates officer-level names exist in raw files. | Only if explicit permission/public provenance is documented. Current status: requires review. | Yes. Prefer a sanitized/sample workbook for public GitHub. | Add future raw operational workbooks to `.gitignore` after a sample/public replacement is prepared. | Required. Confirm authorization, source owner, data classification and whether names or personal identifiers remain. |
| `data/raw/datos micro 2.crec.MODIFICADO.xlsx` | 343,729 bytes | `032D39FD4B0D3A8E4CEBEFFC2012D311BFE62487C3533BFCC49A115921E45F11` | Modified operational Excel workbook used as a raw input or intermediate raw source. | Not confirmed as public. Treat as non-public until provenance is documented. | Yes, potentially. Modification status does not remove officer-level disclosure risk. | Only if explicit permission/public provenance is documented. Current status: requires review. | Yes. Prefer a sanitized/sample workbook for public GitHub. | Add future modified raw operational workbooks to `.gitignore` after a sample/public replacement is prepared. | Required. Compare against original workbook and confirm no personal names or confidential operational fields remain. |
| `data/raw/rebuilt.Copia de Informe_preliminarA.xlsx` | 173,843 bytes | `B2BB5CDE98351F08C9A561286A004CF58B98E167951F3C49EBC2B19FAD9BF815` | Rebuilt preliminary-report workbook derived from project material. | Not confirmed as public. | Potentially. Derived reports may still contain officer-level names, branch-sensitive fields or internal operational summaries. | Only after manual confirmation that it contains no personal or confidential information. | Yes, if it is needed for reproducibility; otherwise replace with documentation/sample. | Add future preliminary/internal reports to `.gitignore` unless explicitly public. | Required. Confirm whether workbook contains personal names, internal notes or non-public projections. |
| `data/raw/rebuilt.Copia de Informe_preliminarBa.xlsx` | 195,533 bytes | `A12B5E8BD352A802A71751D3D22767F9AB45BE485781E6B9A45412FCB8B6B768` | Rebuilt preliminary-report workbook derived from project material. | Not confirmed as public. | Potentially. Derived reports may still contain officer-level names, branch-sensitive fields or internal operational summaries. | Only after manual confirmation that it contains no personal or confidential information. | Yes, if it is needed for reproducibility; otherwise replace with documentation/sample. | Add future preliminary/internal reports to `.gitignore` unless explicitly public. | Required. Confirm whether workbook contains personal names, internal notes or non-public projections. |

## Decision

- Keep the existing files locally; do not delete, move, transform or recalculate them.
- Remove the four Excel workbooks from public Git tracking.
- Ignore future raw workbook files with `.gitignore`, while keeping `data/raw/README.md` and `data/raw/.gitkeep` visible.
- Treat the files as requiring manual review because current public documentation says raw files include officer-level names.
- Future public versions should prefer sanitized sample files under a clearly named sample directory, with original operational workbooks kept outside Git.

## Manual review checklist

- Confirm the source owner and authorization for public GitHub storage.
- Confirm whether officer names, staff identifiers, client identifiers, account IDs, phone numbers, emails, addresses or free-text notes are present.
- Confirm whether projections or internal financial information are public, confidential or restricted.
- Confirm whether a sanitized sample can reproduce the public pipeline without exposing operational records.
- Record the final decision in this file before repository renaming, release creation or DOI archiving.