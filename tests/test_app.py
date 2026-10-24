from fastapi.testclient import TestClient
import app as app_module

client = TestClient(app_module.app)


def test_homepage_loads():
    response = client.get("/")
    assert response.status_code == 200
    assert "Syllabus AI Agent" in response.text
    assert "Gemini" in response.text


def test_rejects_non_pdf():
    response = client.post(
        "/api/analyze",
        data={"email_text": "When is the homework due?"},
        files={"syllabus_file": ("notes.txt", b"hello", "text/plain")},
    )
    assert response.status_code == 400
