export interface Extension {
    publisher: string;
    id: string;
    version: string;
}

export type ExtensionUrl = string;
export type ExtensionRegistry = "official" | "openvsx";

export interface ExtensionConfiguration {
    registry: ExtensionRegistry;
    extensions: Extension[];
}

export interface OpenVSXAPIResponse {
    namespaceUrl?: string;
    reviewsUrl?: string;
    files?: {
        download?: string;
        manifest?: string;
        readme?: string;
        changelog?: string;
        license?: string;
        icon?: string;
    };
    name?: string;
    namespace?: string;
    version?: string;
    publishedBy?: {
        loginName?: string;
        fullName?: string;
        avatarUrl?: string;
        homepage?: string;
        provider?: string;
    };
    verified?: boolean;
    unrelatedPublisher?: boolean;
    namespaceAccess?: string;
    allVersions?: {
        [key: string]: string;
    };
    averageRating?: number;
    downloadCount?: number;
    reviewCount?: number;
    versionAlias?: string[];
    timestamp?: string;
    preview?: boolean;
    displayName?: string;
    description?: string;
    engines?: {
        [key: string]: string;
    };
    categories?: string[];
    extensionKind?: string[];
    tags?: string[];
    license?: string;
    homepage?: string;
    repository?: string;
    bugs?: string;
    galleryColor?: string;
    galleryTheme?: string;
    dependencies?: {
        extension?: string;
        namespace?: string;
        url?: string;
    }[];
    bundledExtensions: {
        extension?: string;
        namespace?: string;
        url?: string;
    }[];
}
