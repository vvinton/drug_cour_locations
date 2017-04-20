PROGRAM_MAPPING = {
    program_information: {
        properties: {
            contact_name: {
                type: "string",
                index: "not_analyzed",
                fields: {
                    analyzed: {
                        type: "string"
                    }
                },
                include_in_all: true,
                ignore_above: 30000
            },
            county: {
                type: "string",
                index: "not_analyzed",
                fields: {
                    analyzed: {
                        type: "string"
                    }
                },
                include_in_all: true,
                ignore_above: 30000
            },
            email: {
                type: "string",
                index: "not_analyzed",
                fields: {
                    analyzed: {
                        type: "string"
                    }
                },
                include_in_all: true,
                ignore_above: 30000
            },
            lat: {
                type: "double"
            },
            coordinates: {
                type: "geo_point"
            },
            long: {
                type: "double"
            },
            phone_number: {
                type: "string",
                index: "not_analyzed",
                fields: {
                    analyzed: {
                        type: "string"
                    }
                },
                include_in_all: true,
                ignore_above: 30000
            },
            program_name: {
                type: "string",
                index: "not_analyzed",
                fields: {
                    analyzed: {
                        type: "string"
                    }
                },
                include_in_all: true,
                ignore_above: 30000
            },
            program_type: {
                type: "string",
                index: "not_analyzed",
                fields: {
                    analyzed: {
                        type: "string"
                    }
                },
                include_in_all: true,
                ignore_above: 30000
            },
            state: {
                type: "string",
                index: "not_analyzed",
                fields: {
                    analyzed: {
                        type: "string"
                    }
                },
                include_in_all: true,
                ignore_above: 30000
            },
            zip_code: {
                type: "string",
                index: "not_analyzed",
                fields: {
                    analyzed: {
                        type: "string"
                    }
                },
                include_in_all: true,
                ignore_above: 30000
            }
        }
    }
}
