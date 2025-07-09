#include <wx/wx.h>
#include <wx/slider.h>
#include <wx/choice.h>
#include <filesystem>
#include <fstream>
#include <nlohmann/json.hpp>

namespace fs = std::filesystem;

class VaaniyConfig : public wxFrame {
private:
    wxChoice* countryChoice;
    wxChoice* voiceChoice;
    wxSlider* volumeSlider;
    wxSlider* pitchSlider;
    wxSlider* speedSlider;
    wxStaticText* volumeLabel;
    wxStaticText* pitchLabel;
    wxStaticText* speedLabel;
    wxButton* testButton;
    wxButton* applyButton;
    wxButton* cancelButton;

    std::map<std::string, std::vector<std::string>> voicesByCountry;

    void LoadVoices(const std::string& path) {
        voicesByCountry.clear();
        for (const auto& entry : fs::directory_iterator(path)) {
            if (entry.path().extension() == ".json") {
                std::ifstream file(entry.path());
                nlohmann::json j;
                file >> j;

                std::string country = j["language"]["country_english"];
                std::string voice = j["dataset"];

                voicesByCountry[country].push_back(voice);
            }
        }

        // Populate country dropdown
        countryChoice->Clear();
        for (const auto& [country, _] : voicesByCountry) {
            countryChoice->AppendString(country);
        }
    }

    void OnCountrySelect(wxCommandEvent& event) {
        std::string selectedCountry = countryChoice->GetStringSelection().ToStdString();

        // Populate voice dropdown
        voiceChoice->Clear();
        if (voicesByCountry.find(selectedCountry) != voicesByCountry.end()) {
            for (const auto& voice : voicesByCountry[selectedCountry]) {
                voiceChoice->AppendString(voice);
            }
        }
    }

public:
    VaaniyConfig(const std::string& path)
        : wxFrame(nullptr, wxID_ANY, "Vaaniy Configurations", wxDefaultPosition, wxSize(500, 700)) {
        wxPanel* panel = new wxPanel(this);

        wxBoxSizer* mainSizer = new wxBoxSizer(wxVERTICAL);

        countryChoice = new wxChoice(panel, wxID_ANY);
        voiceChoice = new wxChoice(panel, wxID_ANY);

        volumeSlider = new wxSlider(panel, wxID_ANY, 50, 0, 100, wxDefaultPosition, wxDefaultSize, wxSL_HORIZONTAL);
        pitchSlider = new wxSlider(panel, wxID_ANY, 50, 0, 100, wxDefaultPosition, wxDefaultSize, wxSL_HORIZONTAL);
        speedSlider = new wxSlider(panel, wxID_ANY, 50, 0, 100, wxDefaultPosition, wxDefaultSize, wxSL_HORIZONTAL);

        volumeLabel = new wxStaticText(panel, wxID_ANY, "Volume: 50%");
        pitchLabel = new wxStaticText(panel, wxID_ANY, "Pitch: 50%");
        speedLabel = new wxStaticText(panel, wxID_ANY, "Speed: 50%");

        testButton = new wxButton(panel, wxID_ANY, "Test");
        applyButton = new wxButton(panel, wxID_ANY, "Apply");
        cancelButton = new wxButton(panel, wxID_ANY, "Cancel");

        // Layout
        mainSizer->Add(new wxStaticText(panel, wxID_ANY, "Country:"), 0, wxALL, 5);
        mainSizer->Add(countryChoice, 0, wxEXPAND | wxALL, 5);

        mainSizer->Add(new wxStaticText(panel, wxID_ANY, "Voice Name:"), 0, wxALL, 5);
        mainSizer->Add(voiceChoice, 0, wxEXPAND | wxALL, 5);

        mainSizer->Add(volumeLabel, 0, wxALL, 5);
        mainSizer->Add(volumeSlider, 0, wxEXPAND | wxALL, 5);

        mainSizer->Add(pitchLabel, 0, wxALL, 5);
        mainSizer->Add(pitchSlider, 0, wxEXPAND | wxALL, 5);

        mainSizer->Add(speedLabel, 0, wxALL, 5);
        mainSizer->Add(speedSlider, 0, wxEXPAND | wxALL, 5);

        mainSizer->Add(testButton, 0, wxALIGN_CENTER | wxALL, 5);
        mainSizer->Add(applyButton, 0, wxALIGN_CENTER | wxALL, 5);
        mainSizer->Add(cancelButton, 0, wxALIGN_CENTER | wxALL, 5);

        panel->SetSizer(mainSizer);

        // Load voices
        LoadVoices(path);

        // Events
        countryChoice->Bind(wxEVT_CHOICE, &VaaniyConfig::OnCountrySelect, this);
    }
};

class MyApp : public wxApp {
public:
    virtual bool OnInit() {
        std::string path = "~/applications/vaaniy/config/voices/";
        if (argc > 1) {
            path = argv[1];
        }

        VaaniyConfig* frame = new VaaniyConfig(path);
        frame->Show(true);
        return true;
    }
};

wxIMPLEMENT_APP(MyApp);

