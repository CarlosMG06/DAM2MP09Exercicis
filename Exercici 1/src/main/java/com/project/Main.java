package com.project;

import java.util.concurrent.*;

public class Main {

    public static void main(String[] args) throws InterruptedException {
        ConcurrentHashMap<String, Double> dades = new ConcurrentHashMap<>();

        ExecutorService executor = Executors.newFixedThreadPool(3);

        Runnable recepcioOperacio = () -> {
            try {
                System.out.println("Rebent operació bancària...");
                dades.put("saldo", 1000.0);
                dades.put("interes", 0.05);
                System.out.println("Saldo inicial: " + dades.get("saldo") + "€");
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        };

        Runnable calculInteres = () -> {
            try {
                while (!dades.containsKey("saldo") || !dades.containsKey("interes")) {
                    Thread.sleep(50); // Espera fins que les dades estiguin disponibles
                }
                System.out.println("Calculant interessos...");
                double saldo = dades.get("saldo");
                double interes = dades.get("interes");
                dades.put("saldo", saldo + (saldo * interes));
                System.out.println("Interès aplicat.");
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        };

        Callable<Double> obtenirSaldoFinal = () -> {
            while (!dades.containsKey("saldo") || dades.get("saldo") == 1000.0) {
                Thread.sleep(50); // Espera fins que el saldo estigui disponible
            }
            return dades.get("saldo");
        };

        executor.execute(registrarEsdeveniment);
        executor.execute(comprovarEstatDeXarxa);

        executor.shutdown();
        executor.awaitTermination(10, TimeUnit.SECONDS);
    }
}
