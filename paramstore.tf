provider "aws" {
  region = "eu-west-2"
}

resource "aws_ssm_parameter" "app_id" {
  name  = "APP_ID"
  value = "325931"
  type  = "String"
}

resource "aws_ssm_parameter" "private_key" {
  name  = "PRIVATE_KEY"
  value = "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBMDRGNVJlN2VrV3VHOEdsa3VDM3lNYVFXNGFlRjVjeFJnVDRjUWJUSlFEOTdVVEo1CnYzVUI5TStMRW5NT0VySTlocEVKK1owd2VNUUVWbGN1U01zWkQ3RWd5bEsrMFRRWHNKb0pnZHovMnRTT0tpOHYKWmJjSmhzUGxpb0ZWbUhsMjFrN2pVaEJSUmJEWnlmQnVWMGtCR1Q0RHJuR2JuVzZyT2pNZ3ZOeG4vaCtEN0J3UwpvaXJNZW1KTW9wQk9LWXlPZEd2bHlNV2VxWUxhY0x4TkdXb1pYNHJsNEVTSUkyc1U1NmU1MW1HTExMTzFMMWk5CkFFNjI2N0VzcGVWc2VFWHVwdGt2VXZKc0JMZ1RGUjQ3V1pEeXNUSWZJa1h6ZGxKYWRoMi95dFl2UGN5NWlhVFcKcGhsVGw3K0QzR00wOWxVT3ZVL2M2Vzlhc25BWWcwVnVzNXlpQndJREFRQUJBb0lCQVFDckxLNHBteGttT0JBTgpvajZSa1IzaWJ4clZwZThIL0VRNmhUbjVNNGR0Si9OMTA1UVZEMjExNUVKNXZBUTN2V2x0N3hSVG9KUUtLUm9aCmhwVSs5S0Jqd3NiMjkrRFhENEhjdTgzVi9EWlZ0SkVhTXZYNUxCblpwOUd1TnQ0L2VJNWxBNU9XWnY1Zm1MR3EKYlp2ZnFJWHJGL1dDeVE5WWFxakpnWGVOWWhRSDVhRUFnL1F1MHVFUFVxYlR2YjY5REdDQXpoOWt5VnZaRFpQdQozM2dDd0dkTHJ3TGtxWk9mZ2ZjRnJCZzNYNXV2ZElrVVBySGE5MzRBMU5sMUNEUHJ5S053a2pvbkYwYm1wV2x0ClZaQWJ1WW9ncHVldTdnRUN3NHlteURVSHZpUWRhVnRZUzl2dHVjb0hONFcvcllrZlBDZ1poK2hycm44M1pPancKMFQ5ekJxeUJBb0dCQU92ZFhUUzBKK0pMM0svZU9oWVYwTUp0d3VMRUpoSUM5MWZIZHhDTUl1VGk4SEE3VWh4agpDWGxBMHpYK2Erajk1V2N5V042bXlOaGVJY0ZmcCtxa0x3TEViYXBGalJwSGZTRXNBQldsNW52cXVvWjFnMVkrCnJoc3cxWVFTdVpEbWU5cVlYTzZsMnlGTkhZTFMydndKenZlaWZCRG4rcGhQclhKSzJ5QW55RldqQW9HQkFPV1AKdzZIVjRoaEdOa1hidHJ6dHd6anRMc09hUGhhM2ZTbEFpWXdWSnk5OGF5Q3Q3QXhwamIvQmlPd1Vpd3h5MXYxbQpoemJOZUNoRExkV2tja2tnVTdOM1NDMGdKNHlZTGlBVDU3ZFhhYml0RGlUMnlwR05mbFVuRUZmQWc1US9BSmVVCk1MZnJ3RFNhZWNqY0wzTGJxYzlWNTNyVFBnZ1hYbnk1R1lkSko2Qk5Bb0dCQUpPTDNiT0xnMnV2c3pVZEdrOFkKaElnc0szNjUzMnJqQ2lHU09LeFVUYnZMTDBlMkJDNlgwYVJWWmdyZnhsZHhCS0dpd0M5QVBHSUZ1SzRFRGNIZAp4VDdBN0MxWTV1VHFsWjg3ckMzZW95a2ZkR0dLZjRkakhIMEw5blZ4VlQ0TXdLdkZKbFZ2MFgycWhPeUN4TlJuCnVsMzAraEdGWEtFTkx0NVJiM1JWRHFCckFvR0FKOXV0V1FVYzY2QU5QbFhteGFqMnM0U2pFUDFQK0h2RmRJc3IKRnJKNWlrb3RBNUNQSXB5Vkt3MDhhOWtwUjNFTkdSUmJOODIzSmk1NzM5TmNzSXUzWExyQ1FtdUowbVI5NWIzdgpCcXRieE4vdlM4VzU2RW5ML0piNnhIRzlwdGpGam93QlpYMitjcU83cjM5amthcklNaUsxUFdNK0t3Tjd1V1llCkk1bzFFaVVDZ1lCbyt2S2NoU2djcmVIbzY5WDgvUUpCL21tbHpTc2IxUVV0VTRCRWR4RjJJU3VnVThWVHZqbDMKNVAwU1hWbXl2RmNLaXRaT3QrR1BTeDB1TldJWnlMMjhRUVk1aGRaVkc1d3ozMWpKSlVlNlRmVHJ5LzBubElUZAptUTQwWDFRU0Qva0ZkRXg1d0NsVjF0QStDZDhoS0FNTHRvMVJ6MHVzZ2oyRGgzS2dkUlRvR2c9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo"
  type  = "SecureString"
}

resource "aws_ssm_parameter" "webhook_secret" {
  name  = "WEBHOOK_SECRET"
  value = "development"
  type  = "String"
}