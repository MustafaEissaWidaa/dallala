import type { Metadata } from "next";
import localFont from "next/font/local";
import "./globals.css";
import { cn } from "@/lib/utils";

// Bundled fonts (same files as the app) — nothing is loaded from the network.
const plex = localFont({
  variable: "--font-plex",
  src: [
    { path: "./fonts/IBMPlexSansArabic-Regular.ttf", weight: "400" },
    { path: "./fonts/IBMPlexSansArabic-Medium.ttf", weight: "500" },
    { path: "./fonts/IBMPlexSansArabic-SemiBold.ttf", weight: "600" },
    { path: "./fonts/IBMPlexSansArabic-Bold.ttf", weight: "700" },
  ],
});

const readex = localFont({
  variable: "--font-readex",
  src: [
    { path: "./fonts/ReadexPro-SemiBold.ttf", weight: "600" },
    { path: "./fonts/ReadexPro-Bold.ttf", weight: "700" },
  ],
});

export const metadata: Metadata = {
  title: "دلّالة — لوحة الإدارة",
  description: "لوحة إدارة دلّالة",
  robots: { index: false, follow: false },
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html
      lang="ar"
      dir="rtl"
      className={cn("h-full antialiased", plex.variable, readex.variable)}
    >
      <body className="min-h-full">{children}</body>
    </html>
  );
}
