# Wine Note — iPhone対応PWA / Supabaseクラウド同期

同梱の **README.html** をブラウザで開き、SupabaseとGitHub Pagesの設定手順を確認してください。

- フロントエンド: 静的HTML/CSS/JavaScript（フレームワーク・ビルド不要）
- バックエンド: Supabase Auth + PostgreSQL RLS + Private Storage
- 写真: ブラウザ内JPEG圧縮 → 非公開Storage → 期限付き署名付きURL
- ラベルOCR: Tesseract.jsをオンデマンド利用。英字中心で候補入力のみ
- 同期: 保存/再読込/フォーカス復帰。オフライン時の編集同期は非対応
- おすすめ: 固定サンプル40件、市場価格はWeb検索リンク + 手入力
- バックアップ: JSON（写真バイナリなし）

**セットアップ**: 1. Supabaseプロジェクト作成 2. SQL Editorで`schema.sql`を実行 3. GitHub Pagesなどに静的ファイルを公開 4. Supabase認証のSite URL/Redirect URLを登録 5. アプリでProject URLとpublishable/anon keyを入力 6. 同じアカウントでiPhoneとPCにログイン。

**注意**: GitHub Pagesへの公開やSupabaseプロジェクトの作成は、このZIPでは自動実行されません。公開用キーはフロントエンドに渡して構いませんが、`service_role`または`secret`キーは絶対に入力しないでください。外部APIのアクセス状況・無料枠は契約時点で確認してください。
