using UnityEngine;
using UnityEngine.SceneManagement;

public class ButtonM : MonoBehaviour
{

    public void OnStartGameButtonClicked()
    {
        SceneManager.LoadScene("Arkanoid");
    }

    public void OnLeaveGameButtonClicked()
    {
        SceneManager.LoadScene("MainMenu");
    }

    public void OnCreditGameButtonClicked()
    {
        SceneManager.LoadScene("Credits");
    }
    public void OnExitGameButtonClicked()
    {
        Application.Quit();

        Debug.Log("CerrandoJuego");
    }
}